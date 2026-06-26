import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';

class PersonalInfoAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PersonalInfoAppBar({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.isEditing,
    required this.isSaving,
    required this.onActionPressed,
    this.onBack,
  });

  final String title;
  final String actionLabel;
  final bool isEditing;
  final bool isSaving;
  final VoidCallback onActionPressed;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.h),
        child: Divider(height: 1, color: AppColors.divider),
      ),
      leading: IconButton(
        icon: Icon(Icons.chevron_left, size: 28.r, color: AppColors.textPrimary),
        onPressed: onBack ?? () => Navigator.of(context).pop(),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: OutlinedButton.icon(
            onPressed: isSaving ? null : onActionPressed,
            icon: Icon(
              isEditing ? Icons.check : Icons.edit,
              size: 18.r,
              color: AppColors.primary700,
            ),
            label: Text(
              actionLabel,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary700,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: AppColors.divider),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              minimumSize: Size.zero,
            ),
          ),
        ),
      ],
    );
  }
}
