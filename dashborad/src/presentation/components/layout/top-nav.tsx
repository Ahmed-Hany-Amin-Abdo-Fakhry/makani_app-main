'use client';

import Image from 'next/image';
import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { useTranslations, useLocale } from 'next-intl';
import { Button } from '@/components/ui/button';
import { useAuth } from '@/application/hooks/use-auth';

export function TopNav() {
  const t = useTranslations('nav');
  const locale = useLocale();
  const pathname = usePathname();
  const router = useRouter();
  const { user, signOut } = useAuth();

  const navItems = [
    { href: `/${locale}/overview`, label: t('overview') },
    { href: `/${locale}/listings`, label: t('listings') },
    { href: `/${locale}/reports`, label: t('reports') },
    { href: `/${locale}/teams`, label: t('teams') },
  ];

  function switchLocale() {
    const next = locale === 'en' ? 'ar' : 'en';
    const withoutLocale = pathname.replace(`/${locale}`, '');
    router.push(`/${next}${withoutLocale}`);
    if (typeof window !== 'undefined') {
      localStorage.setItem('makani-dashboard-locale', next);
    }
  }

  return (
    <header className="sticky top-0 z-50 border-b bg-background/95 backdrop-blur">
      <div className="flex h-14 items-center gap-4 px-4">
        <Link href={`/${locale}/overview`} className="flex items-center gap-2 me-4 shrink-0">
          <Image src="/logo.png" alt="Makani" width={28} height={28} className="rounded-lg" />
          <span className="font-semibold text-primary hidden sm:block">Makani Admin</span>
        </Link>

        <nav className="flex items-center gap-1 flex-1">
          {navItems.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className={`rounded-md px-3 py-1.5 text-sm transition-colors hover:bg-muted ${
                pathname.startsWith(item.href)
                  ? 'bg-muted font-medium text-foreground'
                  : 'text-muted-foreground'
              }`}
            >
              {item.label}
            </Link>
          ))}
        </nav>

        <div className="flex items-center gap-2">
          <Button variant="ghost" size="sm" onClick={switchLocale}>
            {locale === 'en' ? 'عربي' : 'EN'}
          </Button>
          {user && (
            <Button variant="ghost" size="sm" onClick={signOut}>
              {t('signOut')}
            </Button>
          )}
        </div>
      </div>
    </header>
  );
}
