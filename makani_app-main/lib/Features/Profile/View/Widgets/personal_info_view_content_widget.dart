import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Features/Profile/Cubit/personal_info_cubit.dart';
import 'package:makani_app/Features/Profile/View/Widgets/personal_info_field_row.dart';
import 'package:makani_app/Features/Profile/View/Widgets/personal_info_section.dart';

class PersonalInfoViewContentWidget extends StatelessWidget {
  const PersonalInfoViewContentWidget({
    super.key,
    required this.state,
  });

  final PersonalInfoState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PersonalInfoSection(
          title: context.tr.accountInformation,
          children: [
            PersonalInfoFieldRow(
              icon: Icons.person_outline,
              label: Text(
                context.tr.fullName,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              value: PersonalInfoValueBox(
                child: Text(
                  state.fullName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            PersonalInfoFieldRow(
              icon: Icons.email_outlined,
              label: Text(
                context.tr.emailAddress,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              value: PersonalInfoValueBox(
                child: Text(
                  state.email,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            PersonalInfoFieldRow(
              icon: Icons.phone_outlined,
              label: Text(
                context.tr.phoneNumber,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              value: PersonalInfoValueBox(
                child: PersonalInfoPhoneValueView(
                  country: state.phoneCountry,
                  numberMasked: state.phoneNumber,
                ),
              ),
            ),
          ],
        ),
        PersonalInfoSection(
          title: context.tr.security,
          children: [
            PersonalInfoFieldRow(
              icon: Icons.lock_outline,
              label: PersonalInfoPasswordLabel(label: context.tr.password),
              value: PersonalInfoValueBox(
                child: Text(
                  state.passwordMasked,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

