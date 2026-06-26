import '../../Auth/Models/user_profile.dart';

sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required this.userProfile});

  final UserProfile userProfile;
}

final class ProfileError extends ProfileState {
  const ProfileError({required this.message});

  final String message;
}

