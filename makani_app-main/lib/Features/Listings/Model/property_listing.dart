import 'package:equatable/equatable.dart';

/// Firestore `listings` document as used by the home feed (read model).
class PropertyListing extends Equatable {
  const PropertyListing({
    required this.id,
    required this.ownerId,
    this.ownerPhone,
    required this.propertyTypeKey,
    required this.genderPreferenceKey,
    required this.studyFieldIds,
    this.governorate,
    this.district,
    this.latitude,
    this.longitude,
    this.addressLine,
    this.monthlyRent,
    this.utilitiesIncluded,
    this.totalBeds,
    this.bedsAvailable,
    this.bathrooms,
    this.roomSizeSqm,
    required this.amenityIds,
    required this.imageUrls,
    this.videoUrl,
    this.status,
    this.createdAt,
    this.ratingAverage,
    this.ratingCount,
    this.reviewCount,
  });

  final String id;
  final String ownerId;
  final String? ownerPhone;
  final String propertyTypeKey;
  final String genderPreferenceKey;
  final List<String> studyFieldIds;
  final String? governorate;
  final String? district;
  final double? latitude;
  final double? longitude;
  final String? addressLine;
  final double? monthlyRent;
  final bool? utilitiesIncluded;
  final int? totalBeds;
  final int? bedsAvailable;
  final int? bathrooms;
  final double? roomSizeSqm;
  final List<String> amenityIds;
  final List<String> imageUrls;
  final String? videoUrl;
  final String? status;
  final DateTime? createdAt;
  final double? ratingAverage;
  final int? ratingCount;
  final int? reviewCount;

  @override
  List<Object?> get props => [
        id,
        ownerId,
        ownerPhone,
        propertyTypeKey,
        genderPreferenceKey,
        studyFieldIds,
        governorate,
        district,
        latitude,
        longitude,
        addressLine,
        monthlyRent,
        utilitiesIncluded,
        totalBeds,
        bedsAvailable,
        bathrooms,
        roomSizeSqm,
        amenityIds,
        imageUrls,
        videoUrl,
        status,
        createdAt,
        ratingAverage,
        ratingCount,
        reviewCount,
      ];
}
