
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_constants.dart';

class AmenityToggleGrid extends StatelessWidget {
  const AmenityToggleGrid({
    super.key,
    required this.selected,
    required this.labelFor,
    required this.onToggle,
  });

  final Set<String> selected;
  final String Function(String id) labelFor;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final ids = AddAdConstants.amenityIdsOrdered;
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.4,
      children: ids.map((id) {
        final on = selected.contains(id);
        final icon = AddAdConstants.amenityIcons[id] ?? Icons.check_circle_outline;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onToggle(id),
            borderRadius: BorderRadius.circular(12.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: on ? AppColors.primary700 : AppColors.gray200,
                  width: on ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 22.r,
                    color: on ? AppColors.primary700 : AppColors.textPrimary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      labelFor(id),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: on ? AppColors.primary700 : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
