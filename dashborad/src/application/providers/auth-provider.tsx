'use client';

import { createContext, useContext, useEffect, useState } from 'react';
import { getRedirectResult } from 'firebase/auth';
import { auth } from '@/infrastructure/firebase/app';
import type { AdminUser } from '@/domain/entities/admin-user';
import { useDI } from './di-provider';

interface AuthContextValue {
  user: AdminUser | null;
  loading: boolean;
}

const AuthContext = createContext<AuthContextValue>({ user: null, loading: true });

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const { authRepo } = useDI();
  const [user, setUser] = useState<AdminUser | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // consume redirect result first so onAuthStateChanged sees the signed-in user
    getRedirectResult(auth).catch(() => {});

    const unsubscribe = authRepo.onAuthStateChanged((adminUser) => {
      setUser(adminUser);
      setLoading(false);
    });
    return unsubscribe;
  }, [authRepo]);

  return <AuthContext.Provider value={{ user, loading }}>{children}</AuthContext.Provider>;
}

export function useAuthContext() {
  return useContext(AuthContext);
}
