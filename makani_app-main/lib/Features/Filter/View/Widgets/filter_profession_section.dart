import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';

class FilterProfessionSection extends StatelessWidget {
  const FilterProfessionSection({
    super.key,
    required this.searchController,
    required this.filteredProfessions,
    required this.selectedProfessions,
    required this.onSearchChanged,
    required this.onToggleProfession,
  });

  final TextEditingController searchController;
  final List<String> filteredProfessions;
  final Set<String> selectedProfessions;
  final VoidCallback onSearchChanged;
  final ValueChanged<String> onToggleProfession;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.gray50,
            borderRadius: BorderRadius.circular(9.r),
            border: Border.all(color: AppColors.gray200),
          ),
          child: Row(
            children: [
              Icon(Icons.search,
                  size: 20.r, color: AppColors.textSecondary),
              SizedBox(width: 10.w),
              Expanded(
                child: TextField(
                  controller: searchController,
                  onChanged: (_) => onSearchChanged(),
                  decoration: InputDecoration(
                    hintText: context.tr.searchProfession,
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        GridView.count(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 0.h,
          crossAxisSpacing: 30.w,
          childAspectRatio: 5.5,
          children: filteredProfessions.map((profession) {
            final selected = selectedProfessions.contains(profession);
            return InkWell(
              onTap: () => onToggleProfession(profession),
              child: Row(
                children: [
                  SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: Checkbox(
                      side: BorderSide(
                          width: .5, color: AppColors.gray400),
                      value: selected,
                      onChanged: (_) => onToggleProfession(profession),
                      activeColor: AppColors.primary700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      profession,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
