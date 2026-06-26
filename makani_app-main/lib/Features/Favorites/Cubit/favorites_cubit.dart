import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makani_app/Features/Favorites/Cubit/favorites_state.dart';
import 'package:makani_app/Features/Favorites/Repositories/favorites_repository.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(
    this._favoritesRepository,
    this._auth,
  ) : super(const FavoritesInitial()) {
    _authSub = _auth.authStateChanges().listen((_) => load());
    load();
  }

  final FavoritesRepository _favoritesRepository;
  final FirebaseAuth _auth;
  StreamSubscription<User?>? _authSub;

  Future<void> load() async {
    final user = _auth.currentUser;
    if (user == null) {
      emit(const FavoritesLoaded(items: [], favoriteIds: {}));
      return;
    }
    emit(const FavoritesLoading());
    try {
      final items = await _favoritesRepository.loadFavoriteListings(user.uid);
      emit(FavoritesLoaded(
        items: items,
        favoriteIds: items.map((e) => e.id).toSet(),
      ));
    } catch (e) {
      emit(FavoritesFailure(e.toString()));
    }
  }

  Future<void> toggleFavorite(String listingId) async {
    final user = _auth.currentUser;
    if (user == null) return;
    final cur = state;
    final isFav =
        cur is FavoritesLoaded && cur.favoriteIds.contains(listingId);
    try {
      if (isFav) {
        await _favoritesRepository.removeFavorite(user.uid, listingId);
      } else {
        await _favoritesRepository.addFavorite(user.uid, listingId);
      }
      await load();
    } catch (e) {
      await load();
    }
  }

  Future<void> removeFavorite(String listingId) async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      await _favoritesRepository.removeFavorite(user.uid, listingId);
      await load();
    } catch (_) {
      await load();
    }
  }

  bool isFavorited(String listingId) {
    final cur = state;
    return cur is FavoritesLoaded && cur.favoriteIds.contains(listingId);
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
