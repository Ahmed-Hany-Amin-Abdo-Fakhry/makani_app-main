import 'package:makani_app/Features/Ratings/Model/rating_review.dart';
import 'package:makani_app/Features/Ratings/Repositories/property_rating_repository.dart';
import 'package:makani_app/Features/Ratings/Services/property_rating_firestore_service.dart';

class PropertyRatingRepositoryImpl implements PropertyRatingRepository {
  PropertyRatingRepositoryImpl(this._service);

  final PropertyRatingFirestoreService _service;

  @override
  Future<List<RatingReview>> fetchReviewsByListing(
    String listingId, {
    int limit = 100,
  }) {
    return _service.fetchReviewsByListing(listingId, limit: limit);
  }

  @override
  Future<RatingReviewUpsertStatus> upsertReview({
    required String listingId,
    required String reviewerUid,
    required String reviewerName,
    required int rating,
    String? reviewText,
  }) {
    return _service.upsertReview(
      listingId: listingId,
      reviewerUid: reviewerUid,
      reviewerName: reviewerName,
      rating: rating,
      reviewText: reviewText,
    );
  }
}
