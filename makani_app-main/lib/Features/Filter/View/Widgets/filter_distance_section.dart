import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';

class FilterDistanceSection extends StatelessWidget {
  const FilterDistanceSection({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.divisions = 10,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int divisions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primary700,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                value.round().toString(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              '${value.round()} Km',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary700,
            inactiveTrackColor: AppColors.divider,
            thumbColor: Colors.white,
            overlayColor:
                AppColors.primary700.withValues(alpha: 0.2),
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 10.r,
            ),
            overlayShape:
                RoundSliderOverlayShape(overlayRadius: 22.r),
            trackHeight: 4.h,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [0, 20, 40, 60, 80, 100]
                .map(
                  (n) => Text(
                    '$n',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
