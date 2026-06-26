import 'package:geocoding/geocoding.dart';

/// Turns coordinates into a short address line for the home header.
class ReverseGeocodeService {
  Future<String> formatAddress(double latitude, double longitude) async {
    try {
      final list = await placemarkFromCoordinates(latitude, longitude);
      if (list.isEmpty) {
        return _coordsLine(latitude, longitude);
      }
      final p = list.first;
      final parts = <String>[];
      final street = p.street;
      if (street != null && street.trim().isNotEmpty) {
        parts.add(street.trim());
      } else {
        final name = p.name;
        if (name != null && name.trim().isNotEmpty) {
          parts.add(name.trim());
        }
      }
      final locality = p.locality ?? p.subAdministrativeArea;
      if (locality != null && locality.trim().isNotEmpty) {
        parts.add(locality.trim());
      }
      final region = p.administrativeArea;
      if (region != null && region.trim().isNotEmpty) {
        parts.add(region.trim());
      }
      if (parts.isEmpty) {
        return _coordsLine(latitude, longitude);
      }
      return parts.toSet().join(', ');
    } catch (_) {
      return _coordsLine(latitude, longitude);
    }
  }

  String _coordsLine(double lat, double lng) =>
      '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
}
