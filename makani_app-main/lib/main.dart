import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:makani_app/Core/Const/bloc_observer.dart';
import 'package:makani_app/Core/Cubit/language_cubit.dart';
import 'package:makani_app/Features/AddAd/Repositories/add_property_repository.dart';
import 'package:makani_app/Features/AddAd/Repositories/add_property_repository_impl.dart';
import 'package:makani_app/Features/AddAd/Services/cloudinary_upload_service.dart';
import 'package:makani_app/Features/AddAd/Services/media_compression_service.dart';
import 'package:makani_app/Core/Services/current_location_service.dart';
import 'package:makani_app/Core/Services/reverse_geocode_service.dart';
import 'package:makani_app/Features/AddAd/Services/listing_verification_firestore_service.dart';
import 'package:makani_app/Features/AddAd/Services/property_listing_firestore_service.dart';
import 'package:makani_app/Features/Favorites/Cubit/favorites_cubit.dart';
import 'package:makani_app/Features/Favorites/Repositories/favorites_repository.dart';
import 'package:makani_app/Features/Favorites/Repositories/favorites_repository_impl.dart';
import 'package:makani_app/Features/Favorites/Services/favorites_firestore_service.dart';
import 'package:makani_app/Features/Home/Repositories/recommendation_repository.dart';
import 'package:makani_app/Features/Home/Repositories/recommendation_repository_impl.dart';
import 'package:makani_app/Features/Listings/Repositories/listings_repository.dart';
import 'package:makani_app/Features/Listings/Repositories/listings_repository_impl.dart';
import 'package:makani_app/Features/Reports/Repositories/listing_report_repository.dart';
import 'package:makani_app/Features/Reports/Repositories/listing_report_repository_impl.dart';
import 'package:makani_app/Features/Reports/Services/listing_report_firestore_service.dart';
import 'package:makani_app/Features/Ratings/Repositories/property_rating_repository.dart';
import 'package:makani_app/Features/Ratings/Repositories/property_rating_repository_impl.dart';
import 'package:makani_app/Features/Ratings/Services/property_rating_firestore_service.dart';
import 'package:makani_app/Features/Auth/Cubit/auth_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:makani_app/Routing/app_router.dart';
import 'package:makani_app/generated/l10n.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = const AppBlocObserver();
  runApp(const MakaniApp());
}

class MakaniApp extends StatelessWidget {
  const MakaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(440, 965),
      builder: (_, child) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider<CurrentLocationService>(
            create: (_) => CurrentLocationService(),
          ),
          RepositoryProvider<ReverseGeocodeService>(
            create: (_) => ReverseGeocodeService(),
          ),
          RepositoryProvider<PropertyListingFirestoreService>(
            create: (_) => PropertyListingFirestoreService(),
          ),
          RepositoryProvider<ListingVerificationStore>(
            create: (_) => ListingVerificationFirestoreService(),
          ),
          RepositoryProvider<AddPropertyRepository>(
            create: (c) => AddPropertyRepositoryImpl(
              compressionService: MediaCompressionService(),
              cloudinaryService: CloudinaryUploadService(),
              listingFirestoreService:
                  c.read<PropertyListingFirestoreService>(),
              verificationStore: c.read<ListingVerificationStore>(),
            ),
          ),
          RepositoryProvider<ListingsRepository>(
            create: (c) => ListingsRepositoryImpl(
              c.read<PropertyListingFirestoreService>(),
            ),
          ),
          RepositoryProvider<RecommendationRepository>(
            create: (_) => RecommendationRepositoryImpl(),
          ),
          RepositoryProvider<FavoritesFirestoreService>(
            create: (_) => FavoritesFirestoreService(),
          ),
          RepositoryProvider<FavoritesRepository>(
            create: (c) => FavoritesRepositoryImpl(
              c.read<FavoritesFirestoreService>(),
              c.read<ListingsRepository>(),
            ),
          ),
          RepositoryProvider<ListingReportFirestoreService>(
            create: (_) => ListingReportFirestoreService(),
          ),
          RepositoryProvider<ListingReportRepository>(
            create: (c) => ListingReportRepositoryImpl(
              c.read<ListingReportFirestoreService>(),
            ),
          ),
          RepositoryProvider<PropertyRatingFirestoreService>(
            create: (_) => PropertyRatingFirestoreService(),
          ),
          RepositoryProvider<PropertyRatingRepository>(
            create: (c) => PropertyRatingRepositoryImpl(
              c.read<PropertyRatingFirestoreService>(),
            ),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AuthCubit()),
            BlocProvider(create: (_) => LanguageCubit()),
            BlocProvider(
              create: (c) => FavoritesCubit(
                c.read<FavoritesRepository>(),
                FirebaseAuth.instance,
              ),
            ),
          ],
          child: BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  final router = CustomRouter.router;
                  final currentPath =
                      router.routerDelegate.currentConfiguration.uri.path;
                  final authOnlyPaths = <String>{
                    '/login',
                    '/signUp',
                    '/forgotPassword',
                    '/enterOtp',
                    '/newPassword',
                    '/resetSuccess',
                  };
                  final guestAllowedPaths = <String>{
                    ...authOnlyPaths,
                    '/home',
                  };

                  if (state is AuthAuthenticated &&
                      authOnlyPaths.contains(currentPath)) {
                    router.go('/home');
                  } else if (state is AuthUnauthenticated &&
                      !guestAllowedPaths.contains(currentPath)) {
                    router.go('/login');
                  }
                },
                child: MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  title: 'Makani',
                  routerConfig: CustomRouter.router,
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(
                      seedColor: const Color(0xFF5B6CF2),
                    ),
                    useMaterial3: true,
                    textTheme: GoogleFonts.cairoTextTheme(),
                    fontFamily: GoogleFonts.cairo().fontFamily,
                    appBarTheme: AppBarTheme(
                      elevation: 0,
                      scrolledUnderElevation: 0,
                      backgroundColor: const Color(0xFFFFFFFF),
                      foregroundColor: const Color(0xFF1A1A1A),
                      titleTextStyle: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  localizationsDelegates: S.localizationsDelegates,
                  supportedLocales: S.supportedLocales,
                  locale: locale,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
