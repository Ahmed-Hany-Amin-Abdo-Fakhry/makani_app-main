import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/assets.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Features/Home/Models/my_ad_item.dart';

Widget _listingThumb(String? url) {
  if (url != null &&
      url.isNotEmpty &&
      (url.startsWith('http://') || url.startsWith('https://'))) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        Assets.homeImage,
        fit: BoxFit.cover,
      ),
    );
  }
  return Image.asset(
    Assets.homeImage,
    fit: BoxFit.cover,
  );
}

class MyAdCard extends StatelessWidget {
  const MyAdCard({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onCardTap,
    required this.onEdit,
    required this.onDelete,
  });

  final MyAdItem item;
  final ValueChanged<bool> onToggle;
  final Function() onCardTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: SizedBox(
                  width: 100.w,
                  height: 80.h,
                  child: _listingThumb(item.imageUrl),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14.r,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            item.location,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      context.tr.perMonth(item.price),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: item.isShared
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  item.isShared ? context.tr.shared : context.tr.private,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: item.isShared
                        ? AppColors.primary700
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Switch(
                  value: item.isAvailable,
                  onChanged: (v) => onToggle(v),
                  activeTrackColor: AppColors.primary700,
                  activeThumbColor: Colors.white,
                ),
                SizedBox(width: 4.w),
                Text(
                  item.isAvailable
                      ? context.tr.available
                      : context.tr.unavailable,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: onEdit,
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      size: 18.r,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      size: 18.r,
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
