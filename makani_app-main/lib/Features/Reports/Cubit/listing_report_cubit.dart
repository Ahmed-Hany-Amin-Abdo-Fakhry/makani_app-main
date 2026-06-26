import 'package:bloc/bloc.dart';
import 'package:makani_app/Features/Reports/Cubit/listing_report_state.dart';
import 'package:makani_app/Features/Reports/Repositories/listing_report_repository.dart';
import 'package:makani_app/Features/Reports/Services/listing_report_firestore_service.dart';

class ListingReportCubit extends Cubit<ListingReportState> {
  ListingReportCubit(this._repository) : super(const ListingReportInitial());

  final ListingReportRepository _repository;

  Future<ListingReportSubmitStatus> submitListingReport({
    required String listingId,
    required String reporterUid,
    required String ownerId,
    required String reason,
  }) async {
    emit(const ListingReportSubmitting());
    try {
      final status = await _repository.submitListingReport(
        listingId: listingId,
        reporterUid: reporterUid,
        ownerId: ownerId,
        reason: reason,
      );
      switch (status) {
        case ListingReportSubmitStatus.submitted:
          emit(const ListingReportSubmitted());
        case ListingReportSubmitStatus.alreadyReported:
          emit(const ListingReportAlreadyReported());
        case ListingReportSubmitStatus.invalidInput:
          emit(const ListingReportInvalidInput());
      }
      return status;
    } catch (e) {
      emit(ListingReportFailure(e.toString()));
      rethrow;
    }
  }
}
