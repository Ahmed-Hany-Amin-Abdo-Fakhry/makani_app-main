import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Features/AddAd/Cubit/add_ad_cubit.dart';
import 'package:makani_app/Features/AddAd/Cubit/add_ad_state.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_draft.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_l10n_helpers.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_navigation_buttons.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_step_progress.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/location_map_picker.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/review_section_card.dart';
import 'package:makani_app/Features/AddAd/add_ad_flow_routes.dart';
import 'package:makani_app/Routing/routes.dart';

class AddAdReviewScreen extends StatelessWidget {
  const AddAdReviewScreen({super.key});

  bool _isRemoteUrl(String path) {
    final uri = Uri.tryParse(path);
    if (uri == null) return false;
    return uri.scheme == 'http' || uri.scheme == 'https';
  }

  String _addressText(AddAdDraft draft, String fallback) {
    if (draft.addressLine != null && draft.addressLine!.trim().isNotEmpty) {
      return draft.addressLine!.trim();
    }
    final parts = <String>[];
    if (draft.district != null && draft.district!.trim().isNotEmpty) {
      parts.add(draft.district!.trim());
    }
    if (draft.governorate != null && draft.governorate!.trim().isNotEmpty) {
      parts.add(draft.governorate!.trim());
    }
    final joined = parts.join(', ');
    return joined.isEmpty ? fallback : joined;
  }

  String _studyLine(dynamic s, Set<String> ids) {
    if (ids.isEmpty) return '—';
    return ids.map((id) => addAdStudyLabel(s, id)).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final s = context.tr;
    return BlocConsumer<AddAdCubit, AddAdState>(
      listenWhen: (p, c) =>
          (c.submitErrorKey != null && c.submitErrorKey != p.submitErrorKey) ||
          (c.publishSucceeded && !p.publishSucceeded),
      listener: (context, state) {
        if (state.publishSucceeded) {
          Navigator.of(context).pushNamed(AddAdFlowRoutes.publishSuccess);
          context.read<AddAdCubit>().clearPublishSuccess();
          return;
        }
        if (state.submitErrorKey != null) {
          final msg = addAdPublishErrorMessage(s, state.submitErrorKey);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
          context.read<AddAdCubit>().clearSubmitError();
        }
      },
      builder: (context, state) {
        final c = context.read<AddAdCubit>();
        final d = state.draft;
        final thumb = d.photoSlots.firstWhere(
          (p) => p.isNotEmpty,
          orElse: () => '',
        );
        final typeLabel = d.propertyType != null
            ? addAdPropertyTypeLabel(s, d.propertyType!)
            : '—';
        final rent = d.monthlyRentText.isEmpty ? '—' : d.monthlyRentText;
        final ownerPhone = d.ownerPhone.trim();
        final showPhoneError = ownerPhone.isEmpty || !state.hasValidOwnerPhone;

        final pct =
            ((state.uploadProgress ?? 0) * 100).round().clamp(0, 100);

        return PopScope(
          canPop: !state.submitting,
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: AppColors.backgroundColor,
                appBar: AppBar(
                  title: Text(state.isEditing ? 'Edit Ad' : s.addNewAd),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: state.submitting
                        ? null
                        : () {
                            if (state.isEditing) {
                              context.go('${Routes.home.path}?tab=myAds');
                              return;
                            }
                            context.popAddAdFlow();
                          },
                  ),
                  actions: [
                    TextButton(
                      onPressed: state.submitting
                          ? null
                          : () => context.popAddAdFlowToType(),
                      child: Text(
                        s.edit,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary700,
                        ),
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    ColoredBox(
                      color: Colors.white,
                      child: AddAdStepProgress(
                        activeIndex: 4,
                        labels: addAdStepLabels(s),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ReviewSectionCard(
                              title: s.addAdListingSummary,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: thumb.isEmpty
                                        ? Container(
                                            width: 72.w,
                                            height: 72.w,
                                            color: AppColors.surface,
                                            child: Icon(Icons.image_outlined,
                                                color: AppColors.gray400),
                                          )
                                        : _isRemoteUrl(thumb)
                                            ? Image.network(
                                                thumb,
                                                width: 72.w,
                                                height: 72.w,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.file(
                                                File(thumb),
                                                width: 72.w,
                                                height: 72.w,
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          typeLabel,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          s.addAdPriceMonthlyShort(rent),
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: AppColors.primary700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          '${d.roomSizeText} ${s.addAdSqmSuffix}',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        SizedBox(height: 6.h),
                                        Text(
                                          s.addAdOpenTo(
                                            addAdGenderLabel(
                                                s, d.genderPreference),
                                          ),
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        Text(
                                          s.addAdPreferredField(
                                            _studyLine(s, d.studyFieldIds),
                                          ),
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ReviewSectionCard(
                              title: s.addAdDetailsAmenitiesSection,
                              initiallyExpanded: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.addAdPerBed(rent),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      Icon(Icons.bed_outlined, size: 20.r),
                                      SizedBox(width: 4.w),
                                      Text('${d.totalBeds}'),
                                      SizedBox(width: 16.w),
                                      Icon(Icons.hotel_outlined, size: 20.r),
                                      SizedBox(width: 4.w),
                                      Text(s.bedsAvailable('${d.bedsAvailable}')),
                                      SizedBox(width: 16.w),
                                      Icon(Icons.bathtub_outlined, size: 20.r),
                                      SizedBox(width: 4.w),
                                      Text('${d.bathrooms}'),
                                      SizedBox(width: 16.w),
                                      Icon(Icons.square_foot, size: 20.r),
                                      SizedBox(width: 4.w),
                                      Text(d.roomSizeText),
                                    ],
                                  ),
                                  if (d.amenityIds.isNotEmpty) ...[
                                    SizedBox(height: 10.h),
                                    Wrap(
                                      spacing: 8.w,
                                      runSpacing: 8.h,
                                      children: d.amenityIds.map((id) {
                                        return Chip(
                                          label: Text(
                                            addAdAmenityLabel(s, id),
                                            style: TextStyle(fontSize: 12.sp),
                                          ),
                                          visualDensity: VisualDensity.compact,
                                          backgroundColor: AppColors.primary
                                              .withValues(alpha: 0.08),
                                          side: BorderSide(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.3)),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            ReviewSectionCard(
                              title: s.addAdLocationSection,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  IgnorePointer(
                                    child: LocationMapPicker(
                                      latitude: d.latitude,
                                      longitude: d.longitude,
                                      onTapMap: (_, __) {},
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    _addressText(d, s.defaultAddress),
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ReviewSectionCard(
                              title: s.addAdMediaOverview,
                              initiallyExpanded: true,
                              child: SizedBox(
                                height: 160.h,
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 6,
                                    crossAxisSpacing: 6,
                                  ),
                                  itemCount: d.photoSlots
                                      .where((p) => p.isNotEmpty)
                                      .length,
                                  itemBuilder: (context, i) {
                                    final paths = d.photoSlots
                                        .where((p) => p.isNotEmpty)
                                        .toList();
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: _isRemoteUrl(paths[i])
                                          ? Image.network(
                                              paths[i],
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              File(paths[i]),
                                              fit: BoxFit.cover,
                                            ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            if (d.hasContractImage)
                              ReviewSectionCard(
                                title: s.addAdContractTitle,
                                child: Row(
                                  children: [
                                    Icon(Icons.verified_outlined,
                                        size: 22.r, color: AppColors.primary),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        s.addAdContractUploaded,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (d.hasNationalIdImages)
                              ReviewSectionCard(
                                title: s.addAdNationalIdTitle,
                                child: Row(
                                  children: [
                                    Icon(Icons.badge_outlined,
                                        size: 22.r, color: AppColors.primary),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        s.addAdNationalIdUploaded,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ReviewSectionCard(
                              title: s.phoneNumber,
                              initiallyExpanded: true,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    initialValue: d.ownerPhone,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9+\-\s()]'),
                                      ),
                                    ],
                                    decoration: InputDecoration(
                                      hintText: s.phoneNumber,
                                    ),
                                    onChanged: c.setOwnerPhone,
                                  ),
                                  if (showPhoneError) ...[
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Please enter a valid phone number.',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.red.shade700,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ColoredBox(
                      color: Colors.white,
                      child: AddAdNavigationButtons(
                        backLabel: s.back,
                        onBack: state.submitting
                            ? null
                            : () {
                                if (state.isEditing) {
                                  context.go('${Routes.home.path}?tab=myAds');
                                  return;
                                }
                                context.popAddAdFlow();
                              },
                        primaryLabel:
                            state.isEditing ? s.saveChanges : s.addAdPublishListing,
                        primaryIcon: Icons.send_rounded,
                        primaryEnabled:
                            state.canPublish && !state.submitting,
                        primaryLoading: false,
                        onPrimary: () async {
                          if (!state.canPublish || state.submitting) return;
                          await c.submit();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (state.submitting)
                Positioned.fill(
                  child: AbsorbPointer(
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.sizeOf(context).width * 0.78,
                            maxWidth: MediaQuery.sizeOf(context).width * 0.9,
                          ),
                          child: Card(
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 36.w,
                                vertical: 40.h,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 104.r,
                                    height: 104.r,
                                    child: CircularProgressIndicator(
                                      value: state.uploadProgress,
                                      strokeWidth: 6,
                                      color: AppColors.primary700,
                                      backgroundColor: AppColors.primary
                                          .withValues(alpha: 0.15),
                                    ),
                                  ),
                                  SizedBox(height: 28.h),
                                  Text(
                                    s.addAdUploadProgressPercent(pct),
                                    style: TextStyle(
                                      fontSize: 32.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    s.addAdPublishingTitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      height: 1.4,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
