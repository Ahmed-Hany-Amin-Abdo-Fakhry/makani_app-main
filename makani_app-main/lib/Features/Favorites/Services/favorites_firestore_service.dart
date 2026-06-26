import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesFirestoreService {
  FavoritesFirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _favoritesCol(String uid) =>
      _db.collection('users').doc(uid).collection('favorites');

  Future<void> addFavorite(String uid, String listingId) async {
    if (uid.isEmpty || listingId.isEmpty) return;
    await _favoritesCol(uid).doc(listingId).set({
      'listingId': listingId,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFavorite(String uid, String listingId) async {
    if (uid.isEmpty || listingId.isEmpty) return;
    await _favoritesCol(uid).doc(listingId).delete();
  }

  Future<List<String>> favoriteListingIdsOrdered(String uid) async {
    if (uid.isEmpty) return [];
    final snap = await _favoritesCol(uid)
        .orderBy('addedAt', descending: true)
        .get();
    return snap.docs.map((d) => d.id).toList();
  }
}
