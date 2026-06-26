import 'package:cloud_firestore/cloud_firestore.dart';

enum ListingReportSubmitStatus {
  submitted,
  alreadyReported,
  invalidInput,
}

class ListingReportFirestoreService {
  ListingReportFirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  static const reportsCollectionPath = 'listingReports';

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _reports =>
      _db.collection(reportsCollectionPath);

  DocumentReference<Map<String, dynamic>> _reportGuardDoc(
    String uid,
    String listingId,
  ) =>
      _db.collection('users').doc(uid).collection('reportedListings').doc(
            listingId,
          );

  Future<ListingReportSubmitStatus> submitListingReport({
    required String listingId,
    required String reporterUid,
    required String ownerId,
    required String reason,
  }) async {
    if (listingId.isEmpty ||
        reporterUid.isEmpty ||
        ownerId.isEmpty ||
        reason.isEmpty) {
      return ListingReportSubmitStatus.invalidInput;
    }

    final guardRef = _reportGuardDoc(reporterUid, listingId);
    final reportRef = _reports.doc();

    return _db.runTransaction((txn) async {
      final guardSnap = await txn.get(guardRef);
      if (guardSnap.exists) {
        return ListingReportSubmitStatus.alreadyReported;
      }

      txn.set(guardRef, {
        'listingId': listingId,
        'reason': reason,
        'createdAt': FieldValue.serverTimestamp(),
      });

      txn.set(reportRef, {
        'listingId': listingId,
        'reporterUid': reporterUid,
        'ownerId': ownerId,
        'reason': reason,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return ListingReportSubmitStatus.submitted;
    });
  }
}
