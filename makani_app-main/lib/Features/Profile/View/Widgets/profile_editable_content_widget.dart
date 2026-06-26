
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Features/Profile/View/Widgets/personal_info_field_row.dart';
import 'package:makani_app/Features/Profile/View/Widgets/personal_info_section.dart';

import '../../../../Core/Const/app_colors.dart';
import '../../../../Core/Const/localization_extension.dart';
import '../../Cubit/personal_info_cubit.dart';

class PersonalInfoEditContent extends StatefulWidget {
  const PersonalInfoEditContent({super.key, required this.state});

  final PersonalInfoState state;

  @override
  State<PersonalInfoEditContent> createState() =>
      _PersonalInfoEditContentState();
}

class _PersonalInfoEditContentState extends State<PersonalInfoEditContent> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneCountryController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.state.draftFullName);
    _emailController = TextEditingController(text: widget.state.draftEmail);
    _phoneCountryController =
        TextEditingController(text: widget.state.draftPhoneCountry);
    _phoneController = TextEditingController(text: widget.state.draftPhoneNumber);
    // In edit mode we keep the input empty, while showing existing masked password as hint.
    _passwordController = TextEditingController(text: widget.state.draftPassword);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneCountryController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PersonalInfoCubit>();

    InputDecoration inputDecoration(String? hint) => InputDecoration(
      isDense: true,
      border: InputBorder.none,
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 14.sp,
        color: AppColors.gray400,
        fontWeight: FontWeight.w500,
      ),
    );

    TextStyle inputTextStyle() => TextStyle(
      fontSize: 14.sp,
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w600,
    );

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
                child: TextFormField(
                  controller: _fullNameController,
                  onChanged: cubit.updateDraftFullName,
                  decoration: inputDecoration(null),
                  style: inputTextStyle(),
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
                child: TextFormField(
                  controller: _emailController,
                  onChanged: cubit.updateDraftEmail,
                  decoration: inputDecoration(null),
                  style: inputTextStyle(),
                  keyboardType: TextInputType.emailAddress,
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
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        onChanged: cubit.updateDraftPhoneNumber,
                        decoration: inputDecoration(null),
                        style: inputTextStyle(),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
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
                child: TextFormField(
                  controller: _passwordController,
                  onChanged: cubit.updateDraftPassword,
                  decoration: inputDecoration(widget.state.passwordMasked),
                  style: inputTextStyle(),
                  obscureText: true,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
