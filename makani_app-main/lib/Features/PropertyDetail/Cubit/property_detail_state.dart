import 'package:makani_app/Features/Listings/Model/property_listing.dart';
import 'package:makani_app/Features/Ratings/Model/rating_review.dart';

sealed class PropertyDetailState {
  const PropertyDetailState();
}

final class PropertyDetailInitial extends PropertyDetailState {
  const PropertyDetailInitial();
}

final class PropertyDetailLoading extends PropertyDetailState {
  const PropertyDetailLoading();
}

final class PropertyDetailLoaded extends PropertyDetailState {
  const PropertyDetailLoaded({
    required this.listing,
    this.reviews = const [],
    this.ownerPhone,
  });

  final PropertyListing listing;
  final List<RatingReview> reviews;
  final String? ownerPhone;
}

final class PropertyDetailNotFound extends PropertyDetailState {
  const PropertyDetailNotFound();
}

final class PropertyDetailFailure extends PropertyDetailState {
  const PropertyDetailFailure({required this.message});

  final String message;
}
