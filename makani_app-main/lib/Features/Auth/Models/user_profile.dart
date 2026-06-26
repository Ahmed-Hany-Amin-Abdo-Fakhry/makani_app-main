import 'package:equatable/equatable.dart';

/// A lightweight representation of the user's profile stored in Firestore.
class UserProfile extends Equatable {
  const UserProfile({
    required this.uid,
    required this.fullName,
    required this.email,
    this.phone,
    this.photoBase64,
    required this.provider,
    this.createdAt,
    this.updatedAt,
  });

  final String uid;
  final String fullName;
  final String email;
  final String? phone;
  final String? photoBase64;
  final String provider; // e.g. "google" | "password"
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? photoBase64,
    String? provider,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      uid: uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoBase64: photoBase64 ?? this.photoBase64,
      provider: provider ?? this.provider,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        fullName,
        email,
        phone,
        photoBase64,
        provider,
        createdAt,
        updatedAt,
      ];

  /// Converts this profile to a map suitable for Firestore `set(merge: true)`.
  /// Note: timestamps are intentionally omitted when `null`.
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'fullName': fullName,
      'email': email,
      'provider': provider,
      if (phone != null) 'phone': phone,
      if (photoBase64 != null) 'photoBase64': photoBase64,
    };

    if (createdAt != null) {
      map['createdAt'] = createdAt;
    }
    if (updatedAt != null) {
      map['updatedAt'] = updatedAt;
    }
    return map;
  }

  static UserProfile fromMap({
    required String uid,
    required Map<String, dynamic> map,
  }) {
    String? readString(Map<String, dynamic> source, List<String> keys) {
      for (final key in keys) {
        final value = source[key];
        if (value is String) {
          final trimmed = value.trim();
          if (trimmed.isNotEmpty) return trimmed;
        } else if (value != null) {
          final raw = value.toString().trim();
          if (raw.isNotEmpty) return raw;
        }
      }
      return null;
    }

    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
      // Firestore Timestamp comes as cloud_firestore Timestamp which we keep as dynamic,
      // but expose only DateTime here.
      try {
        final dynamic maybeTimestamp = value;
        if (maybeTimestamp.toDate is Function) {
          return maybeTimestamp.toDate() as DateTime;
        }
      } catch (_) {}
      return null;
    }

    return UserProfile(
      uid: uid,
      fullName: map['fullName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: readString(
        map,
        const ['phone', 'phoneNumber', 'phone_number', 'mobile', 'mobileNumber'],
      ),
      photoBase64: map['photoBase64'] as String?,
      provider: map['provider'] as String? ?? 'password',
      createdAt: parseDateTime(map['createdAt']),
      updatedAt: parseDateTime(map['updatedAt']),
    );
  }
}

