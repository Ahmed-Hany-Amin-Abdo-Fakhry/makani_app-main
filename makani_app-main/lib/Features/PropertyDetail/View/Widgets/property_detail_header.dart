import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Core/Widgets/primary_button.dart';
import 'package:makani_app/Features/Payment/View/Screens/myfatoorah_test_payment_webview_screen.dart';

class PropertyDetailHeader extends StatelessWidget {
  const PropertyDetailHeader({
    super.key,
    required this.title,
    required this.location,
    required this.categories,
    required this.price,
    required this.bedsAvailableLabel,
    required this.baths,
    required this.sqm,
    required this.onContactOwner,
    this.isListedAsAvailable = true,
  });

  final String title;
  final String location;
  final List<String> categories;
  final String price;
  final String bedsAvailableLabel;
  final String baths;
  final String sqm;
  final VoidCallback onContactOwner;
  final bool isListedAsAvailable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 18.r, color: AppColors.textSecondary),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  location,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            children: categories
                .map(
                  (tag) => Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                          color: AppColors.divider, width: 1),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr.perMonth(price),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  isListedAsAvailable
                      ? context.tr.availableNow
                      : context.tr.unavailable,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isListedAsAvailable
                        ? AppColors.success
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 8.h,
            children: [
              _SpecItem(
                icon: Icons.bed,
                label: bedsAvailableLabel,
              ),
              _SpecItem(
                icon: Icons.bathroom_outlined,
                label: context.tr.bathsCount(baths),
              ),
              _SpecItem(
                icon: Icons.square_foot,
                label: '$sqm sqm',
              ),
            ],
          ),
          SizedBox(height: 20.h),
          PrimaryButton(
            label: context.tr.contactOwner,
            onPressed: onContactOwner,
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: OutlinedButton(
              onPressed: () async {
                final result = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => const MyFatoorahTestPaymentWebViewScreen(),
                  ),
                );
                if (!context.mounted || result == null) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      result
                          ? context.tr.addAdTestPaymentSuccess
                          : context.tr.addAdTestPaymentCancelled,
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary700,
                side: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                context.tr.reserve,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecItem extends StatelessWidget {
  const _SpecItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20.r, color: AppColors.textSecondary),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
