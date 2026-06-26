import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_draft.dart';

/// Maps [AddAdDraft] + uploaded media URLs to a Firestore document.
class PropertyListingFirestoreDto {
  PropertyListingFirestoreDto._();

  static Map<String, dynamic> toCreateMap({
    required AddAdDraft draft,
    required String ownerUid,
    String? ownerPhone,
    required List<String> imageUrls,
    String? videoUrl,
  }) {
    final rent = double.tryParse(
      draft.monthlyRentText.replaceAll(',', '').trim(),
    );
    final sqm = double.tryParse(
      draft.roomSizeText.replaceAll(',', '').trim(),
    );

    final phone = ownerPhone?.trim();

    return {
      'ownerId': ownerUid,
      if (phone != null && phone.isNotEmpty) 'ownerPhone': phone,
      'propertyType': draft.propertyType!.name,
      'genderPreference': draft.genderPreference.name,
      'studyFieldIds': List<String>.from(draft.studyFieldIds)..sort(),
      'governorate': draft.governorate,
      'district': draft.district,
      'latitude': draft.latitude,
      'longitude': draft.longitude,
      'addressLine': draft.addressLine,
      'monthlyRent': rent,
      'utilitiesIncluded': draft.utilitiesIncluded,
      'totalBeds': draft.totalBeds,
      'bedsAvailable': draft.bedsAvailable,
      'bathrooms': draft.bathrooms,
      'roomSizeSqm': sqm,
      'amenityIds': List<String>.from(draft.amenityIds)..sort(),
      'imageUrls': imageUrls,
      'videoUrl': videoUrl,
      'geo': GeoPoint(draft.latitude!, draft.longitude!),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'status': 'active',
      'ratingAverage': 0,
      'ratingCount': 0,
      'reviewCount': 0,
    };
  }

  static Map<String, dynamic> toUpdateMap({
    required AddAdDraft draft,
    String? ownerPhone,
    required List<String> imageUrls,
    String? videoUrl,
  }) {
    final rent = double.tryParse(
      draft.monthlyRentText.replaceAll(',', '').trim(),
    );
    final sqm = double.tryParse(
      draft.roomSizeText.replaceAll(',', '').trim(),
    );
    final phone = ownerPhone?.trim();
    return {
      if (phone != null && phone.isNotEmpty) 'ownerPhone': phone,
      'propertyType': draft.propertyType!.name,
      'genderPreference': draft.genderPreference.name,
      'studyFieldIds': List<String>.from(draft.studyFieldIds)..sort(),
      'governorate': draft.governorate,
      'district': draft.district,
      'latitude': draft.latitude,
      'longitude': draft.longitude,
      'addressLine': draft.addressLine,
      'monthlyRent': rent,
      'utilitiesIncluded': draft.utilitiesIncluded,
      'totalBeds': draft.totalBeds,
      'bedsAvailable': draft.bedsAvailable,
      'bathrooms': draft.bathrooms,
      'roomSizeSqm': sqm,
      'amenityIds': List<String>.from(draft.amenityIds)..sort(),
      'imageUrls': imageUrls,
      'videoUrl': videoUrl,
      'geo': GeoPoint(draft.latitude!, draft.longitude!),
      'updatedAt': FieldValue.serverTimestamp(),
      'status': 'active',
    };
  }
}
