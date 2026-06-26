'use client';

import { useInfiniteQuery, useMutation, useQueryClient, type InfiniteData } from '@tanstack/react-query';
import { useDI } from '../providers/di-provider';
import type { ListingPage } from '@/domain/repositories/listing-repository';
import type { ListingStatus } from '@/domain/entities/listing';

export function useListings(pageSize = 20) {
  const { listingRepo } = useDI();

  return useInfiniteQuery<ListingPage, Error, InfiniteData<ListingPage>, string[], null>({
    queryKey: ['listings'],
    queryFn: ({ pageParam }) => listingRepo.getPaginated(pageParam, pageSize),
    getNextPageParam: (lastPage) => lastPage.nextCursor as null | undefined,
    initialPageParam: null,
  });
}

export function useUpdateListingStatus() {
  const { listingRepo } = useDI();
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, status }: { id: string; status: ListingStatus }) =>
      listingRepo.updateStatus(id, status),
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: ['listings'] });
      void queryClient.invalidateQueries({ queryKey: ['stats', 'overview'] });
    },
  });
}
