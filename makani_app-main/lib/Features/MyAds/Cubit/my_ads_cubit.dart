import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makani_app/Features/Listings/Repositories/listings_repository.dart';
import 'package:makani_app/Features/MyAds/Cubit/my_ads_state.dart';

class MyAdsCubit extends Cubit<MyAdsState> {
  MyAdsCubit(this._listings, this._auth) : super(const MyAdsInitial()) {
    _lastUid = _auth.currentUser?.uid;
    _authSub = _auth.authStateChanges().listen(_onAuthChanged);
    load();
  }

  final ListingsRepository _listings;
  final FirebaseAuth _auth;
  StreamSubscription<User?>? _authSub;
  String? _lastUid;

  void _onAuthChanged(User? user) {
    final nextUid = user?.uid;
    if (nextUid == _lastUid) return;
    _lastUid = nextUid;
    unawaited(load());
  }

  Future<void> load() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      emit(const MyAdsLoaded([]));
      return;
    }
    emit(const MyAdsLoading());
    try {
      final items = await _listings.fetchListingsByOwner(uid);
      emit(MyAdsLoaded(items));
    } catch (e) {
      emit(MyAdsFailure(e.toString()));
    }
  }

  Future<void> deleteListing(String id) async {
    try {
      await _listings.deleteListing(id);
      await load();
    } catch (e) {
      emit(MyAdsFailure(e.toString()));
    }
  }

  Future<void> setAvailability(String id, {required bool available}) async {
    try {
      await _listings.setListingStatus(
        id,
        available ? 'active' : 'paused',
      );
      await load();
    } catch (e) {
      emit(MyAdsFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
