import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// Thrown when current location cannot be resolved (same flow as [AddAdCubit.useCurrentLocation]).
class CurrentLocationException implements Exception {
  CurrentLocationException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Shared permission + [Geolocator.getCurrentPosition] used by Add Ad and Home.
class CurrentLocationService {
  Future<Position> getCurrentPosition() async {
    var status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      status = await Permission.locationWhenInUse.request();
    }
    if (!status.isGranted) {
      throw CurrentLocationException('Location permission denied');
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw CurrentLocationException('Location services are disabled');
    }

    return Geolocator.getCurrentPosition();
  }
}
