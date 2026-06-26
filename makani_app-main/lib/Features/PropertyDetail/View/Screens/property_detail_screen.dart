import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Core/Widgets/report_listing_sheet.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_l10n_helpers.dart';
import 'package:makani_app/Features/Auth/Cubit/auth_cubit.dart';
import 'package:makani_app/Features/Favorites/Cubit/favorites_cubit.dart';
import 'package:makani_app/Features/Favorites/Cubit/favorites_state.dart';
import 'package:makani_app/Features/Listings/Model/listing_presenter.dart';
import 'package:makani_app/Features/PropertyDetail/Cubit/property_detail_cubit.dart';
import 'package:makani_app/Features/PropertyDetail/Cubit/property_detail_state.dart';
import 'package:makani_app/Features/Ratings/Model/rating_review.dart';
import 'package:makani_app/Features/Reports/Cubit/listing_report_cubit.dart';
import 'package:makani_app/Features/Reports/Services/listing_report_firestore_service.dart';
import 'package:makani_app/Features/PropertyDetail/View/property_detail_actions.dart';
import 'package:makani_app/Features/PropertyDetail/View/property_detail_listing_ui.dart';
import 'package:makani_app/Features/PropertyDetail/View/Widgets/property_detail_header.dart';
import 'package:makani_app/Features/PropertyDetail/View/Widgets/property_detail_hero.dart';
import 'package:makani_app/Features/PropertyDetail/View/Widgets/property_detail_video_tab.dart';
import 'package:makani_app/Features/PropertyDetail/View/Widgets/property_overview_tab.dart';
import 'package:makani_app/Features/PropertyDetail/View/Widgets/property_ratings_tab.dart';
import 'package:makani_app/Features/Listings/Model/property_listing.dart';
import 'package:makani_app/Routing/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class PropertyDetailScreen extends StatefulWidget {
  const PropertyDetailScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  int _selectedTabIndex = 0;

  Future<void> _openDirections(PropertyListing listing) async {
    final lat = listing.latitude;
    final lng = listing.longitude;
    if (lat != null && lng != null) {
      await launchGoogleMapsDirections(latitude: lat, longitude: lng);
      return;
    }
    final parts = [
      listing.addressLine,
      listing.district,
      listing.governorate,
    ]
        .whereType<String>()
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .join(', ');
    if (parts.isNotEmpty) {
      await launchGoogleMapsQuery(parts);
    }
  }

  RatingReview? _findUserReview(List<RatingReview> reviews, String reviewerUid) {
    for (final review in reviews) {
      if (review.reviewerUid == reviewerUid) return review;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final s = context.tr;
    return BlocBuilder<PropertyDetailCubit, PropertyDetailState>(
      builder: (context, state) {
        if (state is PropertyDetailLoading || state is PropertyDetailInitial) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              leading: IconButton(
                icon: const BackButtonIcon(),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (state is PropertyDetailNotFound) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              leading: IconButton(
                icon: const BackButtonIcon(),
                onPressed: () => context.pop(),
              ),
              title: Text(s.addNewAd),
            ),
            body: Center(child: Text(s.searchLocationPlaceholder)),
          );
        }
        if (state is PropertyDetailFailure) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              leading: IconButton(
                icon: const BackButtonIcon(),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    SizedBox(height: 16.h),
                    FilledButton(
                      onPressed: () =>
                          context.read<PropertyDetailCubit>().load(),
                      child: Text(s.addAdContinue),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state is! PropertyDetailLoaded) {
          return const SizedBox.shrink();
        }

        final listing = state.listing;
        final authState = context.read<AuthCubit>().state;
        final currentUid = authState is AuthAuthenticated ? authState.uid : null;
        final myReview =
            currentUid == null ? null : _findUserReview(state.reviews, currentUid);
        final vm = listingToCardViewModel(s, listing);
        final categories =
            listing.studyFieldIds.map((id) => addAdStudyLabel(s, id)).toList();
        final description = listingOverviewDescription(s, listing);
        final amenityItems = listingAmenityItems(s, listing);
        final imageUrls = listing.imageUrls.isEmpty ? null : listing.imageUrls;

        return BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, favState) {
            final favIds =
                favState is FavoritesLoaded ? favState.favoriteIds : <String>{};
            final isFav = favIds.contains(widget.propertyId);

            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    PropertyDetailHero(
                      imageUrls: imageUrls,
                      onBack: () => context.pop(),
                      isFavorited: isFav,
                      onShare: () async {
                        final text = StringBuffer()
                          ..writeln(
                              'Check out this property I found on Makani.')
                          ..writeln()
                          ..writeln('Title: ${vm.title}')
                          ..writeln('Location: ${vm.location}')
                          ..writeln('Price: ${s.perMonth(vm.price)}')
                          ..writeln(
                              'Property: ${Routes.propertyDetailPath(widget.propertyId)}');
                        await Share.share(
                          text.toString(),
                          subject: vm.title,
                        );
                      },
                      onFavorite: () async {
                        final authed = context.read<AuthCubit>().state
                            is AuthAuthenticated;
                        if (!authed) {
                          context.pushNamed(Routes.login.name);
                          return;
                        }
                        await context
                            .read<FavoritesCubit>()
                            .toggleFavorite(widget.propertyId);
                      },
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.r),
                          topRight: Radius.circular(24.r),
                        ),
                      ),
                      child: DefaultTabController(
                        length: 3,
                        initialIndex: _selectedTabIndex,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            PropertyDetailHeader(
                              title: vm.title,
                              location: vm.location,
                              categories: categories,
                              price: vm.price,
                              bedsAvailableLabel: context.tr.bedsAvailable(
                                '${listing.bedsAvailable ?? listing.totalBeds ?? '—'}',
                              ),
                              baths: listing.bathrooms?.toString() ?? '—',
                              sqm: listing.roomSizeSqm != null
                                  ? listing.roomSizeSqm!.toStringAsFixed(0)
                                  : '—',
                              isListedAsAvailable: listing.status == 'active' ||
                                  listing.status == null,
                              onContactOwner: () async {
                                final ownerPhone = await context
                                    .read<PropertyDetailCubit>()
                                    .ensureOwnerPhoneAvailable();
                                final ok =
                                    await launchPropertyPhoneCall(ownerPhone);
                                if (!context.mounted) return;
                                if (!ok) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        ownerPhone == null ||
                                                ownerPhone.trim().isEmpty
                                            ? 'Phone number not available for this owner.'
                                            : 'Could not start a phone call.',
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 8.h),
                            TabBar(
                              onTap: (index) {
                                setState(() => _selectedTabIndex = index);
                              },
                              labelColor: AppColors.primary700,
                              unselectedLabelColor: AppColors.textSecondary,
                              indicatorColor: AppColors.primary700,
                              labelStyle: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              tabs: [
                                Tab(text: s.overview),
                                Tab(text: s.video),
                                Tab(text: s.ratings),
                              ],
                            ),
                            if (_selectedTabIndex == 0)
                              PropertyOverviewTab(
                                description: description,
                                amenityItems: amenityItems,
                                onGetDirections: () {
                                  _openDirections(listing);
                                },
                                onMapTap: () {
                                  _openDirections(listing);
                                },
                              )
                            else if (_selectedTabIndex == 1)
                              Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: PropertyDetailVideoTab(
                                  videoUrl: listing.videoUrl,
                                ),
                              )
                            else
                              PropertyRatingsTab(
                                listing: listing,
                                reviews: state.reviews,
                                currentUid: currentUid,
                                myReview: myReview,
                                onSubmitReview: ({
                                  required int rating,
                                  required String reviewText,
                                }) async {
                                  final reviewerUid = currentUid;
                                  if (reviewerUid == null) {
                                    return PropertyReviewSubmitStatus.invalidInput;
                                  }
                                  return context
                                      .read<PropertyDetailCubit>()
                                      .submitReview(
                                        reviewerUid: reviewerUid,
                                        rating: rating,
                                        reviewText: reviewText,
                                      );
                                },
                              ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                              child: SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    final selectedReason =
                                        await showModalBottomSheet<
                                            ReportReason>(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (ctx) =>
                                          const ReportListingSheet(),
                                    );
                                    if (!context.mounted ||
                                        selectedReason == null) {
                                      return;
                                    }

                                    final authState =
                                        context.read<AuthCubit>().state;
                                    if (authState is! AuthAuthenticated) {
                                      context.pushNamed(Routes.login.name);
                                      return;
                                    }

                                    final scaffoldMessenger =
                                        ScaffoldMessenger.of(context);
                                    try {
                                      final status = await context
                                          .read<ListingReportCubit>()
                                          .submitListingReport(
                                            listingId: listing.id,
                                            reporterUid: authState.uid,
                                            ownerId: listing.ownerId,
                                            reason: selectedReason.name,
                                          );
                                      if (!context.mounted) return;
                                      if (status ==
                                          ListingReportSubmitStatus.submitted) {
                                        scaffoldMessenger.showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Report sent successfully.',
                                            ),
                                          ),
                                        );
                                      } else if (status ==
                                          ListingReportSubmitStatus
                                              .alreadyReported) {
                                        scaffoldMessenger.showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'You have already reported this listing.',
                                            ),
                                          ),
                                        );
                                      } else {
                                        scaffoldMessenger.showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Could not send report. Please try again.',
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (_) {
                                      if (!context.mounted) return;
                                      scaffoldMessenger.showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Failed to send report. Please try again.',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.textSecondary,
                                    side: BorderSide(color: AppColors.divider),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: Text(
                                    s.reportListing,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
