import { setRequestLocale } from 'next-intl/server';
import { SignInPageClient } from './sign-in-client';

export default async function SignInPage({
  params,
}: {
  params: Promise<{ locale: string }>;
}) {
  const { locale } = await params;
  setRequestLocale(locale);
  return (
    <main className="min-h-screen flex items-center justify-center p-4 bg-muted/30">
      <SignInPageClient />
    </main>
  );
}
