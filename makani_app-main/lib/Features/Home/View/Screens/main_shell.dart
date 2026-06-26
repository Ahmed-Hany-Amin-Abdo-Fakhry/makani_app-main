import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Features/Auth/Cubit/auth_cubit.dart';
import 'package:makani_app/Features/Home/View/Screens/favorites_tab.dart';
import 'package:makani_app/Features/Home/View/Screens/home_tab.dart';
import 'package:makani_app/Features/Home/View/Screens/sell_tab.dart';
import 'package:makani_app/Features/Home/View/Widgets/ai_chat_bottom_sheet.dart';
import 'package:makani_app/Features/Home/View/Widgets/sell_flow_scope.dart';
import 'package:makani_app/Features/MyAds/View/Screens/my_ads_tab.dart';
import 'package:makani_app/Features/Profile/View/Screens/profile_tab.dart';
import 'package:makani_app/Routing/routes.dart';

import '../../../../Core/Const/assets.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, this.initialIndex, this.sellFlowArgs});

  final int? initialIndex;
  final SellFlowArgs? sellFlowArgs;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex ?? 0;
  }

  void _openChatBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => const AiChatBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SellFlowScope(
        onGoHome: () => setState(() => _index = 0),
        child: IndexedStack(
          index: _index,
          children: [
            const HomeTab(),
            const FavoritesTab(),
            SellTab(initialArgs: widget.sellFlowArgs),
            const MyAdsTab(),
            const ProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) {
          final isAuthed = context.read<AuthCubit>().state is AuthAuthenticated;
          const guestRestrictedTabs = {
            1,
            2,
            3,
            4
          }; // fav, sell, my ads, profile

          if (!isAuthed && guestRestrictedTabs.contains(i)) {
            context.pushNamed(Routes.login.name);
            return;
          }

          setState(() => _index = i);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary700,
        unselectedItemColor: AppColors.textSecondary,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.homeIcon,
                height: 24.h,
                colorFilter: _index == 0
                    ? ColorFilter.mode(AppColors.primary700, BlendMode.srcIn)
                    : null),
            label: context.tr.home,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.favIcon,
                height: 24.h,
                colorFilter: _index == 1
                    ? ColorFilter.mode(AppColors.primary700, BlendMode.srcIn)
                    : null),
            label: context.tr.favorites,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.addIcon,
                height: 24.h,
                colorFilter: _index == 2
                    ? ColorFilter.mode(AppColors.primary700, BlendMode.srcIn)
                    : null),
            label: context.tr.sell,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.myAdIcon,
                height: 24.h,
                colorFilter: _index == 3
                    ? ColorFilter.mode(AppColors.primary700, BlendMode.srcIn)
                    : null),
            label: context.tr.myAds,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(Assets.profileIcon,
                height: 24.h,
                colorFilter: _index == 4
                    ? ColorFilter.mode(AppColors.primary700, BlendMode.srcIn)
                    : null),
            label: context.tr.profile,
          ),
        ],
      ),
      floatingActionButton: _index == 0
          ? FloatingActionButton(
              onPressed: _openChatBottomSheet,
              backgroundColor: AppColors.primary700,
              shape: const CircleBorder(),
              child: SvgPicture.asset(
                Assets.aiIcon,
                width: 24.w,
                height: 24.h,
              ),
            )
          : null,
    );
  }
}
