import 'package:makani_app/Features/AddAd/Services/property_listing_firestore_service.dart';
import 'package:makani_app/Features/Listings/Data/property_listing_mapper.dart';
import 'package:makani_app/Features/Listings/Model/listing_query.dart';
import 'package:makani_app/Features/Listings/Model/property_listing.dart';
import 'package:makani_app/Features/Listings/Repositories/listings_repository.dart';

class ListingsRepositoryImpl implements ListingsRepository {
  ListingsRepositoryImpl(this._service);

  final PropertyListingFirestoreService _service;

  @override
  Future<List<PropertyListing>> fetchListings({
    ListingQuery query = ListingQuery.empty,
    String? searchText,
    int limit = 80,
    int fetchCap = 200,
  }) async {
    final docs = await _service.fetchNewestListingsBatch(fetchCap: fetchCap);
    final listings =
        docs.map(PropertyListingMapper.fromFirestore).toList(growable: false);
    final q = searchText?.trim().toLowerCase() ?? '';
    final out = <PropertyListing>[];
    for (final p in listings) {
      if (p.status != 'active') continue;
      if (!query.matchesListing(p)) continue;
      if (!ListingQuery.matchesSearchText(p, q)) continue;
      out.add(p);
      if (out.length >= limit) break;
    }
    return out;
  }

  @override
  Future<List<PropertyListing>> fetchActiveListings({int limit = 80}) async {
    return fetchListings(
      query: ListingQuery.empty,
      searchText: null,
      limit: limit,
    );
  }

  @override
  Future<List<PropertyListing>> fetchListingsByOwner(String ownerId) async {
    final docs = await _service.fetchListingsByOwner(ownerId);
    return docs.map(PropertyListingMapper.fromFirestore).toList();
  }

  @override
  Future<void> deleteListing(String id) => _service.deleteListing(id);

  @override
  Future<void> setListingStatus(String id, String status) =>
      _service.updateListingStatus(id, status);

  @override
  Future<PropertyListing?> getListingById(String id) async {
    final doc = await _service.getListingDocument(id);
    if (doc == null) return null;
    return PropertyListingMapper.fromFirestore(doc);
  }
}
