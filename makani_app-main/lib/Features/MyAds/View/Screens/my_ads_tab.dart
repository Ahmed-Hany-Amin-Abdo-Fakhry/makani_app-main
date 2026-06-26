import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Features/Home/Models/my_ad_item.dart';
import 'package:makani_app/Features/Home/View/Screens/sell_tab.dart';
import 'package:makani_app/Features/Home/View/Widgets/my_ad_card.dart';
import 'package:makani_app/Features/Listings/Model/listing_presenter.dart';
import 'package:makani_app/Features/Listings/Model/property_listing.dart';
import 'package:makani_app/Features/MyAds/Cubit/my_ads_cubit.dart';
import 'package:makani_app/Features/MyAds/Cubit/my_ads_state.dart';
import 'package:makani_app/Routing/routes.dart';
import 'package:makani_app/generated/l10n.dart';

MyAdItem _listingToMyAdItem(S s, PropertyListing p) {
  final vm = listingToCardViewModel(s, p);
  return MyAdItem(
    id: p.id,
    title: vm.title,
    location: vm.location,
    price: vm.price,
    imageUrl: vm.imageUrl,
    isShared: p.propertyTypeKey == 'singleBed',
    isAvailable: p.status == 'active',
  );
}

class MyAdsTab extends StatefulWidget {
  const MyAdsTab({super.key});

  @override
  State<MyAdsTab> createState() => _MyAdsTabState();
}

class _MyAdsTabState extends State<MyAdsTab> {
  Future<void> _refresh() async {
    await context.read<MyAdsCubit>().load();
  }

  void _openEditFlow(PropertyListing listing) {
    context.pushNamed(
      Routes.editAd.name,
      extra: SellFlowArgs.edit(listing: listing),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<MyAdsCubit>().load();
    });
  }

  Future<void> _confirmDelete(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr.myAds),
        content: const Text('Delete this listing?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              context.tr.send,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await context.read<MyAdsCubit>().deleteListing(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = context.tr;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: AppColors.divider),
        ),
        title: Text(
          s.myAds,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        titleSpacing: 20.w,
      ),
      body: BlocBuilder<MyAdsCubit, MyAdsState>(
        builder: (context, state) {
          if (state is MyAdsLoading || state is MyAdsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is MyAdsFailure) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    SizedBox(height: 16.h),
                    FilledButton(
                      onPressed: () => context.read<MyAdsCubit>().load(),
                      child: Text(s.addAdContinue),
                    ),
                  ],
                ),
              ),
            );
          }
          final loaded = state as MyAdsLoaded;
          final items = loaded.items.map((p) => _listingToMyAdItem(s, p)).toList();
          if (items.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Center(
                      child: Text(
                        s.searchLocationPlaceholder,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final listing = loaded.items[index];
                return MyAdCard(
                  item: item,
                  onToggle: (v) => context
                      .read<MyAdsCubit>()
                      .setAvailability(item.id, available: v),
                  onCardTap: () => _openEditFlow(listing),
                  onEdit: () => _openEditFlow(listing),
                  onDelete: () => _confirmDelete(item.id),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
