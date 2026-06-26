import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:makani_app/Core/Config/cloudinary_config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Uploads files to Cloudinary (unsigned preset).
class CloudinaryUploadService {
  CloudinaryUploadService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.connectTimeout = const Duration(seconds: 45);
    _dio.options.sendTimeout = const Duration(minutes: 4);
    _dio.options.receiveTimeout = const Duration(minutes: 4);
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: false,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 120,
        ),
      );
    }
  }

  final Dio _dio;

  bool get isConfigured => CloudinaryConfig.isConfigured;

  Future<String> uploadImage(String filePath) async {
    final form = FormData.fromMap({
      'upload_preset': CloudinaryConfig.uploadPreset,
      'file': await MultipartFile.fromFile(filePath),
    });
    final res = await _dio.post<Map<String, dynamic>>(
      CloudinaryConfig.imageUploadUrl,
      data: form,
    );
    final url = res.data?['secure_url'] as String?;
    if (url == null || url.isEmpty) {
      throw StateError('Cloudinary image upload: missing secure_url');
    }
    return url;
  }

  Future<String> uploadVideo(String filePath) async {
    final form = FormData.fromMap({
      'upload_preset': CloudinaryConfig.uploadPreset,
      'file': await MultipartFile.fromFile(filePath),
    });
    final res = await _dio.post<Map<String, dynamic>>(
      CloudinaryConfig.videoUploadUrl,
      data: form,
    );
    final url = res.data?['secure_url'] as String?;
    if (url == null || url.isEmpty) {
      throw StateError('Cloudinary video upload: missing secure_url');
    }
    return url;
  }
}
