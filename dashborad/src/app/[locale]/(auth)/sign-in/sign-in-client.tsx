'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useLocale } from 'next-intl';
import { useAuth } from '@/application/hooks/use-auth';
import { SignInForm } from '@/presentation/components/auth/sign-in-form';

export function SignInPageClient() {
  const { user, loading, signInEmail, signInGoogle, isSigningIn, error } = useAuth();
  const router = useRouter();
  const locale = useLocale();

  useEffect(() => {
    if (!loading && user) {
      router.replace(`/${locale}/overview`);
    }
  }, [user, loading, router, locale]);

  if (loading || user) return null;

  return (
    <SignInForm
      onEmailSignIn={signInEmail}
      onGoogleSignIn={signInGoogle}
      isLoading={isSigningIn}
      error={error}
    />
  );
}
