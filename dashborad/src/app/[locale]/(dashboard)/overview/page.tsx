import { setRequestLocale } from 'next-intl/server';
import { getTranslations } from 'next-intl/server';
import { StatsGrid } from '@/presentation/components/overview/stats-grid';

export default async function OverviewPage({
  params,
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations('overview');

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-semibold">{t('title')}</h1>
      <StatsGrid />
    </div>
  );
}
