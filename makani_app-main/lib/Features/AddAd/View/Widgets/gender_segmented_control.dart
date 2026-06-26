
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_enums.dart';

class GenderSegmentedControl extends StatelessWidget {
  const GenderSegmentedControl({
    super.key,
    required this.value,
    required this.onChanged,
    required this.labelMale,
    required this.labelFemale,
    required this.labelAny,
  });

  final AddAdGenderPreference value;
  final ValueChanged<AddAdGenderPreference> onChanged;
  final String labelMale;
  final String labelFemale;
  final String labelAny;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.gray200),
      ),
      child: Row(
        children: [
          _seg(labelMale, AddAdGenderPreference.male),
          _seg(labelFemale, AddAdGenderPreference.female),
          _seg(labelAny, AddAdGenderPreference.any),
        ],
      ),
    );
  }

  Widget _seg(String text, AddAdGenderPreference v) {
    final sel = value == v;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(v),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: sel ? AppColors.gray50 : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
              color: sel ? AppColors.primary700 : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
