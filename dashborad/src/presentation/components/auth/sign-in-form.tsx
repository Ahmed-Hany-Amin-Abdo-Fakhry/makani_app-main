'use client';

import { useState } from 'react';
import Image from 'next/image';
import { X, Eye, EyeOff } from 'lucide-react';
import { useTranslations } from 'next-intl';
import { Button } from '@/components/ui/button';

interface SignInFormProps {
  onEmailSignIn: (email: string, password: string) => Promise<void>;
  onGoogleSignIn: () => Promise<void>;
  isLoading: boolean;
  error: string | null;
}


export function SignInForm({ onEmailSignIn, onGoogleSignIn, isLoading, error }: SignInFormProps) {
  const t = useTranslations('auth');
  const tCommon = useTranslations('common');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [errorDismissed, setErrorDismissed] = useState(false);

  const errorMessage =
    !errorDismissed && error
      ? error === 'access_denied'
        ? t('accessDenied')
        : tCommon('error')
      : null;

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setErrorDismissed(false);
    await onEmailSignIn(email, password);
  }

  return (
    <div className="w-full max-w-sm mx-auto space-y-6">
      {/* Logo + title */}
      <div className="flex flex-col items-center gap-3">
        <Image
          src="/logo.png"
          alt="Makani"
          width={64}
          height={64}
          className="rounded-2xl shadow-sm"
          priority
        />
        <div className="text-center">
          <h1 className="text-2xl font-semibold tracking-tight">Makani Admin</h1>
          <p className="text-sm text-muted-foreground mt-0.5">{t('signIn')}</p>
        </div>
      </div>

      {/* Error banner */}
      {errorMessage && (
        <div className="flex items-start gap-2 rounded-md bg-destructive/10 border border-destructive/20 px-4 py-3 text-sm text-destructive">
          <span className="flex-1">{errorMessage}</span>
          <button
            type="button"
            onClick={() => setErrorDismissed(true)}
            className="mt-0.5 shrink-0 opacity-70 hover:opacity-100"
            aria-label="Dismiss error"
          >
            <X className="h-4 w-4" />
          </button>
        </div>
      )}

      {/* Email / password form */}
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="space-y-2">
          <label htmlFor="email" className="text-sm font-medium">
            {t('emailLabel')}
          </label>
          <input
            id="email"
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
            disabled={isLoading}
            className="w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring disabled:opacity-50"
          />
        </div>

        <div className="space-y-2">
          <label htmlFor="password" className="text-sm font-medium">
            {t('passwordLabel')}
          </label>
          <div className="relative">
            <input
              id="password"
              type={showPassword ? 'text' : 'password'}
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
              disabled={isLoading}
              className="w-full rounded-md border border-input bg-background px-3 py-2 pe-10 text-sm ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring disabled:opacity-50"
            />
            <button
              type="button"
              onClick={() => setShowPassword((v) => !v)}
              className="absolute inset-y-0 end-0 flex items-center pe-3 text-muted-foreground hover:text-foreground"
              aria-label={showPassword ? t('hidePassword') : t('showPassword')}
              tabIndex={-1}
            >
              {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
            </button>
          </div>
        </div>

        <Button type="submit" disabled={isLoading} className="w-full">
          {isLoading ? t('signingIn') : t('signIn')}
        </Button>
      </form>

      <div className="relative">
        <div className="absolute inset-0 flex items-center">
          <span className="w-full border-t" />
        </div>
        <div className="relative flex justify-center text-xs uppercase">
          <span className="bg-background px-2 text-muted-foreground">or</span>
        </div>
      </div>

      <Button
        type="button"
        variant="outline"
        disabled={isLoading}
        onClick={onGoogleSignIn}
        className="w-full gap-2"
      >
        <svg viewBox="0 0 24 24" className="h-4 w-4" aria-hidden="true">
          <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4" />
          <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853" />
          <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z" fill="#FBBC05" />
          <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335" />
        </svg>
        {t('signInWithGoogle')}
      </Button>
    </div>
  );
}
