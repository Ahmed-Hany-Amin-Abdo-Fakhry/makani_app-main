'use client';

import { useQuery } from '@tanstack/react-query';
import { getCountFromServer, query, where } from 'firebase/firestore';
import { listingsCol, listingReportsCol } from '@/infrastructure/firebase/collections';

export function useAnalytics() {
  return useQuery({
    queryKey: ['analytics'],
    queryFn: async () => {
      const [active, inactive, pending, reviewed] = await Promise.all([
        getCountFromServer(query(listingsCol, where('status', '==', 'active'))),
        getCountFromServer(query(listingsCol, where('status', '==', 'inactive'))),
        getCountFromServer(query(listingReportsCol, where('status', '==', 'pending'))),
        getCountFromServer(query(listingReportsCol, where('status', '==', 'reviewed'))),
      ]);
      return {
        listings: [
          { name: 'active', value: active.data().count },
          { name: 'inactive', value: inactive.data().count },
        ],
        reports: [
          { name: 'pending', value: pending.data().count },
          { name: 'reviewed', value: reviewed.data().count },
        ],
      };
    },
    staleTime: 60 * 1000,
  });
}
