'use client';

import { useTranslations } from 'next-intl';
import { Badge } from '@/components/ui/badge';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { Button } from '@/components/ui/button';
import { StatusToggle } from './status-toggle';
import { useListings } from '@/application/hooks/use-listings';
import type { Listing } from '@/domain/entities/listing';

export function ListingsTable() {
  const t = useTranslations('listings');
  const tCommon = useTranslations('common');
  const { data, isLoading, fetchNextPage, hasNextPage, isFetchingNextPage } = useListings();

  const listings: Listing[] = data?.pages.flatMap((p) => (p as { listings: Listing[] }).listings) ?? [];

  if (isLoading) {
    return (
      <div className="space-y-2">
        {Array.from({ length: 5 }).map((_, i) => (
          <div key={i} className="h-12 animate-pulse rounded bg-muted" />
        ))}
      </div>
    );
  }

  if (listings.length === 0) {
    return (
      <div className="rounded-lg border bg-card p-12 text-center text-muted-foreground">
        {tCommon('noData')}
      </div>
    );
  }

  return (
    <div className="space-y-4">
      <div className="rounded-lg border">
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead>{t('idColumn')}</TableHead>
              <TableHead>{t('ownerColumn')}</TableHead>
              <TableHead>{t('typeColumn')}</TableHead>
              <TableHead>{t('rentColumn')}</TableHead>
              <TableHead>{t('statusColumn')}</TableHead>
              <TableHead>{t('toggleColumn')}</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {listings.map((listing) => (
              <TableRow key={listing.id}>
                <TableCell className="font-mono text-xs">{listing.id.slice(0, 8)}…</TableCell>
                <TableCell className="font-mono text-xs">{listing.ownerId.slice(0, 8)}…</TableCell>
                <TableCell>{listing.propertyTypeKey}</TableCell>
                <TableCell>
                  {listing.monthlyRent != null ? `${listing.monthlyRent} SAR` : '—'}
                </TableCell>
                <TableCell>
                  <Badge variant={listing.status === 'active' ? 'default' : 'secondary'}>
                    {listing.status === 'active' ? t('active') : t('inactive')}
                  </Badge>
                </TableCell>
                <TableCell>
                  <StatusToggle listingId={listing.id} currentStatus={listing.status} />
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </div>

      {hasNextPage && (
        <div className="flex justify-center">
          <Button
            variant="outline"
            onClick={() => void fetchNextPage()}
            disabled={isFetchingNextPage}
          >
            {isFetchingNextPage ? tCommon('loading') : tCommon('loadMore')}
          </Button>
        </div>
      )}
    </div>
  );
}
