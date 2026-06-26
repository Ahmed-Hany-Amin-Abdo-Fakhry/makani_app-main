import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Features/AddAd/Cubit/add_ad_cubit.dart';
import 'package:makani_app/Features/AddAd/Cubit/add_ad_state.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_enums.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_constants.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_l10n_helpers.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_navigation_buttons.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_step_progress.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/gender_segmented_control.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/property_type_card.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/study_field_chip_grid.dart';
import 'package:makani_app/Features/AddAd/add_ad_flow_routes.dart';
import 'package:makani_app/Features/Home/View/Widgets/sell_flow_scope.dart';
import 'package:makani_app/Routing/routes.dart';

class AddAdTypeScreen extends StatelessWidget {
  const AddAdTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.tr;
    return BlocBuilder<AddAdCubit, AddAdState>(
      builder: (context, state) {
        final c = context.read<AddAdCubit>();
        final draft = state.draft;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(state.isEditing ? 'Edit Ad' : s.addNewAd),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                if (state.isEditing) {
                  context.go('${Routes.home.path}?tab=myAds');
                  return;
                }
                if (Navigator.of(context).canPop()) {
                  context.popAddAdFlow();
                } else if (Navigator.of(context, rootNavigator: true).canPop()) {
                  Navigator.of(context, rootNavigator: true).pop();
                } else {
                  SellFlowScope.maybeOf(context)?.onGoHome();
                }
              },
            ),
          ),
          body: Column(
            children: [
              AddAdStepProgress(
                activeIndex: 0,
                labels: addAdStepLabels(s),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        s.addAdWhatRenting,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      ...AddAdPropertyType.values.map((t) {
                        return PropertyTypeCard(
                          icon: addAdPropertyTypeIcon(t),
                          label: addAdPropertyTypeLabel(s, t),
                          selected: draft.propertyType == t,
                          onTap: () => c.setPropertyType(t),
                        );
                      }),
                      SizedBox(height: 8.h),
                      Text(
                        s.addAdWhoCanRent,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      GenderSegmentedControl(
                        value: draft.genderPreference,
                        onChanged: c.setGenderPreference,
                        labelMale: s.addAdMale,
                        labelFemale: s.addAdFemale,
                        labelAny: s.any,
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        s.addAdPreferredFieldOfStudy,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      StudyFieldChipGrid(
                        ids: AddAdConstants.studyFieldIds,
                        labelFor: (id) => addAdStudyLabel(s, id),
                        selected: draft.studyFieldIds,
                        onToggle: c.toggleStudyField,
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              AddAdNavigationButtons(
                showBack: false,
                primaryLabel: s.addAdContinue,
                primaryEnabled: state.canContinueStep1,
                onPrimary: () {
                  if (state.canContinueStep1) {
                    context.pushAddAdFlow(AddAdFlowRoutes.location);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
