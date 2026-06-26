sealed class ListingReportState {
  const ListingReportState();
}

final class ListingReportInitial extends ListingReportState {
  const ListingReportInitial();
}

final class ListingReportSubmitting extends ListingReportState {
  const ListingReportSubmitting();
}

final class ListingReportSubmitted extends ListingReportState {
  const ListingReportSubmitted();
}

final class ListingReportAlreadyReported extends ListingReportState {
  const ListingReportAlreadyReported();
}

final class ListingReportInvalidInput extends ListingReportState {
  const ListingReportInvalidInput();
}

final class ListingReportFailure extends ListingReportState {
  const ListingReportFailure(this.message);

  final String message;
}
