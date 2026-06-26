import type { Report } from '../entities/report';

export interface ReportPage {
  reports: Report[];
  nextCursor: unknown | null;
}

export interface ReportRepository {
  getPaginated(cursor: unknown | null, pageSize: number): Promise<ReportPage>;
  markReviewed(reportId: string): Promise<void>;
}
