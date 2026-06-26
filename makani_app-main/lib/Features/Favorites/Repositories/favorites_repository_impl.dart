import 'package:makani_app/Features/Favorites/Repositories/favorites_repository.dart';
import 'package:makani_app/Features/Favorites/Services/favorites_firestore_service.dart';
import 'package:makani_app/Features/Listings/Model/property_listing.dart';
import 'package:makani_app/Features/Listings/Repositories/listings_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._favorites, this._listings);

  final FavoritesFirestoreService _favorites;
  final ListingsRepository _listings;

  @override
  Future<List<PropertyListing>> loadFavoriteListings(String uid) async {
    final ids = await _favorites.favoriteListingIdsOrdered(uid);
    if (ids.isEmpty) return [];
    final listings = await Future.wait(
      ids.map(_listings.getListingById),
    );
    return listings.whereType<PropertyListing>().toList();
  }

  @override
  Future<void> addFavorite(String uid, String listingId) =>
      _favorites.addFavorite(uid, listingId);

  @override
  Future<void> removeFavorite(String uid, String listingId) =>
      _favorites.removeFavorite(uid, listingId);
}
