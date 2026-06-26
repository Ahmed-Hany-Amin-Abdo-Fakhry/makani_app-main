import { setRequestLocale, getTranslations } from 'next-intl/server';
import { ReportsTable } from '@/presentation/components/reports/reports-table';

export default async function ReportsPage({
  params,
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations('reports');

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-semibold">{t('title')}</h1>
      <ReportsTable />
    </div>
  );
}
