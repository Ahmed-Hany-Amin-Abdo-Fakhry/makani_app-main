import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

/// Local image/video compression before upload.
class MediaCompressionService {
  MediaCompressionService({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  /// Returns a JPEG file (may be original if compression fails).
  Future<File> compressImageFile(String sourcePath) async {
    final target = p.join(
      Directory.systemTemp.path,
      'listing_img_${_uuid.v4()}.jpg',
    );
    final result = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      target,
      quality: 82,
      minWidth: 1600,
      minHeight: 1600,
      keepExif: false,
    );
    if (result == null) return File(sourcePath);
    return File(result.path);
  }

  /// Returns a compressed video file (may be original if compression fails).
  Future<File> compressVideoFile(String sourcePath) async {
    final info = await VideoCompress.compressVideo(
      sourcePath,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    );
    final f = info?.file;
    if (f == null) return File(sourcePath);
    return f;
  }
}
