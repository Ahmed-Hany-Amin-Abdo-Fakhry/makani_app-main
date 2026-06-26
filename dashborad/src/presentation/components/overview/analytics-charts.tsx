'use client';

import { useTranslations } from 'next-intl';
import {
  PieChart, Pie, Cell, ResponsiveContainer,
  BarChart, Bar, XAxis, YAxis, Tooltip, CartesianGrid,
} from 'recharts';
import { useAnalytics } from '@/application/hooks/use-analytics';

const COLORS = {
  active:   '#5B6CF2',
  inactive: '#E5E7EB',
  pending:  '#F59E0B',
  reviewed: '#22C55E',
};

function ChartCard({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <div className="rounded-xl border bg-card p-5 shadow-sm">
      <p className="mb-4 text-sm font-semibold text-foreground">{title}</p>
      {children}
    </div>
  );
}

function DonutChart({
  data,
  labels,
}: {
  data: { name: string; value: number }[];
  labels: Record<string, string>;
}) {
  const total = data.reduce((s, d) => s + d.value, 0);

  return (
    <div className="flex items-center gap-6">
      <div className="relative h-32 w-32 shrink-0">
        <ResponsiveContainer width="100%" height="100%">
          <PieChart>
            <Pie
              data={total === 0 ? [{ name: 'empty', value: 1 }] : data}
              cx="50%"
              cy="50%"
              innerRadius={38}
              outerRadius={56}
              dataKey="value"
              strokeWidth={2}
              stroke="#fff"
            >
              {total === 0
                ? <Cell fill="#E5E7EB" />
                : data.map((entry) => (
                    <Cell key={entry.name} fill={COLORS[entry.name as keyof typeof COLORS] ?? '#9EA2AE'} />
                  ))
              }
            </Pie>
          </PieChart>
        </ResponsiveContainer>
        <div className="absolute inset-0 flex flex-col items-center justify-center">
          <span className="text-xl font-bold text-foreground">{total}</span>
          <span className="text-[10px] text-muted-foreground">total</span>
        </div>
      </div>

      <div className="flex flex-col gap-2">
        {data.map((entry) => (
          <div key={entry.name} className="flex items-center gap-2">
            <span
              className="h-2.5 w-2.5 rounded-full shrink-0"
              style={{ backgroundColor: COLORS[entry.name as keyof typeof COLORS] ?? '#9EA2AE' }}
            />
            <span className="text-xs text-muted-foreground">{labels[entry.name]}</span>
            <span className="ms-auto text-xs font-semibold text-foreground">{entry.value}</span>
          </div>
        ))}
      </div>
    </div>
  );
}

export function AnalyticsCharts() {
  const t = useTranslations('listings');
  const tR = useTranslations('reports');
  const tO = useTranslations('overview');
  const { data, isLoading } = useAnalytics();

  if (isLoading) {
    return (
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {Array.from({ length: 3 }).map((_, i) => (
          <div key={i} className="h-44 animate-pulse rounded-xl bg-muted" />
        ))}
      </div>
    );
  }

  const listingBarData = [
    { label: t('active'),   value: data?.listings.find(d => d.name === 'active')?.value ?? 0 },
    { label: t('inactive'), value: data?.listings.find(d => d.name === 'inactive')?.value ?? 0 },
  ];

  return (
    <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
      {/* Listings donut */}
      <ChartCard title={tO('activeListings')}>
        <DonutChart
          data={data?.listings ?? []}
          labels={{ active: t('active'), inactive: t('inactive') }}
        />
      </ChartCard>

      {/* Reports donut */}
      <ChartCard title={tO('pendingReports')}>
        <DonutChart
          data={data?.reports ?? []}
          labels={{ pending: tR('pending'), reviewed: tR('reviewed') }}
        />
      </ChartCard>

      {/* Listings bar */}
      <ChartCard title={tO('listingsBreakdown')}>
        <ResponsiveContainer width="100%" height={112}>
          <BarChart data={listingBarData} barSize={32}>
            <CartesianGrid strokeDasharray="3 3" stroke="#E5E7EB" vertical={false} />
            <XAxis dataKey="label" tick={{ fontSize: 11, fill: '#6B7280' }} axisLine={false} tickLine={false} />
            <YAxis hide allowDecimals={false} />
            <Tooltip
              cursor={{ fill: '#EEF0FD' }}
              contentStyle={{ borderRadius: 8, border: '1px solid #E5E7EB', fontSize: 12 }}
            />
            <Bar dataKey="value" radius={[4, 4, 0, 0]}>
              <Cell fill="#5B6CF2" />
              <Cell fill="#E5E7EB" />
            </Bar>
          </BarChart>
        </ResponsiveContainer>
      </ChartCard>
    </div>
  );
}
