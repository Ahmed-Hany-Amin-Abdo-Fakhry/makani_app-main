import 'package:equatable/equatable.dart';
import 'package:makani_app/Features/Listings/Model/property_listing.dart';

class HomeRecommendation extends Equatable {
  const HomeRecommendation({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    this.rating,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String location;
  final String price;
  final String? rating;
  final String? imageUrl;

  factory HomeRecommendation.fromJson(Map<String, dynamic> json) {
    return HomeRecommendation(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      price: (json['price'] ?? '').toString(),
      rating: json['rating']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
    );
  }

  factory HomeRecommendation.fromListing(PropertyListing listing) {
    final location =
        (listing.addressLine != null && listing.addressLine!.trim().isNotEmpty)
            ? listing.addressLine!.trim()
            : [listing.district, listing.governorate]
                .whereType<String>()
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .join(', ');

    final title = listing.propertyTypeKey.trim().isNotEmpty
        ? listing.propertyTypeKey
        : 'Listing';

    return HomeRecommendation(
      id: listing.id,
      title: title,
      location: location.isEmpty ? '—' : location,
      price: _formatPrice(listing.monthlyRent),
      imageUrl: listing.imageUrls.isNotEmpty ? listing.imageUrls.first : null,
    );
  }

  static String _formatPrice(double? value) {
    if (value == null) return '—';
    return value.toStringAsFixed(0);
  }

  @override
  List<Object?> get props => [id, title, location, price, rating, imageUrl];
}
