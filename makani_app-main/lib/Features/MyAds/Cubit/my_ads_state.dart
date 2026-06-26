import 'package:makani_app/Features/Listings/Model/property_listing.dart';

sealed class MyAdsState {
  const MyAdsState();
}

final class MyAdsInitial extends MyAdsState {
  const MyAdsInitial();
}

final class MyAdsLoading extends MyAdsState {
  const MyAdsLoading();
}

final class MyAdsLoaded extends MyAdsState {
  const MyAdsLoaded(this.items);
  final List<PropertyListing> items;
}

final class MyAdsFailure extends MyAdsState {
  const MyAdsFailure(this.message);
  final String message;
}
