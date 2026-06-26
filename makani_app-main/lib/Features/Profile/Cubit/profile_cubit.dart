import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makani_app/Features/Auth/Services/user_profile_service.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required String uid,
    required UserProfileService userProfileService,
  })  : _uid = uid,
        _userProfileService = userProfileService,
        super(const ProfileInitial()) {
    _subscription = _userProfileService.watchUserProfile(_uid).listen(
      (profile) {
        emit(ProfileLoaded(userProfile: profile));
      },
      onError: (Object error) {
        emit(ProfileError(message: error.toString()));
      },
    );
  }

  final String _uid;
  final UserProfileService _userProfileService;
  StreamSubscription? _subscription;

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}

