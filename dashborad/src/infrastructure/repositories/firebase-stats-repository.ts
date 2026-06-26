import { getDoc, getCountFromServer, query, where } from 'firebase/firestore';
import { statsDoc, usersCol, listingsCol, listingReportsCol } from '../firebase/collections';
import type { StatsRepository } from '@/domain/repositories/stats-repository';
import type { OverviewStats } from '@/domain/entities/stats';

export class FirebaseStatsRepository implements StatsRepository {
  async getOverviewStats(): Promise<OverviewStats> {
    // Try the pre-aggregated doc first; fall back to live counts if missing/all-zero
    const snap = await getDoc(statsDoc);
    const d = snap.exists() ? snap.data() : null;

    const preAgg = d
      ? {
          totalUsers: (d['totalUsers'] as number) ?? 0,
          activeListings: (d['activeListings'] as number) ?? 0,
          pendingReports: (d['pendingReports'] as number) ?? 0,
          totalBookings: (d['totalBookings'] as number) ?? 0,
        }
      : null;

    const allZero =
      !preAgg ||
      (preAgg.totalUsers === 0 &&
        preAgg.activeListings === 0 &&
        preAgg.pendingReports === 0 &&
        preAgg.totalBookings === 0);

    if (!allZero) {
      return { ...preAgg!, updatedAt: d?.['updatedAt']?.toDate?.() as Date | undefined };
    }

    // Live counts via getCountFromServer (efficient — no document reads)
    const [usersSnap, activeListingsSnap, pendingReportsSnap] = await Promise.all([
      getCountFromServer(usersCol),
      getCountFromServer(query(listingsCol, where('status', '==', 'active'))),
      getCountFromServer(query(listingReportsCol, where('status', '==', 'pending'))),
    ]);

    return {
      totalUsers: usersSnap.data().count,
      activeListings: activeListingsSnap.data().count,
      pendingReports: pendingReportsSnap.data().count,
      totalBookings: 0,
    };
  }
}
