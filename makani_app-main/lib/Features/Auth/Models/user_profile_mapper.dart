import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_profile.dart';

/// Firestore mapping helpers for [UserProfile].
class UserProfileFirestoreMapper {
  static const String collectionPath = 'users';

  static Map<String, dynamic> toUpsertData({
    required UserProfile profile,
    required bool isNewUser,
  }) {
    final data = profile.toMap();
    // Always update updatedAt.
    data['updatedAt'] = FieldValue.serverTimestamp();
    // Only set createdAt when first creating the doc.
    if (isNewUser) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }
    return data;
  }

  static UserProfile fromFirestore({
    required String uid,
    required Map<String, dynamic> map,
  }) {
    return UserProfile.fromMap(uid: uid, map: map);
  }
}

