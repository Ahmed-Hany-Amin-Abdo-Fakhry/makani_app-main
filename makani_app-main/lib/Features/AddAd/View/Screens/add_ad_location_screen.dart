import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Features/AddAd/Cubit/add_ad_cubit.dart';
import 'package:makani_app/Features/AddAd/Cubit/add_ad_state.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_constants.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_navigation_buttons.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_screen_header.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_step_progress.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/labeled_dropdown_field.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/location_map_picker.dart';
import 'package:makani_app/Features/AddAd/add_ad_flow_routes.dart';
import 'package:makani_app/Routing/routes.dart';

class AddAdLocationScreen extends StatefulWidget {
  const AddAdLocationScreen({super.key});

  @override
  State<AddAdLocationScreen> createState() => _AddAdLocationScreenState();
}

class _AddAdLocationScreenState extends State<AddAdLocationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<AddAdCubit>();
      if (cubit.state.draft.latitude == null ||
          cubit.state.draft.longitude == null) {
        cubit.setPin(AddAdConstants.defaultLat, AddAdConstants.defaultLng);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = context.tr;
    final isEditing = context.select((AddAdCubit c) => c.state.isEditing);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Ad' : s.addNewAd),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            if (isEditing) {
              context.go('${Routes.home.path}?tab=myAds');
              return;
            }
            context.popAddAdFlow();
          },
        ),
      ),
      body: BlocConsumer<AddAdCubit, AddAdState>(
        listenWhen: (p, c) =>
            c.locationMessage != null && c.locationMessage != p.locationMessage,
        listener: (context, state) {
          final m = state.locationMessage;
          if (m != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
            context.read<AddAdCubit>().clearTransientMessage();
          }
        },
        builder: (context, state) {
          final c = context.read<AddAdCubit>();
          final draft = state.draft;
          final govs = AddAdConstants.governorates;
          final dists = AddAdConstants.districtsFor(draft.governorate);

          return Column(
            children: [
              AddAdStepProgress(
                activeIndex: 1,
                labels: addAdStepLabels(s),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AddAdScreenHeader(
                        title: s.addAdLocationDetails,
                        subtitle: s.addAdLocationDetailsSubtitle,
                      ),
                      LabeledDropdownField<String>(
                        label: s.addAdGovernorate,
                        hint: s.addAdSelectGovernorate,
                        value: draft.governorate,
                        items: govs,
                        itemLabel: (e) => e,
                        onChanged: c.setGovernorate,
                      ),
                      SizedBox(height: 16.h),
                      LabeledDropdownField<String>(
                        label: s.addAdDistrict,
                        hint: s.addAdSelectDistrict,
                        value: draft.district,
                        items: dists,
                        itemLabel: (e) => e,
                        enabled: draft.governorate != null,
                        onChanged: c.setDistrict,
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Text(
                            s.addAdExtractLocation,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: state.locationLoading
                                ? null
                                : () => c.useCurrentLocation(),
                            icon: Icon(Icons.near_me_outlined,
                                size: 18.r, color: AppColors.primary700),
                            label: Text(
                              s.addAdUseCurrentLocation,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      LocationMapPicker(
                        latitude: draft.latitude,
                        longitude: draft.longitude,
                        loading: state.locationLoading,
                        onTapMap: c.setPin,
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: AppColors.gray50,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.gray200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.map_outlined,
                                size: 20.r, color: AppColors.textSecondary),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                s.addAdTapMapToAdjustPin,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              AddAdNavigationButtons(
                backLabel: s.back,
                onBack: () {
                  if (isEditing) {
                    context.go('${Routes.home.path}?tab=myAds');
                    return;
                  }
                  context.popAddAdFlow();
                },
                primaryLabel: s.addAdContinue,
                primaryEnabled: state.canContinueStep2,
                onPrimary: () {
                  if (state.canContinueStep2) {
                    context.pushAddAdFlow(AddAdFlowRoutes.details);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
