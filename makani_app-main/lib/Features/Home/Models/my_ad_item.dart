/// Placeholder model for a user's ad in the My Ads list.
class MyAdItem {
  const MyAdItem({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    this.imageUrl,
    required this.isShared,
    required this.isAvailable,
  });

  final String id;
  final String title;
  final String location;
  final String price;
  final String? imageUrl;
  final bool isShared;
  final bool isAvailable;

  MyAdItem copyWith({
    String? id,
    String? title,
    String? location,
    String? price,
    String? imageUrl,
    bool? isShared,
    bool? isAvailable,
  }) {
    return MyAdItem(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isShared: isShared ?? this.isShared,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
