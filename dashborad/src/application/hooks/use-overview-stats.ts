'use client';

import { useQuery } from '@tanstack/react-query';
import { useDI } from '../providers/di-provider';

export function useOverviewStats() {
  const { statsRepo } = useDI();
  return useQuery({
    queryKey: ['stats', 'overview'],
    queryFn: () => statsRepo.getOverviewStats(),
  });
}
