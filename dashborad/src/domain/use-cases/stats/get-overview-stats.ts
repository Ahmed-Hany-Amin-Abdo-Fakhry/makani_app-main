import type { StatsRepository } from '../../repositories/stats-repository';
import type { OverviewStats } from '../../entities/stats';

export async function getOverviewStats(repo: StatsRepository): Promise<OverviewStats> {
  return repo.getOverviewStats();
}
