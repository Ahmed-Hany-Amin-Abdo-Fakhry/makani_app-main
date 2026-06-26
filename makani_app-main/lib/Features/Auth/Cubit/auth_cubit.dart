import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Helper/auth_validation.dart';
import '../Models/user_profile.dart';
import '../Repositories/auth_repository.dart';
import '../Repositories/auth_repository_impl.dart';
import '../Services/firebase_auth_service.dart';
import '../Services/google_sign_in_service.dart';
import '../Services/user_profile_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({AuthRepository? authRepository})
      : _repository = authRepository ??
            AuthRepositoryImpl(
              firebaseAuthService: FirebaseAuthService(),
              googleSignInService: GoogleSignInService(),
              userProfileService: UserProfileService(),
            ),
        super(const AuthInitial()) {
    _uidSubscription = _repository.authUidChanges().listen(_onUidChanged);
  }

  final AuthRepository _repository;

  StreamSubscription<String?>? _uidSubscription;

  void _onUidChanged(String? uid) {
    if (uid == null || uid.isEmpty) {
      emit(const AuthUnauthenticated());
      return;
    }

    emit(const AuthLoading());
    // Fire-and-forget: emissions are handled inside [_loadAndEmitProfile].
    unawaited(_loadAndEmitProfile(uid));
  }

  Future<void> _loadAndEmitProfile(String uid) async {
    try {
      final profile = await _repository.getUserProfile(uid);
      emit(AuthAuthenticated(userProfile: profile));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _uidSubscription?.cancel();
    return super.close();
  }

  String _email = '';
  String _password = '';

  void setEmail(String v) => _email = v;
  void setPassword(String v) => _password = v;

  Future<void> login() async {
    final email = _email.trim();
    final password = _password.trim();
    if (email.isEmpty || password.isEmpty) {
      emit(const AuthError(message: 'Email and password are required.'));
      return;
    }
    if (!AuthValidation.isValidEmail(email)) {
      emit(const AuthError(message: 'Please enter a valid email.'));
      return;
    }
    emit(const AuthLoading());
    try {
      final profile = await _repository.login(
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(userProfile: profile));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(const AuthLoading());
      final profile = await _repository.signInWithGoogle();
      emit(AuthAuthenticated(userProfile: profile));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final nameValue = name.trim();
    final emailValue = email.trim();
    final phoneValue = phone.trim();
    final passwordValue = password.trim();

    if (nameValue.isEmpty ||
        emailValue.isEmpty ||
        phoneValue.isEmpty ||
        passwordValue.isEmpty) {
      emit(const AuthError(message: 'All fields are required.'));
      return;
    }
    if (!AuthValidation.isValidEmail(emailValue)) {
      emit(const AuthError(message: 'Please enter a valid email.'));
      return;
    }
    if (!AuthValidation.isValidPhone(phoneValue)) {
      emit(const AuthError(message: 'Please enter a valid phone number.'));
      return;
    }
    if (!AuthValidation.isStrongPassword(passwordValue)) {
      emit(
        const AuthError(message: 'Password must be at least 6 characters.'),
      );
      return;
    }

    emit(const AuthLoading());
    try {
      final profile = await _repository.register(
        name: nameValue,
        email: emailValue,
        phone: phoneValue,
        password: passwordValue,
      );
      emit(AuthAuthenticated(userProfile: profile));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthUnauthenticated());
  }

  Future<bool> uploadProfilePhoto(File file) async {
    final currentState = state;
    if (currentState is! AuthAuthenticated) {
      emit(const AuthError(message: 'Please login first.'));
      return false;
    }

    try {
      final updatedProfile = await _repository.uploadProfilePhoto(
        uid: currentState.uid,
        file: file,
      );
      emit(AuthAuthenticated(userProfile: updatedProfile));
      return true;
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(AuthAuthenticated(userProfile: currentState.userProfile));
      return false;
    }
  }

  Future<void> refreshAuthenticatedProfile() async {
    final currentState = state;
    if (currentState is! AuthAuthenticated) return;
    try {
      final fresh = await _repository.getUserProfile(currentState.uid);
      emit(AuthAuthenticated(userProfile: fresh));
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(currentState);
    }
  }

  Future<void> requestResetPassword(String email) async {
    final emailValue = email.trim();
    if (emailValue.isEmpty) {
      emit(const AuthError(message: 'Email is required.'));
      return;
    }
    if (!AuthValidation.isValidEmail(emailValue)) {
      emit(const AuthError(message: 'Please enter a valid email.'));
      return;
    }
    emit(const AuthLoading());
    try {
      await _repository.requestPasswordReset(email: emailValue);
      emit(AuthPasswordResetEmailSent(email: emailValue));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void verifyOtp(String code) {
    // OTP is not used for email-link password reset in this implementation,
    // but this method is kept so existing widgets still compile.
    emit(AuthOtpVerified());
  }

  Future<void> setNewPassword(
    String password,
    String confirmPassword, {
    required String oobCode,
  }) async {
    emit(const AuthLoading());
    await _confirmPasswordResetAsync(
      newPassword: password,
      confirmPassword: confirmPassword,
      oobCode: oobCode,
    );
  }

  Future<void> _confirmPasswordResetAsync({
    required String newPassword,
    required String confirmPassword,
    required String oobCode,
  }) async {
    final newValue = newPassword.trim();
    final confirmValue = confirmPassword.trim();

    if (newValue.isEmpty || confirmValue.isEmpty) {
      emit(const AuthError(message: 'Please enter password'));
      return;
    }

    if (!AuthValidation.isStrongPassword(newValue)) {
      emit(
        const AuthError(message: 'Password must be at least 6 characters.'),
      );
      return;
    }

    if (newValue != confirmValue) {
      emit(const AuthError(message: 'Passwords do not match'));
      return;
    }

    try {
      await _repository.confirmPasswordReset(
        oobCode: oobCode,
        newPassword: newValue,
      );
      emit(const AuthPasswordResetSuccess());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final currentValue = currentPassword.trim();
    final newValue = newPassword.trim();
    final confirmValue = confirmPassword.trim();

    if (currentValue.isEmpty || newValue.isEmpty || confirmValue.isEmpty) {
      emit(const AuthError(message: 'Please enter password'));
      return;
    }
    if (!AuthValidation.isStrongPassword(newValue)) {
      emit(
        const AuthError(message: 'Password must be at least 6 characters.'),
      );
      return;
    }
    if (newValue != confirmValue) {
      emit(const AuthError(message: 'Passwords do not match'));
      return;
    }

    emit(const AuthLoading());
    try {
      await _repository.updatePassword(
        currentPassword: currentValue,
        newPassword: newValue,
      );
      emit(const AuthPasswordUpdateSuccess());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  static AuthCubit get(BuildContext context) =>
      context.read<AuthCubit>();
}
