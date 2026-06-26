import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Features/AddAd/Cubit/add_ad_cubit.dart';
import 'package:makani_app/Features/AddAd/Cubit/add_ad_state.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_navigation_buttons.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_screen_header.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_step_progress.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/amenity_toggle_grid.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/counter_row.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_l10n_helpers.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/rent_input_row.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/room_size_field.dart';
import 'package:makani_app/Features/AddAd/add_ad_flow_routes.dart';
import 'package:makani_app/Routing/routes.dart';

class AddAdDetailsScreen extends StatelessWidget {
  const AddAdDetailsScreen({super.key});

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
      body: BlocBuilder<AddAdCubit, AddAdState>(
        builder: (context, state) {
          final c = context.read<AddAdCubit>();
          final draft = state.draft;
          return Column(
            children: [
              AddAdStepProgress(
                activeIndex: 2,
                labels: addAdStepLabels(s),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AddAdScreenHeader(
                        title: s.addAdDetailsAndAmenities,
                        subtitle: s.addAdDetailsSubtitle,
                      ),
                      RentInputRow(
                        label: s.addAdMonthlyRent,
                        hint: s.addAdRentHint,
                        prefix: 'EGP',
                        suffix: s.addAdMonthlySuffix,
                        value: draft.monthlyRentText,
                        onChanged: c.setMonthlyRentText,
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          CounterRow(
                            title: s.addAdTotalBeds,
                            value: draft.totalBeds,
                            onMinus: c.decrementBeds,
                            onPlus: c.incrementBeds,
                          ),
                          SizedBox(width: 12.w),
                          CounterRow(
                            title: s.addAdBedsAvailable,
                            value: draft.bedsAvailable,
                            onMinus: c.decrementBedsAvailable,
                            onPlus: c.incrementBedsAvailable,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          CounterRow(
                            title: s.bathrooms.toUpperCase(),
                            value: draft.bathrooms,
                            onMinus: c.decrementBathrooms,
                            onPlus: c.incrementBathrooms,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      RoomSizeField(
                        label: s.addAdRoomSize,
                        suffix: s.addAdSqmSuffix,
                        value: draft.roomSizeText,
                        onChanged: c.setRoomSizeText,
                      ),
                      SizedBox(height: 8.h),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        value: draft.utilitiesIncluded,
                        onChanged: (v) =>
                            c.setUtilitiesIncluded(v ?? false),
                        title: Text(
                          s.utilitiesIncluded,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        s.amenities,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      AmenityToggleGrid(
                        selected: draft.amenityIds,
                        labelFor: (id) => addAdAmenityLabel(s, id),
                        onToggle: c.toggleAmenity,
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
                primaryEnabled: state.canContinueStep3,
                onPrimary: () {
                  if (state.canContinueStep3) {
                    context.pushAddAdFlow(AddAdFlowRoutes.photos);
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
