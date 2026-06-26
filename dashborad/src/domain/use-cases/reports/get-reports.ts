import type { ReportRepository, ReportPage } from '../../repositories/report-repository';

export async function getReports(
  repo: ReportRepository,
  cursor: unknown | null,
  pageSize: number
): Promise<ReportPage> {
  return repo.getPaginated(cursor, pageSize);
}
