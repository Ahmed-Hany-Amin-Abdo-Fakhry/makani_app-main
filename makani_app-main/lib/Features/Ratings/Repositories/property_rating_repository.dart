import 'package:makani_app/Features/Ratings/Model/rating_review.dart';
import 'package:makani_app/Features/Ratings/Services/property_rating_firestore_service.dart';

abstract class PropertyRatingRepository {
  Future<List<RatingReview>> fetchReviewsByListing(
    String listingId, {
    int limit = 100,
  });

  Future<RatingReviewUpsertStatus> upsertReview({
    required String listingId,
    required String reviewerUid,
    required String reviewerName,
    required int rating,
    String? reviewText,
  });
}
