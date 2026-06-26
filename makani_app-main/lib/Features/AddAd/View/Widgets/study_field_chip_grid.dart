
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';

class StudyFieldChipGrid extends StatelessWidget {
  const StudyFieldChipGrid({
    super.key,
    required this.ids,
    required this.labelFor,
    required this.selected,
    required this.onToggle,
  });

  final List<String> ids;
  final String Function(String id) labelFor;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: ids.map((id) {
        final on = selected.contains(id);
        return FilterChip(
          label: Text(
            labelFor(id),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: on ? AppColors.primary700 : AppColors.textPrimary,
            ),
          ),
          selected: on,
          onSelected: (_) => onToggle(id),
          showCheckmark: false,
          backgroundColor: Colors.white,
          selectedColor: AppColors.primary.withValues(alpha: 0.12),
          side: BorderSide(
            color: on ? AppColors.primary700 : AppColors.gray200,
            width: on ? 1.5 : 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        );
      }).toList(),
    );
  }
}
