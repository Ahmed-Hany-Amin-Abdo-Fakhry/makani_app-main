import 'package:flutter/material.dart';

/// Static option ids for chips and amenities (labels from l10n in UI).
class AddAdConstants {
  AddAdConstants._();

  static const List<String> studyFieldIds = [
    'engineering',
    'education',
    'sales',
    'law',
    'finance',
    'medicine',
    'marketing',
    'psychology',
    'architecture',
    'nursing',
    'business',
    'it',
    'open_to_all',
  ];

  static const Map<String, IconData> amenityIcons = {
    'wifi': Icons.wifi,
    'ac': Icons.ac_unit,
    'kitchen': Icons.kitchen_outlined,
    'balcony': Icons.balcony_outlined,
    'study_desk': Icons.desktop_windows_outlined,
    'parking': Icons.local_parking_outlined,
  };

  static const List<String> amenityIdsOrdered = [
    'wifi',
    'ac',
    'kitchen',
    'balcony',
    'study_desk',
    'parking',
  ];

  static const Map<String, List<String>> governoratesDistricts = {
    'Cairo': ['Nasr City', 'Maadi', 'Heliopolis', 'Downtown', 'New Cairo'],
    'Giza': ['Dokki', 'Mohandessin', '6th October', 'Sheikh Zayed', 'Haram'],
    'Alexandria': ['Smouha', 'Sidi Gaber', 'Miami', 'Stanley', 'Agami'],
    'Port Said': ['Al-Arab', 'Port Fouad', 'Downtown', 'Al-Manakh'],
    'Ismailia': ['City Center', 'Fayed', 'Qantara'],
  };

  static List<String> get governorates =>
      governoratesDistricts.keys.toList()..sort();

  static List<String> districtsFor(String? governorate) {
    if (governorate == null) return const [];
    return List<String>.from(
      governoratesDistricts[governorate] ?? const [],
    );
  }

  static const double defaultLat = 30.0444;
  static const double defaultLng = 31.2357;

  static const int maxPhotos = 4;
  static const int minPhotos = 2;
  static const int maxVideoBytes = 50 * 1024 * 1024;
}
