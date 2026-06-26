import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/assets.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Routing/routes.dart';
import 'package:go_router/go_router.dart';

/// Horizontal card for AI Recommendation: image on the left, details on the right.
class AiRecommendationCard extends StatelessWidget {
  const AiRecommendationCard({
    super.key,
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    this.rating,
    this.imageUrl,
    this.showFavoriteIcon = true,
    this.isFavorited = false,
    this.onFavoriteTap,
    this.width,
  });

  final String id;
  final String title;
  final String location;
  final String price;
  final String? rating;
  final String? imageUrl;
  final bool showFavoriteIcon;
  final bool isFavorited;
  final VoidCallback? onFavoriteTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.gray200)),
      child: InkWell(
        onTap: () => context.push(Routes.propertyDetailPath(id)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: 100.w,
                  height: 84.h,
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(imageUrl!, fit: BoxFit.cover)
                      : Image.asset(
                          Assets.homeImage,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              size: 16.r,
                              color: AppColors.textSecondary,
                            ),
                            Expanded(
                              child: Text(
                                location,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Text(
                              context.tr.perMonth(price),
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary700,
                              ),
                            ),
                            Spacer(),
                            if (rating != null) ...[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star,
                                      size: 16.r, color: Colors.amber),
                                  SizedBox(width: 4.w),
                                  Text(
                                    rating!,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    if (showFavoriteIcon)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: onFavoriteTap,
                              customBorder: const CircleBorder(),
                              child: Padding(
                                padding: EdgeInsets.all(4.r),
                                child: Icon(
                                  isFavorited
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 22.r,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (width != null) {
      return SizedBox(width: width!, child: card);
    }
    return card;
  }
}
