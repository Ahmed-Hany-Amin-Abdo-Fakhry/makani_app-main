import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makani_app/Features/AddAd/Cubit/add_ad_cubit.dart';
import 'package:makani_app/Core/Services/current_location_service.dart';
import 'package:makani_app/Features/AddAd/Repositories/add_property_repository.dart';
import 'package:makani_app/Features/AddAd/Services/listing_verification_firestore_service.dart'
    show ListingVerificationStore;
import 'package:makani_app/Features/AddAd/add_ad_flow_routes.dart';
import 'package:makani_app/Features/AddAd/View/Screens/add_ad_details_screen.dart';
import 'package:makani_app/Features/AddAd/View/Screens/add_ad_location_screen.dart';
import 'package:makani_app/Features/AddAd/View/Screens/add_ad_photos_screen.dart';
import 'package:makani_app/Features/AddAd/View/Screens/add_ad_publish_success_screen.dart';
import 'package:makani_app/Features/AddAd/View/Screens/add_ad_review_screen.dart';
import 'package:makani_app/Features/AddAd/View/Screens/add_ad_type_screen.dart';
import 'package:makani_app/Features/Listings/Model/property_listing.dart';

class SellFlowArgs {
  SellFlowArgs.edit({required this.listing}) : editListingId = listing.id;

  final String editListingId;
  final PropertyListing listing;
}

/// Sell tab: full add-property flow with [MainShell] bottom bar visible.
class SellTab extends StatefulWidget {
  const SellTab({super.key, this.initialArgs});

  final SellFlowArgs? initialArgs;

  @override
  State<SellTab> createState() => _SellTabState();
}

class _SellTabState extends State<SellTab> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  AddAdCubit? _cubit;
  String? _appliedEditListingId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cubit ??= AddAdCubit(
      addPropertyRepository: context.read<AddPropertyRepository>(),
      verificationStore: context.read<ListingVerificationStore>(),
      locationService: context.read<CurrentLocationService>(),
    );
    _applyInitialArgsIfNeeded();
  }

  @override
  void dispose() {
    _cubit?.close();
    super.dispose();
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case AddAdFlowRoutes.type:
        page = const AddAdTypeScreen();
        break;
      case AddAdFlowRoutes.location:
        page = const AddAdLocationScreen();
        break;
      case AddAdFlowRoutes.details:
        page = const AddAdDetailsScreen();
        break;
      case AddAdFlowRoutes.photos:
        page = const AddAdPhotosScreen();
        break;
      case AddAdFlowRoutes.review:
        page = const AddAdReviewScreen();
        break;
      case AddAdFlowRoutes.publishSuccess:
        page = const AddAdPublishSuccessScreen();
        break;
      default:
        page = const AddAdTypeScreen();
    }
    return MaterialPageRoute<void>(
      settings: RouteSettings(
        name: settings.name ?? AddAdFlowRoutes.type,
        arguments: settings.arguments,
      ),
      builder: (_) => page,
    );
  }

  @override
  Widget build(BuildContext context) {
    _applyInitialArgsIfNeeded();
    final cubit = _cubit;
    if (cubit == null) {
      return const SizedBox.shrink();
    }
    return BlocProvider<AddAdCubit>.value(
      value: cubit,
      child: Navigator(
        key: _navigatorKey,
        initialRoute: AddAdFlowRoutes.type,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  void _applyInitialArgsIfNeeded() {
    final args = widget.initialArgs;
    final cubit = _cubit;
    if (args == null || cubit == null) return;
    if (_appliedEditListingId == args.editListingId) return;
    _appliedEditListingId = args.editListingId;
    cubit.loadEditListing(args.listing);
    _navigatorKey.currentState?.popUntil((route) => route.isFirst);
  }
}
