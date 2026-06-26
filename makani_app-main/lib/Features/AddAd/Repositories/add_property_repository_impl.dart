import 'package:firebase_auth/firebase_auth.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_draft.dart';
import 'package:makani_app/Features/AddAd/Model/property_listing_firestore_dto.dart';
import 'package:makani_app/Features/AddAd/Repositories/add_property_repository.dart';
import 'package:makani_app/Features/AddAd/Services/cloudinary_upload_service.dart';
import 'package:makani_app/Features/AddAd/Services/listing_verification_firestore_service.dart';
import 'package:makani_app/Features/AddAd/Services/media_compression_service.dart';
import 'package:makani_app/Features/AddAd/Services/property_listing_firestore_service.dart';

class AddPropertyRepositoryImpl implements AddPropertyRepository {
  AddPropertyRepositoryImpl({
    required MediaCompressionService compressionService,
    required CloudinaryUploadService cloudinaryService,
    required PropertyListingFirestoreService listingFirestoreService,
    ListingVerificationStore? verificationStore,
    FirebaseAuth? auth,
  })  : _compression = compressionService,
        _cloudinary = cloudinaryService,
        _firestore = listingFirestoreService,
        _verification = verificationStore ?? ListingVerificationFirestoreService(),
        _auth = auth ?? FirebaseAuth.instance;

  final MediaCompressionService _compression;
  final CloudinaryUploadService _cloudinary;
  final PropertyListingFirestoreService _firestore;
  final ListingVerificationStore _verification;
  final FirebaseAuth _auth;

  bool _isRemoteUrl(String path) {
    final uri = Uri.tryParse(path);
    if (uri == null) return false;
    return uri.scheme == 'http' || uri.scheme == 'https';
  }

  Future<String> _uploadImagePath(String path) async {
    if (_isRemoteUrl(path)) return path;
    final compressed = await _compression.compressImageFile(path);
    try {
      return await _cloudinary.uploadImage(compressed.path);
    } finally {
      if (compressed.path != path) {
        try {
          await compressed.delete();
        } catch (_) {}
      }
    }
  }

  String _requireContractPath(AddAdDraft draft) {
    final path = draft.contractImagePath?.trim() ?? '';
    if (path.isEmpty) {
      throw StateError('Contract image is required.');
    }
    return path;
  }

  (String front, String back) _requireNationalIdPaths(AddAdDraft draft) {
    final front = draft.nationalIdFrontPath?.trim() ?? '';
    final back = draft.nationalIdBackPath?.trim() ?? '';
    if (front.isEmpty || back.isEmpty) {
      throw StateError('National ID front and back images are required.');
    }
    return (front, back);
  }

  @override
  Future<void> publishListing(
    AddAdDraft draft, {
    void Function(double progress)? onProgress,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('You must be signed in to publish a listing.');
    }
    if (!_cloudinary.isConfigured) {
      throw StateError(
        'Cloudinary is not configured. Build with '
        '--dart-define=CLOUDINARY_CLOUD_NAME=... '
        '--dart-define=CLOUDINARY_UPLOAD_PRESET=...',
      );
    }

    void report(double p) => onProgress?.call(p.clamp(0, 1));

    final contractPath = _requireContractPath(draft);
    final (idFrontPath, idBackPath) = _requireNationalIdPaths(draft);
    final photoPaths = draft.photoSlots.where((e) => e.isNotEmpty).toList();
    final hasVideo =
        draft.videoPath != null && draft.videoPath!.trim().isNotEmpty;
    final totalUnits = photoPaths.length + (hasVideo ? 1 : 0) + 4;

    var done = 0;
    void bump() {
      done++;
      report(done / totalUnits);
    }

    report(0);
    final contractImageUrl = await _uploadImagePath(contractPath);
    bump();

    final nationalIdFrontUrl = await _uploadImagePath(idFrontPath);
    bump();

    final nationalIdBackUrl = await _uploadImagePath(idBackPath);
    bump();

    final imageUrls = <String>[];
    for (final path in photoPaths) {
      imageUrls.add(await _uploadImagePath(path));
      bump();
    }

    String? videoUrl;
    if (hasVideo) {
      final vp = draft.videoPath!;
      final compressed = await _compression.compressVideoFile(vp);
      try {
        videoUrl = await _cloudinary.uploadVideo(compressed.path);
      } finally {
        if (compressed.path != vp) {
          try {
            await compressed.delete();
          } catch (_) {}
        }
      }
      bump();
    }

    final data = PropertyListingFirestoreDto.toCreateMap(
      draft: draft,
      ownerUid: user.uid,
      ownerPhone: draft.ownerPhone,
      imageUrls: imageUrls,
      videoUrl: videoUrl,
    );

    final listingId = await _firestore.createListing(data);
    await _verification.setVerificationData(
      listingId: listingId,
      contractImageUrl: contractImageUrl,
      nationalIdFrontUrl: nationalIdFrontUrl,
      nationalIdBackUrl: nationalIdBackUrl,
    );
    bump();
  }

  @override
  Future<void> updateListing({
    required String listingId,
    required AddAdDraft draft,
    void Function(double progress)? onProgress,
  }) async {
    if (listingId.trim().isEmpty) {
      throw StateError('Listing ID is required for update.');
    }
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('You must be signed in to update a listing.');
    }
    if (!_cloudinary.isConfigured) {
      throw StateError(
        'Cloudinary is not configured. Build with '
        '--dart-define=CLOUDINARY_CLOUD_NAME=... '
        '--dart-define=CLOUDINARY_UPLOAD_PRESET=...',
      );
    }

    final contractPath = _requireContractPath(draft);
    final (idFrontPath, idBackPath) = _requireNationalIdPaths(draft);
    final rawPhotos = draft.photoSlots.where((e) => e.isNotEmpty).toList();
    final localPhotos = rawPhotos.where((e) => !_isRemoteUrl(e)).toList();
    final rawVideo = draft.videoPath?.trim();
    final hasVideo = rawVideo != null && rawVideo.isNotEmpty;
    final needsVideoUpload = hasVideo && !_isRemoteUrl(rawVideo);
    final needsContractUpload = !_isRemoteUrl(contractPath);
    final needsIdFrontUpload = !_isRemoteUrl(idFrontPath);
    final needsIdBackUpload = !_isRemoteUrl(idBackPath);

    final totalUnits = localPhotos.length +
        (needsVideoUpload ? 1 : 0) +
        (needsContractUpload ? 1 : 0) +
        (needsIdFrontUpload ? 1 : 0) +
        (needsIdBackUpload ? 1 : 0) +
        1;
    var done = 0;
    void report(double p) => onProgress?.call(p.clamp(0, 1));
    void bump() {
      done++;
      report(done / totalUnits);
    }

    report(0);

    final contractImageUrl = needsContractUpload
        ? await _uploadImagePath(contractPath)
        : contractPath;

    if (needsContractUpload) bump();

    final nationalIdFrontUrl = needsIdFrontUpload
        ? await _uploadImagePath(idFrontPath)
        : idFrontPath;

    if (needsIdFrontUpload) bump();

    final nationalIdBackUrl = needsIdBackUpload
        ? await _uploadImagePath(idBackPath)
        : idBackPath;

    if (needsIdBackUpload) bump();

    final imageUrls = <String>[];
    for (final path in rawPhotos) {
      if (_isRemoteUrl(path)) {
        imageUrls.add(path);
        continue;
      }
      imageUrls.add(await _uploadImagePath(path));
      bump();
    }

    String? videoUrl = rawVideo;
    if (needsVideoUpload) {
      final compressed = await _compression.compressVideoFile(rawVideo);
      try {
        videoUrl = await _cloudinary.uploadVideo(compressed.path);
      } finally {
        if (compressed.path != rawVideo) {
          try {
            await compressed.delete();
          } catch (_) {}
        }
      }
      bump();
    }

    final data = PropertyListingFirestoreDto.toUpdateMap(
      draft: draft,
      ownerPhone: draft.ownerPhone,
      imageUrls: imageUrls,
      videoUrl: hasVideo ? videoUrl : null,
    );
    await _firestore.updateListing(listingId, data);
    await _verification.setVerificationData(
      listingId: listingId,
      contractImageUrl: contractImageUrl,
      nationalIdFrontUrl: nationalIdFrontUrl,
      nationalIdBackUrl: nationalIdBackUrl,
    );
    bump();
  }
}
