import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Owner/admin-only verification metadata at `listings/{id}/private/verification`.
class ListingVerificationData extends Equatable {
  const ListingVerificationData({
    this.contractImageUrl,
    this.nationalIdFrontUrl,
    this.nationalIdBackUrl,
  });

  final String? contractImageUrl;
  final String? nationalIdFrontUrl;
  final String? nationalIdBackUrl;

  @override
  List<Object?> get props => [
        contractImageUrl,
        nationalIdFrontUrl,
        nationalIdBackUrl,
      ];
}

abstract class ListingVerificationStore {
  Future<void> setVerificationData({
    required String listingId,
    required String contractImageUrl,
    required String nationalIdFrontUrl,
    required String nationalIdBackUrl,
  });

  Future<ListingVerificationData?> getVerificationData(String listingId);
}

class ListingVerificationFirestoreService implements ListingVerificationStore {
  ListingVerificationFirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  static const String verificationDocPath = 'private/verification';

  DocumentReference<Map<String, dynamic>> _verificationRef(String listingId) {
    return _db
        .collection('listings')
        .doc(listingId)
        .collection('private')
        .doc('verification');
  }

  static String? _readUrl(Map<String, dynamic>? data, String key) {
    if (data == null) return null;
    final url = data[key] as String?;
    if (url == null || url.isEmpty) return null;
    return url;
  }

  @override
  Future<void> setVerificationData({
    required String listingId,
    required String contractImageUrl,
    required String nationalIdFrontUrl,
    required String nationalIdBackUrl,
  }) async {
    if (listingId.isEmpty) return;
    await _verificationRef(listingId).set({
      if (contractImageUrl.isNotEmpty) 'contractImageUrl': contractImageUrl,
      if (nationalIdFrontUrl.isNotEmpty)
        'nationalIdFrontUrl': nationalIdFrontUrl,
      if (nationalIdBackUrl.isNotEmpty) 'nationalIdBackUrl': nationalIdBackUrl,
      'uploadedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<ListingVerificationData?> getVerificationData(
    String listingId,
  ) async {
    if (listingId.isEmpty) return null;
    final snap = await _verificationRef(listingId).get();
    if (!snap.exists) return null;
    final data = snap.data();
    final contract = _readUrl(data, 'contractImageUrl');
    final front = _readUrl(data, 'nationalIdFrontUrl');
    final back = _readUrl(data, 'nationalIdBackUrl');
    if (contract == null && front == null && back == null) return null;
    return ListingVerificationData(
      contractImageUrl: contract,
      nationalIdFrontUrl: front,
      nationalIdBackUrl: back,
    );
  }
}
