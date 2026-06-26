import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/assets.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Core/Widgets/primary_button.dart';

class PasswordUpdatedSuccessDialog extends StatelessWidget {
  const PasswordUpdatedSuccessDialog({
    super.key,
    required this.onContinue,
  });

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            height: 65.h,
            Assets.checkMarkIcon,
          ),
          SizedBox(height: 24.h),
          Text(
            context.tr.successful,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            context.tr.passwordResetEmailSentMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: 28.h),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: context.tr.continueLabel,
              onPressed: onContinue,
            ),
          ),
        ],
      ),
    );
  }
}
