import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Core/Widgets/primary_button.dart';

/// Reason options for reporting a listing. Value matches l10n key suffix.
enum ReportReason {
  incorrectPrice,
  alreadyRented,
  fakeListing,
  inappropriateContent,
  other,
}

class ReportListingSheet extends StatefulWidget {
  const ReportListingSheet({super.key});

  @override
  State<ReportListingSheet> createState() => _ReportListingSheetState();
}

class _ReportListingSheetState extends State<ReportListingSheet> {
  ReportReason _selected = ReportReason.incorrectPrice;

  String _reasonLabel(BuildContext context, ReportReason r) {
    switch (r) {
      case ReportReason.incorrectPrice:
        return context.tr.incorrectPrice;
      case ReportReason.alreadyRented:
        return context.tr.alreadyRented;
      case ReportReason.fakeListing:
        return context.tr.fakeListing;
      case ReportReason.inappropriateContent:
        return context.tr.inappropriateContent;
      case ReportReason.other:
        return context.tr.other;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.tr.whyReportingListing,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 20.h),
          ...ReportReason.values.map((reason) {
            final isSelected = _selected == reason;
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: InkWell(
                onTap: () => setState(() => _selected = reason),
                borderRadius: BorderRadius.circular(8.r),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: Radio<ReportReason>(
                        value: reason,
                        groupValue: _selected,
                        onChanged: (v) => setState(() => _selected = v!),
                        activeColor: AppColors.primary700,
                        fillColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.primary700;
                          }
                          return AppColors.textSecondary;
                        }),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        _reasonLabel(context, reason),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 24.h),
          PrimaryButton(
            label: context.tr.send,
            onPressed: () => Navigator.of(context).pop(_selected),
          ),
        ],
      ),
    );
  }
}
