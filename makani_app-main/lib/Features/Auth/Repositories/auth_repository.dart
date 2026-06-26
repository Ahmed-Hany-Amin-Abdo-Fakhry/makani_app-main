import 'dart:async';
import 'dart:io';

import '../Models/user_profile.dart';

abstract class AuthRepository {
  Stream<String?> authUidChanges();

  Future<UserProfile> getUserProfile(String uid);

  Future<UserProfile> login({
    required String email,
    required String password,
  });

  Future<UserProfile> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<UserProfile> signInWithGoogle();

  Future<UserProfile> uploadProfilePhoto({
    required String uid,
    required File file,
  });

  Future<void> logout();

  Future<void> requestPasswordReset({
    required String email,
  });

  Future<void> confirmPasswordReset({
    required String oobCode,
    required String newPassword,
  });

  /// Updates password for the currently authenticated user.
  /// Requires re-authentication with [currentPassword].
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  });
}

