import 'package:makani_app/Features/AddAd/Model/add_ad_draft.dart';

abstract class AddPropertyRepository {
  /// Compress media, upload to Cloudinary, write Firestore doc.
  /// [onProgress] in inclusive range 0.0–1.0.
  Future<void> publishListing(
    AddAdDraft draft, {
    void Function(double progress)? onProgress,
  });

  /// Updates an existing listing by reusing unchanged media URLs and uploading only
  /// newly selected local files.
  Future<void> updateListing({
    required String listingId,
    required AddAdDraft draft,
    void Function(double progress)? onProgress,
  });
}
