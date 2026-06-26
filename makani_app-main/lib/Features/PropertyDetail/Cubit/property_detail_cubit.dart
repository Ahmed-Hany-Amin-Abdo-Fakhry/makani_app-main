import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makani_app/Features/Auth/Services/user_profile_service.dart';
import 'package:makani_app/Features/Listings/Repositories/listings_repository.dart';
import 'package:makani_app/Features/PropertyDetail/Cubit/property_detail_state.dart';
import 'package:makani_app/Features/Ratings/Repositories/property_rating_repository.dart';
import 'package:makani_app/Features/Ratings/Services/property_rating_firestore_service.dart';

enum PropertyReviewSubmitStatus {
  submitted,
  updated,
  invalidInput,
  ownerNotAllowed,
  notLoaded,
  notFound,
}

class PropertyDetailCubit extends Cubit<PropertyDetailState> {
  PropertyDetailCubit(
    this._listings,
    this._userProfiles,
    this._ratings,
    this.listingId,
  ) : super(const PropertyDetailInitial());

  final ListingsRepository _listings;
  final UserProfileService _userProfiles;
  final PropertyRatingRepository _ratings;
  final String listingId;

  Future<void> load() async {
    if (listingId.isEmpty) {
      emit(const PropertyDetailNotFound());
      return;
    }
    emit(const PropertyDetailLoading());
    try {
      final listing = await _listings.getListingById(listingId);
      if (listing == null) {
        emit(const PropertyDetailNotFound());
        return;
      }
      final reviews = await _ratings.fetchReviewsByListing(listingId);
      final ownerPhone = _resolveOwnerPhone(listing.ownerPhone);
      emit(
        PropertyDetailLoaded(
          listing: listing,
          reviews: reviews,
          ownerPhone: ownerPhone,
        ),
      );
    } catch (e) {
      emit(PropertyDetailFailure(message: e.toString()));
    }
  }

  Future<PropertyReviewSubmitStatus> submitReview({
    required String reviewerUid,
    required int rating,
    String? reviewText,
  }) async {
    final current = state;
    if (current is! PropertyDetailLoaded) {
      return PropertyReviewSubmitStatus.notLoaded;
    }
    if (reviewerUid.isEmpty || rating < 1 || rating > 5) {
      return PropertyReviewSubmitStatus.invalidInput;
    }
    if (reviewerUid == current.listing.ownerId) {
      return PropertyReviewSubmitStatus.ownerNotAllowed;
    }
    RatingReviewUpsertStatus upsertStatus;
    try {
      final profile = await _userProfiles.getUserProfile(reviewerUid);
      final reviewerName = profile.fullName.trim();
      if (reviewerName.isEmpty) {
        return PropertyReviewSubmitStatus.invalidInput;
      }
      upsertStatus = await _ratings.upsertReview(
        listingId: listingId,
        reviewerUid: reviewerUid,
        reviewerName: reviewerName,
        rating: rating,
        reviewText: reviewText,
      );
    } catch (_) {
      return PropertyReviewSubmitStatus.invalidInput;
    }

    switch (upsertStatus) {
      case RatingReviewUpsertStatus.submitted:
        await _reloadLoaded(ownerPhoneHint: current.ownerPhone);
        return PropertyReviewSubmitStatus.submitted;
      case RatingReviewUpsertStatus.updated:
        await _reloadLoaded(ownerPhoneHint: current.ownerPhone);
        return PropertyReviewSubmitStatus.updated;
      case RatingReviewUpsertStatus.invalidInput:
        return PropertyReviewSubmitStatus.invalidInput;
      case RatingReviewUpsertStatus.listingNotFound:
        return PropertyReviewSubmitStatus.notFound;
    }
  }

  Future<void> _reloadLoaded({String? ownerPhoneHint}) async {
    final listing = await _listings.getListingById(listingId);
    if (listing == null) {
      emit(const PropertyDetailNotFound());
      return;
    }
    final reviews = await _ratings.fetchReviewsByListing(listingId);
    final ownerPhone = _resolveOwnerPhone(ownerPhoneHint ?? listing.ownerPhone);
    emit(
      PropertyDetailLoaded(
        listing: listing,
        reviews: reviews,
        ownerPhone: ownerPhone,
      ),
    );
  }

  Future<String?> ensureOwnerPhoneAvailable() async {
    final current = state;
    if (current is! PropertyDetailLoaded) return null;

    final resolvedPhone =
        _resolveOwnerPhone(current.ownerPhone ?? current.listing.ownerPhone);

    if (resolvedPhone != current.ownerPhone) {
      emit(
        PropertyDetailLoaded(
          listing: current.listing,
          reviews: current.reviews,
          ownerPhone: resolvedPhone,
        ),
      );
    }
    return resolvedPhone;
  }

  String? _resolveOwnerPhone(String? listingPhoneHint) {
    final hint = listingPhoneHint?.trim();
    if (hint != null && hint.isNotEmpty) return hint;
    return null;
  }
}
