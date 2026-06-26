import 'package:makani_app/Features/Reports/Repositories/listing_report_repository.dart';
import 'package:makani_app/Features/Reports/Services/listing_report_firestore_service.dart';

class ListingReportRepositoryImpl implements ListingReportRepository {
  ListingReportRepositoryImpl(this._service);

  final ListingReportFirestoreService _service;

  @override
  Future<ListingReportSubmitStatus> submitListingReport({
    required String listingId,
    required String reporterUid,
    required String ownerId,
    required String reason,
  }) {
    return _service.submitListingReport(
      listingId: listingId,
      reporterUid: reporterUid,
      ownerId: ownerId,
      reason: reason,
    );
  }
}
