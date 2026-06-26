import 'package:makani_app/Features/Listings/Model/listing_query.dart';
import 'package:makani_app/Features/Listings/Model/property_listing.dart';

abstract class ListingsRepository {
  /// Active feed with client-side [query] and optional [searchText] (location fields).
  Future<List<PropertyListing>> fetchListings({
    ListingQuery query = ListingQuery.empty,
    String? searchText,
    int limit = 80,
    int fetchCap = 200,
  });

  Future<List<PropertyListing>> fetchActiveListings({int limit});

  Future<List<PropertyListing>> fetchListingsByOwner(String ownerId);

  Future<void> deleteListing(String id);

  Future<void> setListingStatus(String id, String status);

  /// Returns null if the document does not exist.
  Future<PropertyListing?> getListingById(String id);
}
