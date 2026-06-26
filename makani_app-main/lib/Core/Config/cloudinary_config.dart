/// Cloudinary unsigned uploads via preset.
///
/// Pass at build time, for example:
/// `flutter run --dart-define=CLOUDINARY_CLOUD_NAME=xxx --dart-define=CLOUDINARY_UPLOAD_PRESET=yyy`
abstract final class CloudinaryConfig {
  static const String cloudName = String.fromEnvironment(
    'CLOUDINARY_CLOUD_NAME',
    defaultValue: 'dvgxwf9pr',
  );

  static const String uploadPreset = String.fromEnvironment(
    'CLOUDINARY_UPLOAD_PRESET',
    defaultValue: 'makani',
  );

  static bool get isConfigured =>
      cloudName.isNotEmpty && uploadPreset.isNotEmpty;

  static String get imageUploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  static String get videoUploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudName/video/upload';
}
