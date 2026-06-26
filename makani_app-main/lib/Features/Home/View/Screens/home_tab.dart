import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Features/Auth/Cubit/auth_cubit.dart';
import 'package:makani_app/Features/Favorites/Cubit/favorites_cubit.dart';
import 'package:makani_app/Features/Favorites/Cubit/favorites_state.dart';
import 'package:makani_app/Features/Home/Cubit/home_cubit.dart';
import 'package:makani_app/Features/Home/Cubit/home_state.dart';
import 'package:makani_app/Features/Filter/View/Screens/filter_screen.dart';
import 'package:makani_app/Features/Listings/Model/listing_query.dart';
import 'package:makani_app/Features/Home/View/Widgets/ai_recommendation_card.dart';
import 'package:makani_app/Features/Home/View/Widgets/home_header.dart';
import 'package:makani_app/Features/Home/View/Widgets/home_search_bar.dart';
import 'package:makani_app/Features/Home/View/Widgets/property_card.dart';
import 'package:makani_app/Features/Listings/Model/listing_presenter.dart';
import 'package:makani_app/Features/Location/Cubit/user_location_cubit.dart';
import 'package:makani_app/Features/Location/Cubit/user_location_state.dart';
import 'package:makani_app/Routing/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    await Future.wait<void>([
      context.read<HomeCubit>().loadListings(),
      context.read<UserLocationCubit>().refresh(),
      context.read<AuthCubit>().refreshAuthenticatedProfile(),
    ]);
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    final s = context.tr;
    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              final userName =
                  authState is AuthAuthenticated ? authState.userName : 'User';
              final photoBase64 = authState is AuthAuthenticated
                  ? authState.userProfile.photoBase64
                  : null;
              return SliverToBoxAdapter(
                child: BlocBuilder<UserLocationCubit, UserLocationState>(
                  builder: (context, locState) {
                    final locationText = switch (locState) {
                      UserLocationReady(:final displayLine) => displayLine,
                      UserLocationLoading() => s.searchLocationPlaceholder,
                      UserLocationError() => s.searchLocationPlaceholder,
                      _ => s.searchLocationPlaceholder,
                    };
                    return HomeHeader(
                      userName: userName,
                      photoBase64: photoBase64,
                      locationText: locationText,
                    );
                  },
                ),
              );
            },
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<HomeCubit, HomeState>(
              buildWhen: (a, b) =>
                  a is HomeLoaded != b is HomeLoaded ||
                  (a is HomeLoaded &&
                      b is HomeLoaded &&
                      a.hasActiveFilters != b.hasActiveFilters),
              builder: (context, homeState) {
                final badge =
                    homeState is HomeLoaded && homeState.hasActiveFilters;
                return HomeSearchBar(
                  showFilterBadge: badge,
                  onFilterTap: () async {
                    final q = await showModalBottomSheet<ListingQuery?>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (ctx) => const FilterScreen(),
                    );
                    if (!context.mounted || q == null) return;
                    context.read<HomeCubit>().setListingQuery(q);
                  },
                );
              },
            ),
          ),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (state is HomeFailure) {
                return SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          FilledButton(
                            onPressed: () =>
                                context.read<HomeCubit>().loadListings(),
                            child: Text(s.addAdContinue),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (state is HomeLoaded) {
                final items = state.items;
                final aiSlice = state.recommendations.take(2).toList();
                return BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, favState) {
                    final favIds = favState is FavoritesLoaded
                        ? favState.favoriteIds
                        : <String>{};
                    void onHeart(String id) async {
                      final authed =
                          context.read<AuthCubit>().state is AuthAuthenticated;
                      if (!authed) {
                        context.pushNamed(Routes.login.name);
                        return;
                      }
                      await context.read<FavoritesCubit>().toggleFavorite(id);
                    }

                    return SliverList(
                      delegate: SliverChildListDelegate([
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                s.aiRecommendation,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              TextButton(
                                onPressed: () => context.pushNamed(
                                  Routes.recommendationSeeAll.name,
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  s.seeAll,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        if (aiSlice.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                              s.searchLocationPlaceholder,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 123.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              itemCount: aiSlice.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(width: 12.w),
                              itemBuilder: (context, i) {
                                final rec = aiSlice[i];
                                return AiRecommendationCard(
                                  id: rec.id,
                                  title: rec.title,
                                  location: rec.location,
                                  price: rec.price,
                                  rating: rec.rating,
                                  imageUrl: rec.imageUrl,
                                  width: 320.w,
                                  showFavoriteIcon: true,
                                  isFavorited: favIds.contains(rec.id),
                                  onFavoriteTap: () => onHeart(rec.id),
                                );
                              },
                            ),
                          ),
                        SizedBox(height: 24.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            s.popularListing,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        if (items.isEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                              s.searchLocationPlaceholder,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ...items.map((listing) {
                          final vm = listingToCardViewModel(s, listing);
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: PropertyCard(
                              id: vm.id,
                              title: vm.title,
                              location: vm.location,
                              price: vm.price,
                              rating: vm.rating,
                              imageUrl: vm.imageUrl,
                              gender: vm.gender,
                              showFavoriteIcon: true,
                              isFavorited: favIds.contains(vm.id),
                              onFavoriteTap: () => onHeart(vm.id),
                              beds: vm.beds,
                              baths: vm.baths,
                              categoryTags: vm.categoryTags,
                            ),
                          );
                        }),
                        SizedBox(height: 24.h),
                      ]),
                    );
                  },
                );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }
}
