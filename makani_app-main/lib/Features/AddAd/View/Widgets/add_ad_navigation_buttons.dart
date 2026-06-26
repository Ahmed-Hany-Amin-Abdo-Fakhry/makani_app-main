import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';

class AddAdNavigationButtons extends StatelessWidget {
  const AddAdNavigationButtons({
    super.key,
    this.showBack = true,
    this.backLabel = 'Back',
    required this.primaryLabel,
    required this.onPrimary,
    this.onBack,
    this.primaryIcon,
    this.primaryEnabled = true,
    this.primaryLoading = false,
  });

  final bool showBack;
  final String backLabel;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback? onBack;
  final IconData? primaryIcon;
  final bool primaryEnabled;
  final bool primaryLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
      child: Row(
        children: [
          if (showBack) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary700,
                  side: const BorderSide(color: AppColors.primary700, width: 1.5),
                  minimumSize: Size(0, 52.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  backLabel,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
          ],
          Expanded(
            flex: showBack ? 1 : 1,
            child: FilledButton(
              onPressed: primaryEnabled && !primaryLoading ? onPrimary : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary700,
                foregroundColor: Colors.white,
                minimumSize: Size(0, 52.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: primaryLoading
                  ? SizedBox(
                      height: 24.h,
                      width: 24.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            primaryLabel,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          primaryIcon ?? Icons.chevron_right,
                          size: 22.r,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
