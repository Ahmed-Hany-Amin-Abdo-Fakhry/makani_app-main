import 'dart:developer' as developer;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Persists listing documents (metadata + Cloudinary URLs).
class PropertyListingFirestoreService {
  PropertyListingFirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  static const String collectionPath = 'listings';

  void _logIncomingDocs(
    String source,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    if (!kDebugMode) return;
    final preview = docs.take(3).map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'status': data['status'],
        'ownerId': data['ownerId'],
        'createdAt': data['createdAt'],
        'imagesCount': (data['imageUrls'] as List?)?.length ?? 0,
      };
    }).toList();

    developer.log(
      '[$source] fetched ${docs.length} listing docs | preview: $preview',
      name: 'firebase.listings',
    );
  }

  Future<String> createListing(Map<String, dynamic> data) async {
    final doc = await _db.collection(collectionPath).add(data);
    return doc.id;
  }

  Future<void> updateListing(
      String listingId, Map<String, dynamic> data) async {
    if (listingId.isEmpty) return;
    await _db.collection(collectionPath).doc(listingId).update(data);
  }

  /// Newest listings batch for client-side filter/search (no server `status` filter).
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      fetchNewestListingsBatch({
    int fetchCap = 200,
  }) async {
    final snap = await _db
        .collection(collectionPath)
        .orderBy('createdAt', descending: true)
        .limit(fetchCap)
        .get();
    _logIncomingDocs('fetchNewestListingsBatch', snap.docs);
    return snap.docs;
  }

  /// One-shot fetch for home (pull-to-refresh).
  ///
  /// Uses only `orderBy('createdAt')` so Firestore’s **single-field** index
  /// applies. Filtering `status == active` is done in memory to avoid a
  /// **composite** index on `status` + `createdAt`.
  ///
  /// Reads up to [fetchCap] newest docs, then keeps the first [limit] that are
  /// active (if many drafts/inactive exist among recent docs, increase [fetchCap]).
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      fetchActiveListings({
    int limit = 80,
    int fetchCap = 150,
  }) async {
    final docs = await fetchNewestListingsBatch(fetchCap: fetchCap);
    return docs
        .where((d) => (d.data()['status'] as String?) == 'active')
        .take(limit)
        .toList();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      fetchListingsByOwner(
    String ownerId,
  ) async {
    if (ownerId.isEmpty) return [];
    final snap = await _db
        .collection(collectionPath)
        .where('ownerId', isEqualTo: ownerId)
        .get();
    final docs = snap.docs.toList();
    int ts(QueryDocumentSnapshot<Map<String, dynamic>> d) {
      final c = d.data()['createdAt'];
      if (c is Timestamp) return c.millisecondsSinceEpoch;
      return 0;
    }

    docs.sort((a, b) => ts(b).compareTo(ts(a)));
    _logIncomingDocs('fetchListingsByOwner', docs);
    return docs;
  }

  Future<void> deleteListing(String listingId) async {
    if (listingId.isEmpty) return;
    await _db.collection(collectionPath).doc(listingId).delete();
  }

  Future<void> updateListingStatus(String listingId, String status) async {
    if (listingId.isEmpty) return;
    await _db.collection(collectionPath).doc(listingId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Single listing for property detail (any [status]).
  Future<DocumentSnapshot<Map<String, dynamic>>?> getListingDocument(
    String listingId,
  ) async {
    if (listingId.isEmpty) return null;
    final doc = await _db.collection(collectionPath).doc(listingId).get();
    if (!doc.exists) return null;
    if (kDebugMode) {
      developer.log(
        '[getListingDocument] fetched listing: id=${doc.id}, fields=${doc.data()?.keys.toList()}',
        name: 'firebase.listings',
      );
    }
    return doc;
  }
}
