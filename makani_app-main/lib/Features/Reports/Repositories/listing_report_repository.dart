import 'package:makani_app/Features/Reports/Services/listing_report_firestore_service.dart';

abstract class ListingReportRepository {
  Future<ListingReportSubmitStatus> submitListingReport({
    required String listingId,
    required String reporterUid,
    required String ownerId,
    required String reason,
  });
}
