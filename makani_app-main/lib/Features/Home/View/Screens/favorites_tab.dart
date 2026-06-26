import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Features/Favorites/Cubit/favorites_cubit.dart';
import 'package:makani_app/Features/Favorites/Cubit/favorites_state.dart';
import 'package:makani_app/Features/Home/View/Widgets/property_card.dart';
import 'package:makani_app/Features/Listings/Model/listing_presenter.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<FavoritesCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = context.tr;
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state is FavoritesLoading || state is FavoritesInitial) {
          return CustomScrollView(
            slivers: [
              _header(context),
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }
        if (state is FavoritesFailure) {
          return CustomScrollView(
            slivers: [
              _header(context),
              SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        final loaded = state as FavoritesLoaded;
        final items = loaded.items;
        return CustomScrollView(
          slivers: [
            _header(context),
            if (items.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    s.searchLocationPlaceholder,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 36.h),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final listing = items[index];
                      final vm = listingToCardViewModel(s, listing);
                      return Dismissible(
                        key: ValueKey(vm.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: EdgeInsets.only(bottom: 16.h),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child:  Icon(
                            Icons.delete_outline_rounded,
                            size:40.sp,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) {
                          context.read<FavoritesCubit>().removeFavorite(vm.id);
                        },
                        child: PropertyCard(
                          id: vm.id,
                          title: vm.title,
                          location: vm.location,
                          price: vm.price,
                          rating: vm.rating,
                          imageUrl: vm.imageUrl,
                          gender: vm.gender,
                          showFavoriteIcon: true,
                          isFavorited: true,
                          onFavoriteTap: () => context
                              .read<FavoritesCubit>()
                              .toggleFavorite(vm.id),
                          beds: vm.beds,
                          baths: vm.baths,
                          categoryTags: vm.categoryTags,
                        ),
                      );
                    },
                    childCount: items.length,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return SliverToBoxAdapter(
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: AppColors.divider, width: 1),
            ),
          ),
          child: Text(
            context.tr.favorites,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
