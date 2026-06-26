import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:io';

import '../Models/user_profile.dart';
import '../Services/firebase_auth_service.dart';
import '../Services/google_sign_in_service.dart';
import '../Services/user_profile_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required FirebaseAuthService firebaseAuthService,
    required GoogleSignInService googleSignInService,
    required UserProfileService userProfileService,
  })  : _firebaseAuthService = firebaseAuthService,
        _googleSignInService = googleSignInService,
        _userProfileService = userProfileService;

  final FirebaseAuthService _firebaseAuthService;
  final GoogleSignInService _googleSignInService;
  final UserProfileService _userProfileService;

  @override
  Stream<String?> authUidChanges() => _firebaseAuthService.authUidChanges();

  @override
  Future<UserProfile> getUserProfile(String uid) async {
    try {
      return await _userProfileService.getUserProfile(uid);
    } on StateError {
      // Can happen right after signup if profile read races first Firestore write.
      final firebaseUser = _firebaseAuthService.currentUser;
      final fallbackProfile = UserProfile(
        uid: uid,
        fullName:
            firebaseUser?.displayName ??
            firebaseUser?.email?.split('@').first ??
            'User',
        email: firebaseUser?.email ?? '',
        phone: null,
        provider:
            (firebaseUser != null &&
                firebaseUser.providerData.isNotEmpty &&
                firebaseUser.providerData.first.providerId == 'google.com')
            ? 'google'
            : 'password',
      );
      await _userProfileService.upsertUserProfile(fallbackProfile);
      return fallbackProfile;
    }
  }

  @override
  Future<UserProfile> login({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _firebaseAuthService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user == null) {
        throw StateError('Sign-in succeeded but user is null.');
      }
      final profile = UserProfile(
        uid: user.uid,
        fullName: user.displayName ?? email.split('@').first,
        email: user.email ?? email,
        phone: null,
        provider: 'password',
      );
      await _userProfileService.upsertUserProfile(profile);
      return getUserProfile(user.uid);
    } on FirebaseAuthException catch (e) {
      throw StateError(_mapFirebaseAuthMessage(e));
    }
  }

  @override
  Future<UserProfile> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final cred = await _firebaseAuthService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user == null) {
        throw StateError('Registration succeeded but user is null.');
      }

      // Store display name where possible (Firestore is still the source of truth).
      await _maybeUpdateDisplayName(name);

      final profile = UserProfile(
        uid: user.uid,
        fullName: name,
        email: user.email ?? email,
        phone: phone,
        provider: 'password',
      );
      await _userProfileService.upsertUserProfile(profile);
      return getUserProfile(user.uid);
    } on FirebaseAuthException catch (e) {
      throw StateError(_mapFirebaseAuthMessage(e));
    }
  }

  Future<void> _maybeUpdateDisplayName(String name) async {
    final user = _firebaseAuthService.currentUser;
    if (user == null) return;
    if ((user.displayName ?? '').trim().isNotEmpty) return;
    await user.updateDisplayName(name);
  }

  @override
  Future<UserProfile> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignInService.signIn();
      if (googleUser == null) {
        throw StateError('Google sign-in was cancelled.');
      }

      final googleAuth = await _googleSignInService.authentication(googleUser);

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      final userCredential =
          await _firebaseAuthService.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        throw StateError('Google sign-in succeeded but user is null.');
      }

      final profile = UserProfile(
        uid: user.uid,
        fullName: user.displayName ?? user.email?.split('@').first ?? 'User',
        email: user.email ?? '',
        phone: null,
        provider: 'google',
      );
      await _userProfileService.upsertUserProfile(profile);
      return getUserProfile(user.uid);
    } on FirebaseAuthException catch (e) {
      throw StateError(_mapFirebaseAuthMessage(e));
    }
  }

  @override
  Future<UserProfile> uploadProfilePhoto({
    required String uid,
    required File file,
  }) async {
    final bytes = await file.readAsBytes();
    final photoBase64 = base64Encode(bytes);
    final currentProfile = await getUserProfile(uid);
    final updatedProfile = currentProfile.copyWith(photoBase64: photoBase64);
    await _userProfileService.upsertUserProfile(updatedProfile);
    return updatedProfile;
  }

  @override
  Future<void> logout() async {
    await _firebaseAuthService.signOut();
    await _googleSignInService.signOut();
  }

  @override
  Future<void> requestPasswordReset({
    required String email,
  }) async {
    try {
      await _firebaseAuthService.sendPasswordResetEmail(email);
    } on FirebaseAuthException catch (e) {
      throw StateError(_mapFirebaseAuthMessage(e));
    }
  }

  @override
  Future<void> confirmPasswordReset({
    required String oobCode,
    required String newPassword,
  }) async {
    try {
      await _firebaseAuthService.confirmPasswordReset(
        oobCode: oobCode,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (e) {
      throw StateError(_mapFirebaseAuthMessage(e));
    }
  }

  @override
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _firebaseAuthService.updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (e) {
      throw StateError(_mapFirebaseAuthMessage(e));
    }
  }

  String _mapFirebaseAuthMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'This email is already in use.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'expired-action-code':
        return 'This reset link has expired.';
      case 'invalid-action-code':
        return 'This reset link is invalid.';
      case 'requires-recent-login':
        return 'Please sign in again and retry.';
      default:
        return error.message ?? 'Authentication error occurred.';
    }
  }
}

