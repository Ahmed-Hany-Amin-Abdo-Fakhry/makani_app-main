import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:makani_app/Core/Services/current_location_service.dart'
    show CurrentLocationException, CurrentLocationService;
import 'package:makani_app/Core/Services/reverse_geocode_service.dart';
import 'package:makani_app/Features/Location/Cubit/user_location_state.dart';

class UserLocationCubit extends Cubit<UserLocationState> {
  UserLocationCubit({
    required CurrentLocationService locationService,
    required ReverseGeocodeService reverseGeocode,
  })  : _location = locationService,
        _geo = reverseGeocode,
        super(const UserLocationInitial()) {
    refresh();
  }

  final CurrentLocationService _location;
  final ReverseGeocodeService _geo;

  Future<void> refresh() async {
    emit(const UserLocationLoading());
    try {
      final pos = await _location.getCurrentPosition();
      final line = await _geo.formatAddress(pos.latitude, pos.longitude);
      emit(UserLocationReady(
        latitude: pos.latitude,
        longitude: pos.longitude,
        displayLine: line,
      ));
    } on CurrentLocationException catch (e) {
      emit(UserLocationError(message: e.message));
    } catch (e) {
      emit(UserLocationError(message: e.toString()));
    }
  }
}
