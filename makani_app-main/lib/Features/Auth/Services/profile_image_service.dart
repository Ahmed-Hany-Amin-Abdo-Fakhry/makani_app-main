import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ProfileImageService {
  ProfileImageService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  final FirebaseStorage _storage;

  Future<String> uploadProfilePhoto({
    required String uid,
    required File file,
  }) async {
    final ref = _storage.ref().child('users/$uid/avatar.jpg');
    await ref.putFile(file);
    return ref.getDownloadURL();
  }
}

