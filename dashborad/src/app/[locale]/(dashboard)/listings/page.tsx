import { setRequestLocale, getTranslations } from 'next-intl/server';
import { ListingsTable } from '@/presentation/components/listings/listings-table';

export default async function ListingsPage({
  params,
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  setRequestLocale(locale);
  const t = await getTranslations('listings');

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-semibold">{t('title')}</h1>
      <ListingsTable />
    </div>
  );
}
