import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Features/Auth/Cubit/auth_cubit.dart';
import 'package:makani_app/Features/Favorites/Cubit/favorites_cubit.dart';
import 'package:makani_app/Features/Favorites/Cubit/favorites_state.dart';
import 'package:makani_app/Features/Home/Cubit/home_cubit.dart';
import 'package:makani_app/Features/Home/Cubit/home_state.dart';
import 'package:makani_app/Features/Home/View/Widgets/ai_recommendation_card.dart';
import 'package:makani_app/Routing/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecommendationSeeAllScreen extends StatelessWidget {
  const RecommendationSeeAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.tr;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Divider(height: 1, color: AppColors.divider),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 28.r,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          s.aiRecommendation,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HomeFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    SizedBox(height: 16.h),
                    FilledButton(
                      onPressed: () => context.read<HomeCubit>().loadListings(),
                      child: Text(s.addAdContinue),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is! HomeLoaded) {
            return const SizedBox.shrink();
          }
          final items = state.recommendations;
          if (items.isEmpty) {
            return Center(child: Text(s.searchLocationPlaceholder));
          }
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

              return ListView.separated(
                padding: EdgeInsets.all(20.w),
                itemCount: items.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final rec = items[index];
                  return AiRecommendationCard(
                    id: rec.id,
                    title: rec.title,
                    location: rec.location,
                    price: rec.price,
                    rating: rec.rating,
                    imageUrl: rec.imageUrl,
                    showFavoriteIcon: true,
                    isFavorited: favIds.contains(rec.id),
                    onFavoriteTap: () => onHeart(rec.id),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
