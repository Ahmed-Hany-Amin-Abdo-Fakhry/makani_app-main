import 'package:intl/intl.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_enums.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_l10n_helpers.dart';
import 'package:makani_app/Features/Listings/Model/property_listing.dart';
import 'package:makani_app/generated/l10n.dart';

AddAdPropertyType? parsePropertyTypeKey(String key) {
  for (final t in AddAdPropertyType.values) {
    if (t.name == key) return t;
  }
  return null;
}

AddAdGenderPreference? parseGenderPreferenceKey(String key) {
  for (final g in AddAdGenderPreference.values) {
    if (g.name == key) return g;
  }
  return null;
}

/// Strings for [PropertyCard] / [AiRecommendationCard].
class ListingCardViewModel {
  const ListingCardViewModel({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    this.rating,
    this.imageUrl,
    this.gender,
    this.beds,
    this.baths,
    this.categoryTags,
  });

  final String id;
  final String title;
  final String location;
  final String price;
  final String? rating;
  final String? imageUrl;
  final String? gender;
  final String? beds;
  final String? baths;
  final List<String>? categoryTags;
}

String formatListingRent(double? rent) {
  if (rent == null) return '—';
  final fmt = NumberFormat('#,###', 'en_US');
  return fmt.format(rent);
}

ListingCardViewModel listingToCardViewModel(S s, PropertyListing p) {
  final type = parsePropertyTypeKey(p.propertyTypeKey);
  final title = type != null
      ? addAdPropertyTypeLabel(s, type)
      : p.propertyTypeKey;

  final loc = (p.addressLine != null && p.addressLine!.trim().isNotEmpty)
      ? p.addressLine!.trim()
      : [p.district, p.governorate]
          .whereType<String>()
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .join(', ');

  final gender = parseGenderPreferenceKey(p.genderPreferenceKey);
  final genderKey = gender == AddAdGenderPreference.male
      ? 'male'
      : gender == AddAdGenderPreference.female
          ? 'female'
          : null;

  final categories = p.studyFieldIds
      .map((id) => addAdStudyLabel(s, id))
      .toList();

  return ListingCardViewModel(
    id: p.id,
    title: title,
    location: loc.isEmpty ? '—' : loc,
    price: formatListingRent(p.monthlyRent),
    rating: ((p.ratingCount ?? 0) > 0 && p.ratingAverage != null)
        ? p.ratingAverage!.toStringAsFixed(1)
        : null,
    imageUrl: p.imageUrls.isNotEmpty ? p.imageUrls.first : null,
    gender: genderKey,
    beds: p.totalBeds?.toString(),
    baths: p.bathrooms?.toString(),
    categoryTags: categories.isEmpty ? null : categories,
  );
}
