import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';

class PersonalInfoFieldRow extends StatelessWidget {
  const PersonalInfoFieldRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Widget label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.w,
            child: Icon(icon, size: 22.r, color: AppColors.primary700),
          ),
          SizedBox(
            width: 115.w,
            child: Align(
              alignment: Alignment.centerLeft,
              child: DefaultTextStyle.merge(child: label),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(child: value),
        ],
      ),
    );
  }
}

class PersonalInfoValueBox extends StatelessWidget {
  const PersonalInfoValueBox({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: child,
    );
  }
}

class PersonalInfoPhoneValueView extends StatelessWidget {
  const PersonalInfoPhoneValueView({
    super.key,
    required this.country,
    required this.numberMasked,
  });

  final String country;
  final String numberMasked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          country,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            numberMasked,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class PersonalInfoPasswordLabel extends StatelessWidget {
  const PersonalInfoPasswordLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
