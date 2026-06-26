'use client';

import { useTranslations } from 'next-intl';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table';
import { useReports, useMarkReportReviewed } from '@/application/hooks/use-reports';
import type { Report } from '@/domain/entities/report';

export function ReportsTable() {
  const t = useTranslations('reports');
  const tCommon = useTranslations('common');
  const { data, isLoading, fetchNextPage, hasNextPage, isFetchingNextPage } = useReports();
  const { mutate: markReviewed, isPending } = useMarkReportReviewed();

  const reports: Report[] = data?.pages.flatMap((p) => (p as { reports: Report[] }).reports) ?? [];

  if (isLoading) {
    return (
      <div className="space-y-2">
        {Array.from({ length: 5 }).map((_, i) => (
          <div key={i} className="h-12 animate-pulse rounded bg-muted" />
        ))}
      </div>
    );
  }

  if (reports.length === 0) {
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
              <TableHead>{t('listingColumn')}</TableHead>
              <TableHead>{t('reasonColumn')}</TableHead>
              <TableHead>{t('statusColumn')}</TableHead>
              <TableHead>{t('actionsColumn')}</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {reports.map((report) => (
              <TableRow key={report.id}>
                <TableCell className="font-mono text-xs">{report.id.slice(0, 8)}…</TableCell>
                <TableCell className="font-mono text-xs">
                  {report.listingId.slice(0, 8)}…
                </TableCell>
                <TableCell className="max-w-xs truncate">{report.reason}</TableCell>
                <TableCell>
                  <Badge variant={report.status === 'pending' ? 'destructive' : 'secondary'}>
                    {report.status === 'pending' ? t('pending') : t('reviewed')}
                  </Badge>
                </TableCell>
                <TableCell>
                  {report.status === 'pending' && (
                    <Button
                      size="sm"
                      variant="outline"
                      disabled={isPending}
                      onClick={() => markReviewed(report.id)}
                    >
                      {t('markReviewed')}
                    </Button>
                  )}
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
