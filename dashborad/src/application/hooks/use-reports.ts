'use client';

import { useInfiniteQuery, useMutation, useQueryClient, type InfiniteData } from '@tanstack/react-query';
import { useDI } from '../providers/di-provider';
import type { ReportPage } from '@/domain/repositories/report-repository';

export function useReports(pageSize = 20) {
  const { reportRepo } = useDI();

  return useInfiniteQuery<ReportPage, Error, InfiniteData<ReportPage>, string[], null>({
    queryKey: ['reports'],
    queryFn: ({ pageParam }) => reportRepo.getPaginated(pageParam, pageSize),
    getNextPageParam: (lastPage) => lastPage.nextCursor as null | undefined,
    initialPageParam: null,
  });
}

export function useMarkReportReviewed() {
  const { reportRepo } = useDI();
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (reportId: string) => reportRepo.markReviewed(reportId),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ['reports'] });
      void queryClient.invalidateQueries({ queryKey: ['stats', 'overview'] });
    },
  });
}
