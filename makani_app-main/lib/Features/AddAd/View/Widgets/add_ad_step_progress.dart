import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/generated/l10n.dart';

class AddAdStepProgress extends StatelessWidget {
  const AddAdStepProgress({
    super.key,
    required this.activeIndex,
    required this.labels,
  });

  final int activeIndex;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              left: 28.w,
              right: 28.w,
              top: 13.h,
              child: Row(
                children: List.generate(labels.length - 1, (i) {
                  final segmentDone = i < activeIndex;
                  return Expanded(
                    child: Container(
                      height: 3.h,
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        color: segmentDone
                            ? AppColors.primary
                            : AppColors.gray200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(labels.length, (i) {
                final done = i < activeIndex;
                final active = i == activeIndex;
                return Expanded(
                  child: Column(
                    children: [
                      _StepDot(done: done, active: active, index: i + 1),
                      SizedBox(height: 8.h),
                      Text(
                        labels[i],
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight:
                              active ? FontWeight.w700 : FontWeight.w500,
                          color: active || done
                              ? AppColors.primary700
                              : AppColors.textSecondary,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({
    required this.done,
    required this.active,
    required this.index,
  });

  final bool done;
  final bool active;
  final int index;

  @override
  Widget build(BuildContext context) {
    if (done) {
      return Container(
        width: 28.r,
        height: 28.r,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check, color: Colors.white, size: 16.r),
      );
    }
    if (active) {
      return Container(
        width: 28.r,
        height: 28.r,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary700, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            '$index',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary700,
            ),
          ),
        ),
      );
    }
    return Container(
      width: 28.r,
      height: 28.r,
      decoration: const BoxDecoration(
        color: AppColors.gray200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$index',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.gray500,
          ),
        ),
      ),
    );
  }
}

List<String> addAdStepLabels(S s) => [
      s.addAdStepPropertyType,
      s.addAdStepLocation,
      s.addAdStepDetails,
      s.addAdStepMedia,
      s.addAdStepReview,
    ];
