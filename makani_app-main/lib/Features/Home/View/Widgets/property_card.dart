import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/assets.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Routing/routes.dart';
import 'package:go_router/go_router.dart';

class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    this.rating,
    this.imageUrl,
    this.gender,
    this.showFavoriteIcon = false,
    this.isFavorited = false,
    this.onFavoriteTap,
    this.beds,
    this.baths,
    this.categoryTags,
    this.compactWidth,

  });

  final String id;
  final String title;
  final String location;
  final String price;
  final String? rating;
  final String? imageUrl;
  /// 'male' or 'female' to show gender pill on image
  final String? gender;
  final bool showFavoriteIcon;
  final bool isFavorited;
  final VoidCallback? onFavoriteTap;
  final String? beds;
  final String? baths;
  final List<String>? categoryTags;
  /// When set, card uses this width (e.g. for horizontal list in AI section).
  final double? compactWidth;

  @override
  Widget build(BuildContext context) {
    final imageHeight = compactWidth != null ? 120.h : 180.h;
    final content = Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 16.h),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: InkWell(
        onTap: () => context.push(Routes.propertyDetailPath(id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  height: imageHeight,
                  width: double.infinity,
                  color: AppColors.surface,
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(imageUrl!, fit: BoxFit.cover)
                      : Image.asset(
                          Assets.homeImage,
                          fit: BoxFit.cover,
                        ),
                ),
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(50),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(Assets.verificationIcon),
                          SizedBox(width: 4.w),
                          Text(
                            gender ==
                                null?"Any":gender==
                                'male'
                                ? context.tr.maleOnly
                                : context.tr.femaleOnly,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (showFavoriteIcon)
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onFavoriteTap,
                        customBorder: const CircleBorder(),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(50),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorited
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 18.r,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Spacer(),
                      if (rating != null)
                        Row(
                          children: [
                            Icon(Icons.star, size: 16.r, color: Colors.amber),
                            SizedBox(width: 4.w),
                            Text(
                              rating!,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.location_pin,
                          size: 16.r, color: AppColors.textSecondary),
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
                  if (beds != null || baths != null) ...[
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        if (beds != null) ...[
                          Icon(Icons.bed, size: 18.r, color: AppColors.textSecondary),
                          SizedBox(width: 4.w),
                          Text(
                            context.tr.bedsCount(beds!),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(width: 12.w),
                        ],
                        if (baths != null) ...[
                          Icon(Icons.bathtub,
                              size: 18.r, color: AppColors.textSecondary),
                          SizedBox(width: 4.w),
                          Text(
                            context.tr.bathsCount(baths!),
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                  if (categoryTags != null && categoryTags!.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Wrap(
                          spacing: 6.w,
                          runSpacing: 6.h,
                          children: categoryTags!
                              .map(
                                (tag) => Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                        color: AppColors.divider, width: 1),
                                  ),
                                  child: Text(
                                    tag,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        Spacer(),
                        Text(
                          context.tr.perMonth(price),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (compactWidth != null) {
      return SizedBox(width: compactWidth!, child: content);
    }
    return content;
  }
}
