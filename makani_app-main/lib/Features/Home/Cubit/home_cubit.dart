import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makani_app/Features/Home/Model/home_recommendation.dart';
import 'package:makani_app/Features/Home/Repositories/recommendation_repository.dart';
import 'package:makani_app/Features/Home/Cubit/home_state.dart';
import 'package:makani_app/Features/Listings/Model/listing_query.dart';
import 'package:makani_app/Features/Listings/Repositories/listings_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._listings, this._recommendations)
      : super(const HomeInitial()) {
    loadListings();
  }

  final ListingsRepository _listings;
  final RecommendationRepository _recommendations;

  ListingQuery _listingQuery = ListingQuery.empty;
  String _searchText = '';

  ListingQuery get listingQuery => _listingQuery;

  String get searchText => _searchText;

  void setListingQuery(ListingQuery query) {
    _listingQuery = query;
    loadListings();
  }

  void setSearchText(String text) {
    if (_searchText == text) return;
    _searchText = text;
    loadListings();
  }

  Future<void> loadListings() async {
    if (state is! HomeLoaded) {
      emit(const HomeLoading());
    }
    try {
      final itemsFuture = _listings.fetchListings(
        query: _listingQuery,
        searchText: _searchText.trim().isEmpty ? null : _searchText.trim(),
      );
      final recommendationFuture = _recommendations.fetchRecommendations(
        query: _listingQuery,
        searchText: _searchText.trim().isEmpty ? null : _searchText.trim(),
        section: 'home',
        limit: 12,
      );

      final items = await itemsFuture;
      List<HomeRecommendation> recommendations;
      try {
        recommendations = await recommendationFuture;
      } catch (_) {
        recommendations = const [];
      }

      emit(HomeLoaded(
        items: items,
        recommendations: recommendations,
        hasActiveFilters: _listingQuery.hasPredicate,
      ));
    } catch (e) {
      emit(HomeFailure(message: e.toString()));
    }
  }
}
