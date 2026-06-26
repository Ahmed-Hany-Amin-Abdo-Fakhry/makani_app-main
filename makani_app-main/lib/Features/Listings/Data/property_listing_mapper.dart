import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makani_app/Features/Listings/Model/property_listing.dart';

class PropertyListingMapper {
  PropertyListingMapper._();

  static PropertyListing fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final d = doc.data();
    if (d == null) {
      return PropertyListing(
        id: doc.id,
        ownerId: '',
        propertyTypeKey: 'singleBed',
        genderPreferenceKey: 'any',
        studyFieldIds: const [],
        amenityIds: const [],
        imageUrls: const [],
        ratingAverage: 0,
        ratingCount: 0,
        reviewCount: 0,
      );
    }

    final geo = d['geo'] as GeoPoint?;
    final lat = (d['latitude'] as num?)?.toDouble() ?? geo?.latitude;
    final lng = (d['longitude'] as num?)?.toDouble() ?? geo?.longitude;

    final studyRaw = d['studyFieldIds'];
    final study = studyRaw is List
        ? studyRaw.map((e) => e.toString()).toList()
        : <String>[];

    final amenityRaw = d['amenityIds'];
    final amenities = amenityRaw is List
        ? amenityRaw.map((e) => e.toString()).toList()
        : <String>[];

    final imagesRaw = d['imageUrls'];
    final images = imagesRaw is List
        ? imagesRaw.map((e) => e.toString()).toList()
        : <String>[];

    DateTime? createdAt;
    final c = d['createdAt'];
    if (c is Timestamp) {
      createdAt = c.toDate();
    }

    return PropertyListing(
      id: doc.id,
      ownerId: d['ownerId'] as String? ?? '',
      ownerPhone: d['ownerPhone'] as String?,
      propertyTypeKey: d['propertyType'] as String? ?? 'singleBed',
      genderPreferenceKey: d['genderPreference'] as String? ?? 'any',
      studyFieldIds: study,
      governorate: d['governorate'] as String?,
      district: d['district'] as String?,
      latitude: lat,
      longitude: lng,
      addressLine: d['addressLine'] as String?,
      monthlyRent: (d['monthlyRent'] as num?)?.toDouble(),
      utilitiesIncluded: d['utilitiesIncluded'] as bool?,
      totalBeds: (d['totalBeds'] as num?)?.toInt(),
      bedsAvailable: (d['bedsAvailable'] as num?)?.toInt(),
      bathrooms: (d['bathrooms'] as num?)?.toInt(),
      roomSizeSqm: (d['roomSizeSqm'] as num?)?.toDouble(),
      amenityIds: amenities,
      imageUrls: images,
      videoUrl: d['videoUrl'] as String?,
      status: d['status'] as String?,
      createdAt: createdAt,
      ratingAverage: (d['ratingAverage'] as num?)?.toDouble() ?? 0,
      ratingCount: (d['ratingCount'] as num?)?.toInt() ?? 0,
      reviewCount: (d['reviewCount'] as num?)?.toInt() ?? 0,
    );
  }
}
