import type { ReportRepository } from '../../repositories/report-repository';

export async function markReportReviewed(
  repo: ReportRepository,
  reportId: string
): Promise<void> {
  return repo.markReviewed(reportId);
}
