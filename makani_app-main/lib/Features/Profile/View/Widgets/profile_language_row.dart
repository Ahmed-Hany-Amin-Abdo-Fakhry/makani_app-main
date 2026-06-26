import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';

class ProfileLanguageRow extends StatelessWidget {
  const ProfileLanguageRow({
    super.key,
    required this.currentLocaleIsEn,
    required this.onLocaleChanged,
  });

  final bool currentLocaleIsEn;
  final ValueChanged<bool> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: This widget is used inside `ProfileMenuCard` trailing area,
    // which can be unconstrained. Using `Expanded` there can cause layout
    // assertions, so we compute a bounded width with LayoutBuilder.
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite ? constraints.maxWidth : 116.w;
        final pad = 2.w;
        final innerWidth = (width - pad * 2).clamp(0.0, double.infinity);
        final segmentWidth = innerWidth / 2;
        final height =
            constraints.maxHeight.isFinite && constraints.maxHeight > 0
                ? constraints.maxHeight
                : 38.h;

        // Keep visual order fixed (EN left, AR right) regardless of RTL,
        // and only change which segment is selected.
        final leftLabel = 'EN';
        final rightLabel = 'AR';
        final leftSelected = currentLocaleIsEn;
        final rightSelected = !currentLocaleIsEn;

        return SizedBox(
          width: width,
          height: height,
          child: Container(
            padding: EdgeInsets.all(pad),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: segmentWidth,
                    child: _LanguageSegment(
                      label: leftLabel,
                      isSelected: leftSelected,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.r),
                        bottomLeft: Radius.circular(8.r),
                      ),
                      onTap: () => onLocaleChanged(true),
                    ),
                  ),
                  SizedBox(
                    width: segmentWidth,
                    child: _LanguageSegment(
                      label: rightLabel,
                      isSelected: rightSelected,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.r),
                        bottomRight: Radius.circular(8.r),
                      ),
                      onTap: () => onLocaleChanged(false),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LanguageSegment extends StatelessWidget {
  const _LanguageSegment({
    required this.label,
    required this.isSelected,
    required this.borderRadius,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final BorderRadius borderRadius;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary700 : Colors.transparent,
            borderRadius: borderRadius,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
