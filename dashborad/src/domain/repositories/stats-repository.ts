import type { OverviewStats } from '../entities/stats';

export interface StatsRepository {
  getOverviewStats(): Promise<OverviewStats>;
}
