'use client';

import { useTranslations } from 'next-intl';
import { StatCard } from './stat-card';
import { useOverviewStats } from '@/application/hooks/use-overview-stats';

export function StatsGrid() {
  const t = useTranslations('overview');
  const { data: stats, isLoading } = useOverviewStats();

  const cards = [
    { key: 'totalUsers', label: t('totalUsers'), value: stats?.totalUsers ?? 0 },
    { key: 'activeListings', label: t('activeListings'), value: stats?.activeListings ?? 0 },
    { key: 'pendingReports', label: t('pendingReports'), value: stats?.pendingReports ?? 0 },
    { key: 'totalBookings', label: t('totalBookings'), value: stats?.totalBookings ?? 0 },
  ];

  return (
    <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
      {cards.map((card) => (
        <StatCard key={card.key} label={card.label} value={card.value} loading={isLoading} />
      ))}
    </div>
  );
}
