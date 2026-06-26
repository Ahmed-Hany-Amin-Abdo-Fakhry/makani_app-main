import { NextIntlClientProvider } from 'next-intl';
import { getMessages, setRequestLocale } from 'next-intl/server';
import { notFound } from 'next/navigation';
import { routing, type Locale } from '@/i18n/routing';
import { localeDirection } from '@/i18n/config';
import { Toaster } from 'sonner';
import { QueryProvider } from '@/application/providers/query-provider';
import { DIProvider } from '@/application/providers/di-provider';
import { AuthProvider } from '@/application/providers/auth-provider';

export function generateStaticParams() {
  return routing.locales.map((locale) => ({ locale }));
}

export default async function LocaleLayout({
  children,
  params,
}: {
  children: React.ReactNode;
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;

  if (!routing.locales.includes(locale as Locale)) {
    notFound();
  }

  setRequestLocale(locale);

  const messages = await getMessages();
  const dir = localeDirection[locale as Locale];

  return (
    <html lang={locale} dir={dir}>
      <body>
        <NextIntlClientProvider messages={messages}>
          <QueryProvider>
            <DIProvider>
              <AuthProvider>
                {children}
                <Toaster richColors position="bottom-center" dir={dir} />
              </AuthProvider>
            </DIProvider>
          </QueryProvider>
        </NextIntlClientProvider>
      </body>
    </html>
  );
}
