import 'package:makani_app/Features/Listings/Model/property_listing.dart';

sealed class FavoritesState {
  const FavoritesState();
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

final class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

final class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded({
    required this.items,
    required this.favoriteIds,
  });

  final List<PropertyListing> items;
  final Set<String> favoriteIds;
}

final class FavoritesFailure extends FavoritesState {
  const FavoritesFailure(this.message);
  final String message;
}
