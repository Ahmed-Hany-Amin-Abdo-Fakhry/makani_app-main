import 'package:cloud_firestore/cloud_firestore.dart';

import '../Models/user_profile.dart';
import '../Models/user_profile_mapper.dart';

/// Handles reading/writing the user's profile document in Firestore.
class UserProfileService {
  UserProfileService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore
          .collection(UserProfileFirestoreMapper.collectionPath)
          .withConverter<Map<String, dynamic>>(
            fromFirestore: (snap, _) => snap.data() ?? <String, dynamic>{},
            toFirestore: (data, _) => data,
          );

  Stream<UserProfile> watchUserProfile(String uid) {
    return _firestore
        .collection(UserProfileFirestoreMapper.collectionPath)
        .doc(uid)
        .snapshots()
        .map((snapshot) {
          final data = snapshot.data();
          if (data == null) {
            // Inconsistent doc state; still emit a minimal profile.
            return UserProfile(
              uid: uid,
              fullName: '',
              email: '',
              provider: 'unknown',
            );
          }
          return UserProfileFirestoreMapper.fromFirestore(
            uid: uid,
            map: data,
          );
        });
  }

  /// Returns [UserProfile.phone] when the document exists; otherwise null.
  Future<String?> getPhoneByUid(String uid) async {
    if (uid.isEmpty) return null;
    final snapshot = await _firestore
        .collection(UserProfileFirestoreMapper.collectionPath)
        .doc(uid)
        .get();
    final map = snapshot.data();
    if (map == null) return null;
    final profile = UserProfileFirestoreMapper.fromFirestore(
      uid: uid,
      map: map,
    );
    final p = profile.phone?.trim();
    if (p == null || p.isEmpty) return null;
    return p;
  }

  Future<UserProfile> getUserProfile(String uid) async {
    final snapshot = await _firestore
        .collection(UserProfileFirestoreMapper.collectionPath)
        .doc(uid)
        .get();

    final map = snapshot.data();
    if (map == null) {
      throw StateError('User profile not found for uid=$uid');
    }
    return UserProfileFirestoreMapper.fromFirestore(
      uid: uid,
      map: map,
    );
  }

  Future<void> upsertUserProfile(UserProfile profile) async {
    final docRef = _firestore
        .collection(UserProfileFirestoreMapper.collectionPath)
        .doc(profile.uid);

    final snapshot = await docRef.get();
    final isNewUser = !snapshot.exists;

    final data = UserProfileFirestoreMapper.toUpsertData(
      profile: profile,
      isNewUser: isNewUser,
    );

    await docRef.set(data, SetOptions(merge: true));
  }
}

