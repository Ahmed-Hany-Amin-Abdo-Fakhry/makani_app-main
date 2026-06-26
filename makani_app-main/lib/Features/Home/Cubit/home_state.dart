import 'package:makani_app/Features/Listings/Model/property_listing.dart';
import 'package:makani_app/Features/Home/Model/home_recommendation.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.items,
    required this.recommendations,
    this.hasActiveFilters = false,
  });
  final List<PropertyListing> items;
  final List<HomeRecommendation> recommendations;
  final bool hasActiveFilters;
}

final class HomeFailure extends HomeState {
  const HomeFailure({required this.message});
  final String message;
}
