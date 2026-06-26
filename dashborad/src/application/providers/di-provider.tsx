'use client';

import { createContext, useContext, useMemo } from 'react';
import { FirebaseAuthRepository } from '@/infrastructure/repositories/firebase-auth-repository';
import { FirebaseListingRepository } from '@/infrastructure/repositories/firebase-listing-repository';
import { FirebaseReportRepository } from '@/infrastructure/repositories/firebase-report-repository';
import { FirebaseStatsRepository } from '@/infrastructure/repositories/firebase-stats-repository';
import { FirebaseTeamRepository } from '@/infrastructure/repositories/firebase-team-repository';
import type { AuthRepository } from '@/domain/repositories/auth-repository';
import type { ListingRepository } from '@/domain/repositories/listing-repository';
import type { ReportRepository } from '@/domain/repositories/report-repository';
import type { StatsRepository } from '@/domain/repositories/stats-repository';
import type { TeamRepository } from '@/domain/repositories/team-repository';

interface DIContextValue {
  authRepo: AuthRepository;
  listingRepo: ListingRepository;
  reportRepo: ReportRepository;
  statsRepo: StatsRepository;
  teamRepo: TeamRepository;
}

const DIContext = createContext<DIContextValue | null>(null);

export function DIProvider({ children }: { children: React.ReactNode }) {
  const value = useMemo<DIContextValue>(
    () => ({
      authRepo: new FirebaseAuthRepository(),
      listingRepo: new FirebaseListingRepository(),
      reportRepo: new FirebaseReportRepository(),
      statsRepo: new FirebaseStatsRepository(),
      teamRepo: new FirebaseTeamRepository(),
    }),
    []
  );
  return <DIContext.Provider value={value}>{children}</DIContext.Provider>;
}

export function useDI(): DIContextValue {
  const ctx = useContext(DIContext);
  if (!ctx) throw new Error('useDI must be used within DIProvider');
  return ctx;
}
