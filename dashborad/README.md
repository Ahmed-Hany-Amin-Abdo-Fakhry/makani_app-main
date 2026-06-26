# Makani Admin Dashboard

Next.js admin dashboard for the Makani property rental platform.

## Requirements

- Node.js 20+
- Firebase project `makani-99af9` (same project as the Flutter app)
- A user document in Firestore with `isAdmin: true`

## Setup

1. **Install dependencies**
   ```bash
   npm install
   ```

2. **Configure environment**

   Copy `.env.example` to `.env.local` and fill in your Firebase Web App config:
   ```bash
   cp .env.example .env.local
   ```

   Get the values from **Firebase Console → Project Settings → Your apps → Web app**.

3. **Grant admin access**

   In Firebase Console → Firestore → `users` collection, open the document for your admin user's UID and set:
   ```
   isAdmin: true
   ```

4. **Seed the stats document** (first run only)
   ```bash
   npx tsx scripts/seed-stats.ts
   ```
   This creates `stats/overview` with zero counts. Update the values manually or wire up Cloud Functions to maintain them.

5. **Start development server**
   ```bash
   npm run dev
   ```
   Open [http://localhost:3000](http://localhost:3000) — it redirects to `/en/overview` (or `/en/sign-in` if not authenticated).

## Routes

| Route | Description |
|-------|-------------|
| `/en/sign-in` | Sign in with email/password or Google |
| `/en/overview` | Stats overview (4 cards from `stats/overview`) |
| `/en/listings` | Paginated listings table with status toggle |
| `/en/reports` | Paginated reports table with mark-reviewed |
| `/ar/*` | Arabic RTL equivalents of all routes |

## Architecture

```
src/
├── domain/          # Pure TypeScript — entities, repository interfaces, use-cases
├── application/     # React hooks and context providers
├── infrastructure/  # Firebase implementations of repository interfaces
├── presentation/    # React components and guards
└── app/             # Next.js App Router (thin routing layer only)
```

## Language Switching

Click the language toggle in the top-nav to switch between English (LTR) and Arabic (RTL). The preference is saved to `localStorage` under `makani-dashboard-locale`.
