import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makani_app/Features/Ratings/Model/rating_review.dart';

enum RatingReviewUpsertStatus {
  submitted,
  updated,
  invalidInput,
  listingNotFound,
}

class RatingAggregates extends Object {
  const RatingAggregates({
    required this.ratingAverage,
    required this.ratingCount,
    required this.reviewCount,
  });

  final double ratingAverage;
  final int ratingCount;
  final int reviewCount;
}

RatingAggregates computeNextRatingAggregates({
  required double currentAverage,
  required int currentRatingCount,
  required int currentReviewCount,
  int? existingRating,
  required int nextRating,
  String? existingReviewText,
  required String nextReviewText,
}) {
  final safeCurrentRatingCount = currentRatingCount < 0 ? 0 : currentRatingCount;
  final safeCurrentReviewCount = currentReviewCount < 0 ? 0 : currentReviewCount;
  final hadExistingReview = existingRating != null;
  final hadText = (existingReviewText ?? '').trim().isNotEmpty;
  final hasText = nextReviewText.trim().isNotEmpty;

  late final int nextRatingCount;
  late final double nextAverage;
  late final int nextReviewCount;

  if (hadExistingReview) {
    nextRatingCount = safeCurrentRatingCount <= 0 ? 1 : safeCurrentRatingCount;
    final oldSum = currentAverage * nextRatingCount;
    nextAverage = (oldSum - existingRating + nextRating) / nextRatingCount;
    nextReviewCount = safeCurrentReviewCount + (hasText ? 1 : 0) - (hadText ? 1 : 0);
  } else {
    nextRatingCount = safeCurrentRatingCount + 1;
    nextAverage =
        ((currentAverage * safeCurrentRatingCount) + nextRating) / nextRatingCount;
    nextReviewCount = safeCurrentReviewCount + (hasText ? 1 : 0);
  }

  return RatingAggregates(
    ratingAverage: nextAverage,
    ratingCount: nextRatingCount,
    reviewCount: nextReviewCount < 0 ? 0 : nextReviewCount,
  );
}

class PropertyRatingFirestoreService {
  PropertyRatingFirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  static const listingsCollectionPath = 'listings';
  static const reviewsCollectionPath = 'reviews';

  CollectionReference<Map<String, dynamic>> get _listings =>
      _db.collection(listingsCollectionPath);

  CollectionReference<Map<String, dynamic>> _reviewsCollection(String listingId) =>
      _listings.doc(listingId).collection(reviewsCollectionPath);

  Future<List<RatingReview>> fetchReviewsByListing(
    String listingId, {
    int limit = 100,
  }) async {
    if (listingId.isEmpty) return const [];
    final snap = await _reviewsCollection(listingId)
        .orderBy('updatedAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map(_mapReviewDoc).toList(growable: false);
  }

  Future<RatingReviewUpsertStatus> upsertReview({
    required String listingId,
    required String reviewerUid,
    required String reviewerName,
    required int rating,
    String? reviewText,
  }) async {
    final trimmedText = reviewText?.trim() ?? '';
    final trimmedReviewerName = reviewerName.trim();
    if (listingId.isEmpty ||
        reviewerUid.isEmpty ||
        trimmedReviewerName.isEmpty ||
        rating < 1 ||
        rating > 5) {
      return RatingReviewUpsertStatus.invalidInput;
    }

    final listingRef = _listings.doc(listingId);
    final reviewRef = _reviewsCollection(listingId).doc(reviewerUid);

    return _db.runTransaction((txn) async {
      final listingSnap = await txn.get(listingRef);
      if (!listingSnap.exists) {
        return RatingReviewUpsertStatus.listingNotFound;
      }

      final listingData = listingSnap.data() ?? <String, dynamic>{};
      final reviewSnap = await txn.get(reviewRef);
      final now = FieldValue.serverTimestamp();

      late final RatingReviewUpsertStatus status;
      late final RatingAggregates aggregates;

      if (reviewSnap.exists) {
        final oldReviewData = reviewSnap.data() ?? <String, dynamic>{};
        final oldRating = (oldReviewData['rating'] as num?)?.toInt() ?? rating;
        final oldText = (oldReviewData['reviewText'] as String?)?.trim() ?? '';
        aggregates = computeNextRatingAggregates(
          currentAverage: (listingData['ratingAverage'] as num?)?.toDouble() ?? 0.0,
          currentRatingCount: (listingData['ratingCount'] as num?)?.toInt() ?? 0,
          currentReviewCount: (listingData['reviewCount'] as num?)?.toInt() ?? 0,
          existingRating: oldRating,
          nextRating: rating,
          existingReviewText: oldText,
          nextReviewText: trimmedText,
        );
        status = RatingReviewUpsertStatus.updated;
      } else {
        aggregates = computeNextRatingAggregates(
          currentAverage: (listingData['ratingAverage'] as num?)?.toDouble() ?? 0.0,
          currentRatingCount: (listingData['ratingCount'] as num?)?.toInt() ?? 0,
          currentReviewCount: (listingData['reviewCount'] as num?)?.toInt() ?? 0,
          existingRating: null,
          nextRating: rating,
          existingReviewText: null,
          nextReviewText: trimmedText,
        );
        status = RatingReviewUpsertStatus.submitted;
      }

      txn.set(
        reviewRef,
        {
          'listingId': listingId,
          'reviewerUid': reviewerUid,
          'reviewerName': trimmedReviewerName,
          'rating': rating,
          'reviewText': trimmedText,
          'updatedAt': now,
          if (!reviewSnap.exists) 'createdAt': now,
        },
        SetOptions(merge: true),
      );

      txn.update(listingRef, {
        'ratingAverage': aggregates.ratingAverage,
        'ratingCount': aggregates.ratingCount,
        'reviewCount': aggregates.reviewCount,
        'updatedAt': now,
      });

      return status;
    });
  }

  RatingReview _mapReviewDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? <String, dynamic>{};
    final createdAtTs = d['createdAt'] as Timestamp?;
    final updatedAtTs = d['updatedAt'] as Timestamp?;
    return RatingReview(
      listingId: d['listingId'] as String? ?? '',
      reviewerUid: d['reviewerUid'] as String? ?? doc.id,
      reviewerName: d['reviewerName'] as String?,
      rating: (d['rating'] as num?)?.toInt() ?? 0,
      reviewText: d['reviewText'] as String?,
      createdAt: createdAtTs?.toDate(),
      updatedAt: updatedAtTs?.toDate(),
    );
  }
}
