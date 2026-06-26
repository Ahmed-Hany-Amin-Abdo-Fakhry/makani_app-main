import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Core/Cubit/language_cubit.dart';
import 'package:makani_app/Features/Auth/Cubit/auth_cubit.dart';
import 'package:makani_app/Features/Auth/Services/user_profile_service.dart';
import 'package:makani_app/Features/Profile/View/Widgets/logout_button.dart';
import 'package:makani_app/Features/Profile/View/Widgets/profile_header.dart';
import 'package:makani_app/Features/Profile/View/Widgets/profile_language_row.dart';
import 'package:makani_app/Features/Profile/View/Widgets/profile_menu_card.dart';
import 'package:makani_app/Features/Profile/View/Widgets/profile_section_header.dart';
import 'package:makani_app/Features/Profile/Cubit/profile_cubit.dart';
import 'package:makani_app/Features/Profile/Cubit/profile_state.dart';
import 'package:makani_app/Routing/routes.dart';
import 'package:go_router/go_router.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: SafeArea(
              child: Center(
                child: Text(
                  'User',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
            ),
          );
        }

        return BlocProvider(
          create: (_) => ProfileCubit(
            uid: authState.uid,
            userProfileService: UserProfileService(),
          ),
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, profileState) {
              final userName = profileState is ProfileLoaded
                  ? profileState.userProfile.fullName
                  : authState.userName;
              final photoBase64 = profileState is ProfileLoaded
                  ? profileState.userProfile.photoBase64
                  : authState.userProfile.photoBase64;

              return Scaffold(
                backgroundColor: AppColors.backgroundColor,
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ProfileHeader(
                          userName: userName,
                          photoBase64: photoBase64,
                        ),
                        SizedBox(height: 24.h),
                        ProfileSectionHeader(
                            title: context.tr.accountSettings),
                        ProfileMenuCard(
                          icon: Icons.person_outline,
                          title: context.tr.personalInformation,
                          onTap: () =>
                              context.pushNamed(Routes.personalInfo.name),
                        ),
                        BlocBuilder<LanguageCubit, Locale>(
                          builder: (context, locale) {
                            final isEn = locale.languageCode == 'en';
                            return ProfileMenuCard(
                              icon: Icons.language,
                              title: context.tr.languageSettings,
                              trailing: ProfileLanguageRow(
                                currentLocaleIsEn: isEn,
                                onLocaleChanged: (toEn) {
                                  context.read<LanguageCubit>().setLocale(
                                        toEn
                                            ? const Locale('en')
                                            : const Locale('ar'),
                                      );
                                },
                              ),
                              onTap: () {},
                            );
                          },
                        ),
                        SizedBox(height: 8.h),
                        ProfileSectionHeader(
                            title: context.tr.propertyManagement),
                        ProfileMenuCard(
                          icon: Icons.description_outlined,
                          title: context.tr.myActiveAds,
                          subtitle: context.tr.propertiesCurrentlyLive('3'),
                          onTap: () => context.pushNamed(
                            Routes.home.name,
                            queryParameters: {'tab': 'myAds'},
                          ),
                        ),
                        ProfileMenuCard(
                          icon: Icons.favorite_border,
                          title: context.tr.savedProperties,
                          trailing: Container(
                            width: 24.w,
                            height: 24.h,
                            decoration: BoxDecoration(
                              color: AppColors.primary700,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '4',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onTap: () => context.pushNamed(
                            Routes.home.name,
                            queryParameters: {'tab': 'favorites'},
                          ),
                        ),
                        ProfileMenuCard(
                          icon: Icons.help_outline,
                          title: context.tr.helpSupport,
                          onTap: () {},
                        ),
                        LogoutButton(
                          label: context.tr.logout,
                          onTap: () async {
                            await context.read<AuthCubit>().logout();
                            if (context.mounted) {
                              context.goNamed(Routes.login.name);
                            }
                          },
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
