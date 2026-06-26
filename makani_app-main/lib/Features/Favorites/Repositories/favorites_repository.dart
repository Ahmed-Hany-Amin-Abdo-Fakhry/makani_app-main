import 'package:makani_app/Features/Listings/Model/property_listing.dart';

abstract class FavoritesRepository {
  Future<List<PropertyListing>> loadFavoriteListings(String uid);

  Future<void> addFavorite(String uid, String listingId);

  Future<void> removeFavorite(String uid, String listingId);
}
