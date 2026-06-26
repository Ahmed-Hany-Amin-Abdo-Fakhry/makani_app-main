import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makani_app/Features/Auth/Cubit/auth_cubit.dart';
import 'package:makani_app/Features/Auth/Services/user_profile_service.dart';
import 'package:makani_app/Features/Profile/Cubit/profile_cubit.dart';
import 'package:makani_app/Features/Profile/Cubit/profile_state.dart';
import 'package:makani_app/Features/Profile/Cubit/personal_info_cubit.dart';
import 'package:makani_app/Features/Profile/View/Widgets/personal_info_view_widget.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return const Scaffold(
            body: Center(child: Text('User')),
          );
        }

        return BlocProvider(
          create: (_) => ProfileCubit(
            uid: authState.uid,
            userProfileService: UserProfileService(),
          ),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, profileState) {
              final userProfile = profileState is ProfileLoaded
                  ? profileState.userProfile
                  : authState.userProfile;

              final phoneRaw = userProfile.phone;
              final phoneMasked = phoneRaw == null
                  ? '01*********'
                  : _maskPhone(phoneRaw);
              final phoneCountry = phoneRaw == null ? '+20' : '+';

              return BlocProvider(
                create: (_) => PersonalInfoCubit(
                  fullName: userProfile.fullName,
                  email: userProfile.email,
                  phoneCountry: phoneCountry,
                  phoneNumberMasked: phoneMasked,
                  passwordMasked: '*******',
                ),
                child: const PersonalInfoViewWidget(),
              );
            },
          ),
        );
      },
    );
  }

  String _maskPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 2) return '***';
    final keep = digits.length - 2;
    return '${digits.substring(0, keep)}••';
  }
}

