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
import 'package:makani_app/Features/AddAd/View/Widgets/contract_upload_tile.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/photo_upload_grid.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/video_upload_placeholder.dart';
import 'package:makani_app/Features/AddAd/add_ad_flow_routes.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/media_source_bottom_sheet.dart';
import 'package:makani_app/Routing/routes.dart';

class AddAdPhotosScreen extends StatelessWidget {
  const AddAdPhotosScreen({super.key});

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
          final filled = draft.filledPhotoCount;

          return Column(
            children: [
              AddAdStepProgress(
                activeIndex: 3,
                labels: addAdStepLabels(s),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AddAdScreenHeader(
                              title: s.addAdMediaUpload,
                              subtitle: s.addAdMediaSubtitle,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
                            ),
                            child: Text(
                              s.addAdPhotosUploaded(
                                '$filled',
                                '${AddAdConstants.maxPhotos}',
                              ),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      PhotoUploadGrid(
                        slots: draft.photoSlots,
                        addLabel: s.addAdAddPhoto,
                        onAdd: (i) {
                          showAddAdMediaSourceSheet(context).then((src) {
                            if (src != null && context.mounted) {
                              c.pickPhotoForSlot(i, src);
                            }
                          });
                        },
                        onRemove: (i) => c.removePhotoAt(i),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              size: 18.r, color: Colors.orange.shade800),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              s.addAdMinTwoPhotosWarning,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      ContractUploadTile(
                        imagePath: draft.contractImagePath,
                        title: s.addAdContractTitle,
                        hint: s.addAdContractHint,
                        tapToUploadLabel: s.addAdContractTapToUpload,
                        onPick: () {
                          showAddAdMediaSourceSheet(context).then((src) {
                            if (src != null && context.mounted) {
                              c.pickContractImage(src);
                            }
                          });
                        },
                        onRemove: c.clearContractImage,
                      ),
                      if (!draft.hasContractImage) ...[
                        SizedBox(height: 8.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline,
                                size: 18.r, color: Colors.orange.shade800),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                s.addAdContractRequiredWarning,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 24.h),
                      Text(
                        s.addAdNationalIdTitle,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        s.addAdNationalIdHint,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ContractUploadTile(
                              compact: true,
                              placeholderIcon: Icons.badge_outlined,
                              imagePath: draft.nationalIdFrontPath,
                              title: s.addAdNationalIdFrontLabel,
                              hint: '',
                              tapToUploadLabel: s.addAdNationalIdFrontTapToUpload,
                              onPick: () {
                                showAddAdMediaSourceSheet(context).then((src) {
                                  if (src != null && context.mounted) {
                                    c.pickNationalIdFront(src);
                                  }
                                });
                              },
                              onRemove: c.clearNationalIdFront,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ContractUploadTile(
                              compact: true,
                              placeholderIcon: Icons.badge_outlined,
                              imagePath: draft.nationalIdBackPath,
                              title: s.addAdNationalIdBackLabel,
                              hint: '',
                              tapToUploadLabel: s.addAdNationalIdBackTapToUpload,
                              onPick: () {
                                showAddAdMediaSourceSheet(context).then((src) {
                                  if (src != null && context.mounted) {
                                    c.pickNationalIdBack(src);
                                  }
                                });
                              },
                              onRemove: c.clearNationalIdBack,
                            ),
                          ),
                        ],
                      ),
                      if (!draft.hasNationalIdImages) ...[
                        SizedBox(height: 8.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline,
                                size: 18.r, color: Colors.orange.shade800),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                s.addAdNationalIdRequiredWarning,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 20.h),
                      VideoUploadPlaceholder(
                        title: draft.videoPath != null
                            ? s.video
                            : s.addAdUploadPropertyVideo,
                        subtitle: s.addAdVideoFormats,
                        hasVideo: draft.videoPath != null,
                        onClear: draft.videoPath != null ? c.clearVideo : null,
                        onTap: () {
                          showAddAdMediaSourceSheet(context).then((src) {
                            if (src != null && context.mounted) {
                              c.pickVideo(src);
                            }
                          });
                        },
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
                primaryEnabled: state.canContinueStep4,
                onPrimary: () {
                  if (state.canContinueStep4) {
                    context.pushAddAdFlow(AddAdFlowRoutes.review);
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
