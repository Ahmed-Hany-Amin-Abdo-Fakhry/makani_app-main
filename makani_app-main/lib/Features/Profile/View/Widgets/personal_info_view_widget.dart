import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Features/Profile/Cubit/personal_info_cubit.dart';
import 'package:makani_app/Features/Profile/View/Widgets/personal_info_app_bar.dart';
import 'package:makani_app/Features/Profile/View/Widgets/personal_info_edit_content_widget.dart';
import 'package:makani_app/Features/Profile/View/Widgets/personal_info_view_content_widget.dart';

class PersonalInfoViewWidget extends StatelessWidget {
  const PersonalInfoViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PersonalInfoCubit, PersonalInfoState>(
      listenWhen: (previous, current) =>
          previous.saveStatus != current.saveStatus &&
          current.saveStatus != PersonalInfoSaveStatus.initial,
      listener: (context, state) {
        if (state.saveStatus == PersonalInfoSaveStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.tr.saveChanges)),
          );
          return;
        }

        if (state.saveStatus == PersonalInfoSaveStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: BlocBuilder<PersonalInfoCubit, PersonalInfoState>(
        buildWhen: (previous, current) =>
            previous.isEditing != current.isEditing ||
            previous.saveStatus != current.saveStatus,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: PersonalInfoAppBar(
              title: context.tr.personalInformation,
              actionLabel:
                  state.isEditing ? context.tr.saveChanges : context.tr.edit,
              isEditing: state.isEditing,
              isSaving: state.saveStatus == PersonalInfoSaveStatus.saving,
              onActionPressed: () {
                final cubit = context.read<PersonalInfoCubit>();
                if (!state.isEditing) {
                  cubit.startEditing();
                } else {
                  cubit.saveChanges();
                }
              },
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (state.isEditing)
                      PersonalInfoEditContentWidget(state: state)
                    else
                      PersonalInfoViewContentWidget(state: state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

