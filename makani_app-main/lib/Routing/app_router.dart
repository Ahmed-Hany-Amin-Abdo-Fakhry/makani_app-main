import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makani_app/Features/Auth/Cubit/auth_cubit.dart';
import 'package:makani_app/Features/Auth/Services/user_profile_service.dart';
import 'package:makani_app/Features/Auth/View/Screens/forgot_password_screen.dart';
import 'package:makani_app/Features/Auth/View/Screens/login_screen.dart';
import 'package:makani_app/Features/Auth/View/Screens/sign_up_screen.dart';
import 'package:makani_app/Core/Services/current_location_service.dart';
import 'package:makani_app/Core/Services/reverse_geocode_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makani_app/Features/Home/Cubit/home_cubit.dart';
import 'package:makani_app/Features/Home/Repositories/recommendation_repository.dart';
import 'package:makani_app/Features/Location/Cubit/user_location_cubit.dart';
import 'package:makani_app/Features/Listings/Repositories/listings_repository.dart';
import 'package:makani_app/Features/MyAds/Cubit/my_ads_cubit.dart';
import 'package:makani_app/Features/Ratings/Repositories/property_rating_repository.dart';
import 'package:makani_app/Features/Reports/Cubit/listing_report_cubit.dart';
import 'package:makani_app/Features/Reports/Repositories/listing_report_repository.dart';
import 'package:makani_app/Features/Home/View/Screens/main_shell.dart';
import 'package:makani_app/Features/Home/View/Screens/sell_tab.dart';
import 'package:makani_app/Features/Home/View/Screens/recommendation_see_all_screen.dart';
import 'package:makani_app/Features/Filter/View/Screens/filter_screen.dart';
import 'package:makani_app/Features/Booking/View/Screens/booking_screen.dart';
import 'package:makani_app/Features/Profile/View/Screens/personal_info_screen.dart';
import 'package:makani_app/Routing/routes.dart';
import 'package:makani_app/Routing/router_transitions.dart';
import 'package:makani_app/Features/PropertyDetail/Cubit/property_detail_cubit.dart';
import '../Features/PropertyDetail/View/Screens/property_detail_screen.dart';

class CustomRouter {
  CustomRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;
  static final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.home.path,
    redirect: (context, state) {
      return resolveAuthRedirect(
        authState: context.read<AuthCubit>().state,
        path: state.uri.path,
      );
    },
    routes: [
      GoRoute(
        path: Routes.login.path,
        name: Routes.login.name,
        pageBuilder: (context, state) =>
            RouterTransitions.getFadeTransitionPage(
          context,
          state,
          const LoginScreen(),
        ),
      ),
      GoRoute(
        path: Routes.signUp.path,
        name: Routes.signUp.name,
        pageBuilder: (context, state) =>
            RouterTransitions.getFadeTransitionPage(
          context,
          state,
          const SignUpScreen(),
        ),
      ),
      GoRoute(
        path: Routes.forgotPassword.path,
        name: Routes.forgotPassword.name,
        pageBuilder: (context, state) =>
            RouterTransitions.getFadeTransitionPage(
          context,
          state,
          const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: Routes.home.path,
        name: Routes.home.name,
        pageBuilder: (context, state) {
          final initialIndex = initialHomeTabIndex(
            state.uri.queryParameters['tab'],
          );
          final sellFlowArgs =
              state.extra is SellFlowArgs ? state.extra as SellFlowArgs : null;
          return RouterTransitions.getFadeTransitionPage(
            context,
            state,
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (c) => HomeCubit(
                    c.read<ListingsRepository>(),
                    c.read<RecommendationRepository>(),
                  ),
                ),
                BlocProvider(
                  create: (c) => UserLocationCubit(
                    locationService: c.read<CurrentLocationService>(),
                    reverseGeocode: c.read<ReverseGeocodeService>(),
                  ),
                ),
                BlocProvider(
                  create: (c) => MyAdsCubit(
                    c.read<ListingsRepository>(),
                    FirebaseAuth.instance,
                  ),
                ),
              ],
              child: MainShell(
                initialIndex: initialIndex,
                sellFlowArgs: sellFlowArgs,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.recommendationSeeAll.path,
        name: Routes.recommendationSeeAll.name,
        pageBuilder: (context, state) =>
            RouterTransitions.getFadeTransitionPage(
          context,
          state,
          BlocProvider(
            create: (c) => HomeCubit(
              c.read<ListingsRepository>(),
              c.read<RecommendationRepository>(),
            ),
            child: const RecommendationSeeAllScreen(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.filter.path,
        name: Routes.filter.name,
        pageBuilder: (context, state) =>
            RouterTransitions.getFadeTransitionPage(
          context,
          state,
          BlocProvider(
            create: (c) => UserLocationCubit(
              locationService: c.read<CurrentLocationService>(),
              reverseGeocode: c.read<ReverseGeocodeService>(),
            ),
            child: const FilterScreen(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.propertyDetail.path,
        name: Routes.propertyDetail.name,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '0';
          return RouterTransitions.getFadeTransitionPage(
            context,
            state,
            MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (c) => PropertyDetailCubit(
                    c.read<ListingsRepository>(),
                    UserProfileService(),
                    c.read<PropertyRatingRepository>(),
                    id,
                  )..load(),
                ),
                BlocProvider(
                  create: (c) =>
                      ListingReportCubit(c.read<ListingReportRepository>()),
                ),
              ],
              child: PropertyDetailScreen(propertyId: id),
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.booking.path,
        name: Routes.booking.name,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return RouterTransitions.getFadeTransitionPage(
            context,
            state,
            BookingScreen(extra: extra),
          );
        },
      ),
      GoRoute(
        path: Routes.editAd.path,
        name: Routes.editAd.name,
        pageBuilder: (context, state) {
          final args = state.extra as SellFlowArgs?;
          if (args == null) {
            return RouterTransitions.getFadeTransitionPage(
              context,
              state,
              const Scaffold(
                body: Center(child: Text('Missing listing for edit flow')),
              ),
            );
          }
          return RouterTransitions.getFadeTransitionPage(
            context,
            state,
            SellTab(initialArgs: args),
          );
        },
      ),
      GoRoute(
        path: Routes.personalInfo.path,
        name: Routes.personalInfo.name,
        pageBuilder: (context, state) =>
            RouterTransitions.getFadeTransitionPage(
          context,
          state,
          const PersonalInfoScreen(),
        ),
      ),
    ],
  );
}

String? resolveAuthRedirect({
  required AuthState authState,
  required String path,
}) {
  final isAuthed = authState is AuthAuthenticated;
  final authOnlyRoutes = {
    Routes.login.path,
    Routes.signUp.path,
    Routes.forgotPassword.path,
    Routes.resetSuccess.path,
  };
  final guestAllowedRoutes = {
    ...authOnlyRoutes,
    Routes.home.path,
  };

  if (isAuthed) {
    // Keep `/home?tab=...` and other in-app routes reachable.
    if (authOnlyRoutes.contains(path)) return Routes.home.path;
    return null;
  }

  if (guestAllowedRoutes.contains(path)) return null;
  return Routes.login.path;
}

int? initialHomeTabIndex(String? tab) {
  if (tab == 'myAds') return 3;
  if (tab == 'favorites') return 1;
  if (tab == 'sell') return 2;
  return null;
}
