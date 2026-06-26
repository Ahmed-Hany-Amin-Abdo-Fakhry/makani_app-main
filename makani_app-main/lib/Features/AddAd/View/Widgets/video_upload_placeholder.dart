
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';

class VideoUploadPlaceholder extends StatelessWidget {
  const VideoUploadPlaceholder({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.hasVideo = false,
    this.onClear,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool hasVideo;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.gray200, width: 1.5),
          ),
          child: Stack(
            children: [
              if (hasVideo && onClear != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: onClear,
                    icon: const Icon(Icons.close_rounded),
                    tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                  ),
                ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
              Icon(
                hasVideo ? Icons.videocam : Icons.videocam_outlined,
                size: 40.r,
                color: hasVideo ? AppColors.primary700 : AppColors.gray500,
              ),
              SizedBox(height: 10.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
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
  }
}
