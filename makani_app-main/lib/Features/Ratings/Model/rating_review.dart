import 'package:equatable/equatable.dart';

class RatingReview extends Equatable {
  const RatingReview({
    required this.listingId,
    required this.reviewerUid,
    this.reviewerName,
    required this.rating,
    this.reviewText,
    this.createdAt,
    this.updatedAt,
  });

  final String listingId;
  final String reviewerUid;
  final String? reviewerName;
  final int rating;
  final String? reviewText;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get hasReviewText => (reviewText ?? '').trim().isNotEmpty;

  @override
  List<Object?> get props => [
        listingId,
        reviewerUid,
        reviewerName,
        rating,
        reviewText,
        createdAt,
        updatedAt,
      ];
}
