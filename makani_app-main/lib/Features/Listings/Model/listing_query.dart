import 'package:equatable/equatable.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_enums.dart';
import 'package:makani_app/Features/Listings/Data/geo_distance_km.dart';
import 'package:makani_app/Features/Listings/Model/property_listing.dart';

/// Client-side filters applied after a capped Firestore batch (newest first).
class ListingQuery extends Equatable {
  const ListingQuery({
    this.minMonthlyRent,
    this.maxMonthlyRent,
    this.minTotalBeds,
    this.studyFieldIds = const [],
    this.maxDistanceKm,
    this.userLatitude,
    this.userLongitude,
    this.genderFilter,
    this.propertyTypeFilter,
  });

  final double? minMonthlyRent;
  final double? maxMonthlyRent;
  final int? minTotalBeds;
  final List<String> studyFieldIds;
  final double? maxDistanceKm;
  final double? userLatitude;
  final double? userLongitude;

  /// When non-null and not [AddAdGenderPreference.any], feed must match listing gender key.
  final AddAdGenderPreference? genderFilter;

  /// When non-null, feed must match listing [PropertyListing.propertyTypeKey].
  final AddAdPropertyType? propertyTypeFilter;

  static const ListingQuery empty = ListingQuery();

  bool get hasPredicate =>
      minMonthlyRent != null ||
      maxMonthlyRent != null ||
      minTotalBeds != null ||
      studyFieldIds.isNotEmpty ||
      (maxDistanceKm != null &&
          userLatitude != null &&
          userLongitude != null) ||
      (genderFilter != null && genderFilter != AddAdGenderPreference.any) ||
      propertyTypeFilter != null;

  /// Feed row must be active; other predicates optional.
  bool matchesListing(PropertyListing p) {
    if (minMonthlyRent != null) {
      if (p.monthlyRent == null || p.monthlyRent! < minMonthlyRent!) {
        return false;
      }
    }
    if (maxMonthlyRent != null) {
      if (p.monthlyRent == null || p.monthlyRent! > maxMonthlyRent!) {
        return false;
      }
    }
    if (minTotalBeds != null) {
      if (p.totalBeds == null || p.totalBeds! < minTotalBeds!) {
        return false;
      }
    }
    if (studyFieldIds.isNotEmpty) {
      final hit = studyFieldIds.any(p.studyFieldIds.contains);
      if (!hit) return false;
    }
    if (maxDistanceKm != null &&
        userLatitude != null &&
        userLongitude != null) {
      final plat = p.latitude;
      final plng = p.longitude;
      if (plat != null && plng != null) {
        final km = haversineDistanceKm(
          userLatitude!,
          userLongitude!,
          plat,
          plng,
        );
        if (km > maxDistanceKm!) return false;
      }
    }
    final g = genderFilter;
    if (g != null && g != AddAdGenderPreference.any) {
      if (p.genderPreferenceKey != g.name) return false;
    }
    final pt = propertyTypeFilter;
    if (pt != null) {
      if (p.propertyTypeKey != pt.name) return false;
    }
    return true;
  }

  static bool matchesSearchText(PropertyListing p, String normalizedQuery) {
    if (normalizedQuery.isEmpty) return true;
    final g = p.governorate?.toLowerCase() ?? '';
    final d = p.district?.toLowerCase() ?? '';
    final a = p.addressLine?.toLowerCase() ?? '';
    return g.contains(normalizedQuery) ||
        d.contains(normalizedQuery) ||
        a.contains(normalizedQuery);
  }

  @override
  List<Object?> get props => [
        minMonthlyRent,
        maxMonthlyRent,
        minTotalBeds,
        studyFieldIds,
        maxDistanceKm,
        userLatitude,
        userLongitude,
        genderFilter,
        propertyTypeFilter,
      ];
}
