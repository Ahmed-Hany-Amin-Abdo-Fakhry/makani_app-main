import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Features/AddAd/Cubit/add_ad_cubit.dart';
import 'package:makani_app/Features/Home/View/Widgets/sell_flow_scope.dart';
import 'package:makani_app/Routing/routes.dart';

class AddAdPublishSuccessScreen extends StatefulWidget {
  const AddAdPublishSuccessScreen({super.key});

  @override
  State<AddAdPublishSuccessScreen> createState() =>
      _AddAdPublishSuccessScreenState();
}

class _AddAdPublishSuccessScreenState extends State<AddAdPublishSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish(BuildContext context) {
    final wasEditing = context.read<AddAdCubit>().state.isEditing;
    context.read<AddAdCubit>().resetFlow();
    Navigator.of(context).popUntil((r) => r.isFirst);
    if (wasEditing) {
      context.go('${Routes.home.path}?tab=myAds');
      return;
    }
    SellFlowScope.maybeOf(context)?.onGoHome();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.tr;
    final scale = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    final fade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 1, curve: Curves.easeOut),
    );

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Column(
              children: [
                const Spacer(flex: 2),
                ScaleTransition(
                  scale: scale,
                  child: Container(
                    width: 104.r,
                    height: 104.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success.withValues(alpha: 0.15),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 58.r,
                      color: AppColors.success,
                    ),
                  ),
                ),
                SizedBox(height: 28.h),
                FadeTransition(
                  opacity: fade,
                  child: Column(
                    children: [
                      Text(
                        s.addAdListingPublishedTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        s.addAdListingPublishedSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.sp,
                          height: 1.45,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(flex: 3),
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: FilledButton(
                    onPressed: () => _finish(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      s.addAdPublishSuccessDone,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
