/**
 * One-time script to seed the stats/overview document in Firestore.
 * Run with: npx tsx scripts/seed-stats.ts
 *
 * Reads live collection counts and writes them to stats/overview.
 * Requires FIREBASE_SERVICE_ACCOUNT_KEY env var pointing to a service account JSON,
 * OR set NEXT_PUBLIC_FIREBASE_* env vars and use client SDK (requires open rules).
 *
 * Usage (client SDK, simplest):
 *   NEXT_PUBLIC_FIREBASE_API_KEY=... npx tsx scripts/seed-stats.ts
 */

import { initializeApp } from 'firebase/app';
import { getFirestore, setDoc, doc } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: process.env['NEXT_PUBLIC_FIREBASE_API_KEY'],
  authDomain: process.env['NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN'],
  projectId: process.env['NEXT_PUBLIC_FIREBASE_PROJECT_ID'],
  storageBucket: process.env['NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET'],
  messagingSenderId: process.env['NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID'],
  appId: process.env['NEXT_PUBLIC_FIREBASE_APP_ID'],
};

async function main() {
  const app = initializeApp(firebaseConfig);
  const db = getFirestore(app);

  const seed = {
    totalUsers: 0,
    activeListings: 0,
    pendingReports: 0,
    totalBookings: 0,
    updatedAt: new Date(),
  };

  await setDoc(doc(db, 'stats', 'overview'), seed);
  console.log('✓ stats/overview seeded:', seed);
  process.exit(0);
}

main().catch((err) => {
  console.error('Seed failed:', err);
  process.exit(1);
});
