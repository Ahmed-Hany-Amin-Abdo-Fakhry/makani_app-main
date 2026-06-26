part of 'auth_cubit.dart';

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthError extends AuthState {
  const AuthError({required this.message});
  final String message;
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.userProfile});

  final UserProfile userProfile;

  String get userName => userProfile.fullName;

  String get uid => userProfile.uid;
}

final class AuthOtpSent extends AuthState {
  const AuthOtpSent({required this.email});
  final String email;
}

final class AuthOtpVerified extends AuthState {
  const AuthOtpVerified();
}

final class AuthPasswordResetEmailSent extends AuthState {
  const AuthPasswordResetEmailSent({required this.email});
  final String email;
}

final class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess();
}

final class AuthPasswordUpdateSuccess extends AuthState {
  const AuthPasswordUpdateSuccess();
}
