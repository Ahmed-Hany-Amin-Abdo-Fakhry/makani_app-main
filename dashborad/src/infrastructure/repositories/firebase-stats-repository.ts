import { getDoc } from 'firebase/firestore';
import { statsDoc } from '../firebase/collections';
import type { StatsRepository } from '@/domain/repositories/stats-repository';
import type { OverviewStats } from '@/domain/entities/stats';

export class FirebaseStatsRepository implements StatsRepository {
  async getOverviewStats(): Promise<OverviewStats> {
    const snap = await getDoc(statsDoc);
    if (!snap.exists()) {
      return { totalUsers: 0, activeListings: 0, pendingReports: 0, totalBookings: 0 };
    }
    const d = snap.data();
    return {
      totalUsers: (d['totalUsers'] as number) ?? 0,
      activeListings: (d['activeListings'] as number) ?? 0,
      pendingReports: (d['pendingReports'] as number) ?? 0,
      totalBookings: (d['totalBookings'] as number) ?? 0,
      updatedAt: d['updatedAt']?.toDate?.() as Date | undefined,
    };
  }
}
