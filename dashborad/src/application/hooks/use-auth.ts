'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useAuthContext } from '../providers/auth-provider';
import { useDI } from '../providers/di-provider';
import { AccessDeniedError } from '@/infrastructure/repositories/firebase-auth-repository';

export function useAuth() {
  const { user, loading } = useAuthContext();
  const { authRepo } = useDI();
  const router = useRouter();
  const [error, setError] = useState<string | null>(null);
  const [isSigningIn, setIsSigningIn] = useState(false);

  async function signInEmail(email: string, password: string) {
    setError(null);
    setIsSigningIn(true);
    try {
      await authRepo.signInWithEmail(email, password);
      router.push('./overview');
    } catch (err) {
      if (err instanceof AccessDeniedError) {
        setError('access_denied');
      } else {
        setError('invalid_credentials');
      }
    } finally {
      setIsSigningIn(false);
    }
  }

  async function signInGoogle() {
    setError(null);
    setIsSigningIn(true);
    try {
      await authRepo.signInWithGoogle();
      router.push('./overview');
    } catch (err) {
      if (err instanceof AccessDeniedError) {
        setError('access_denied');
      } else {
        setError('google_error');
      }
    } finally {
      setIsSigningIn(false);
    }
  }

  async function signOut() {
    await authRepo.signOut();
    router.push('./sign-in');
  }

  return { user, loading, isSigningIn, error, signInEmail, signInGoogle, signOut };
}
