import 'package:url_launcher/url_launcher.dart';

/// Opens the dialer with [rawPhone] (digits and + kept).
Future<bool> launchPropertyPhoneCall(String? rawPhone) async {
  if (rawPhone == null || rawPhone.trim().isEmpty) return false;
  final normalized = rawPhone.replaceAll(RegExp(r'[\s\-()]'), '');
  if (normalized.isEmpty) return false;
  final uri = Uri.parse('tel:$normalized');
  if (!await canLaunchUrl(uri)) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Opens Google Maps with driving directions to [latitude],[longitude].
Future<bool> launchGoogleMapsDirections({
  required double latitude,
  required double longitude,
}) async {
  final uri = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude',
  );
  if (!await canLaunchUrl(uri)) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Search / directions fallback when coordinates are missing.
Future<bool> launchGoogleMapsQuery(String query) async {
  final q = query.trim();
  if (q.isEmpty) return false;
  final uri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(q)}',
  );
  if (!await canLaunchUrl(uri)) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
