# Tasks: Basic Admin Dashboard (Makani)

**Input**: Design documents from `specs/001-basic-admin-dashboard/`

**Prerequisites**: plan.md ✓ | spec.md ✓ | research.md ✓ | data-model.md ✓ | contracts/ ✓

**Tests**: Not included (not requested in spec). Add test tasks manually if TDD is desired.

**Organization**: Tasks grouped by user story — each story is independently implementable and testable.

---

## Format: `[ID] [P?] [Story?] Description`

- **[P]**: Parallelizable — different files, no in-flight dependencies
- **[Story]**: User story label (US1–US5) — required for story phases
- All paths are relative to `dashborad/` (the dashboard project root)

---

## Phase 1: Setup

**Purpose**: Initialize the standalone Next.js dashboard project at `dashborad/`

- [ ] T001 Scaffold Next.js 14 App Router project with TypeScript in `dashborad/` using `npx create-next-app@latest dashborad --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"`
- [ ] T002 Install core dependencies: `firebase`, `next-intl`, `@tanstack/react-query`, `sonner` — update `dashborad/package.json`
- [ ] T003 [P] Install and init shadcn/ui in `dashborad/` — run `npx shadcn@latest init` and add Button, Badge, Table, Switch components
- [ ] T004 [P] Configure `dashborad/tsconfig.json` — enable `strict: true`, `exactOptionalPropertyTypes: true`, path alias `@/*` → `./src/*`
- [ ] T005 [P] Configure `dashborad/tailwind.config.ts` — add `tailwindcss-animate` plugin, extend colors for admin palette (neutral base + brand accent)
- [ ] T006 [P] Create `dashborad/.env.local` with all `NEXT_PUBLIC_FIREBASE_*` keys from Firebase project `makani-99af9` (web app config)
- [ ] T007 [P] Create `dashborad/.env.example` with placeholder keys documenting all required environment variables
- [ ] T008 Create empty directory tree per plan.md: `src/domain/`, `src/application/`, `src/infrastructure/`, `src/presentation/`, `src/i18n/` inside `dashborad/`
- [ ] T009 [P] Add `dashborad/.gitignore` entries for `.env.local`, `.next/`, `node_modules/`

**Checkpoint**: `cd dashborad && npm run dev` starts without errors on `localhost:3000`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Domain layer, Firebase init, i18n routing, and provider wiring — MUST complete before any user story

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

### Domain Entities (pure TypeScript — no imports from Firebase or React)

- [ ] T010 [P] Define `AdminUser` interface and `isAdminUser` type guard in `dashborad/src/domain/entities/admin-user.ts` per data-model.md
- [ ] T011 [P] Define `Listing` interface and `ListingStatus` union type (`'active' | 'inactive'`) in `dashborad/src/domain/entities/listing.ts` per data-model.md
- [ ] T012 [P] Define `Report` interface and `ReportStatus` union type (`'pending' | 'reviewed'`) in `dashborad/src/domain/entities/report.ts` per data-model.md
- [ ] T013 [P] Define `OverviewStats` interface with all four counter fields in `dashborad/src/domain/entities/stats.ts` per data-model.md

### Repository Interfaces (depend on T010–T013)

- [ ] T014 [P] Define `AuthRepository` interface (signInEmail, signInGoogle, signOut, onAuthStateChanged) in `dashborad/src/domain/repositories/auth-repository.ts`
- [ ] T015 [P] Define `ListingRepository` interface (getPaginated with cursor, updateStatus) in `dashborad/src/domain/repositories/listing-repository.ts`
- [ ] T016 [P] Define `ReportRepository` interface (getPaginated with cursor, markReviewed) in `dashborad/src/domain/repositories/report-repository.ts`
- [ ] T017 [P] Define `StatsRepository` interface (getOverviewStats) in `dashborad/src/domain/repositories/stats-repository.ts`

### Firebase Infrastructure (depends on T010–T017)

- [ ] T018 Create Firebase app singleton with env-driven config in `dashborad/src/infrastructure/firebase/app.ts` — exports `firebaseApp`, `auth`, `db`
- [ ] T019 [P] Define typed Firestore collection references (`usersCol`, `listingsCol`, `listingReportsCol`, `statsDoc`) in `dashborad/src/infrastructure/firebase/collections.ts`

### i18n Foundation (independent of Firebase)

- [ ] T020 Configure `next-intl` routing with locales `['en', 'ar']` and `defaultLocale: 'en'` in `dashborad/src/i18n/routing.ts` and `dashborad/src/i18n/config.ts` (locale → dir map: `ar → 'rtl'`, `en → 'ltr'`)
- [ ] T021 [P] Create `dashborad/middleware.ts` using `next-intl` `createMiddleware` — locale prefix strategy `always`, reads `makani-dashboard-locale` from `localStorage` cookie fallback
- [ ] T022 [P] Create `dashborad/next.config.ts` with `next-intl` plugin wrapper
- [ ] T023 Create root layout `dashborad/src/app/layout.tsx` — sets `<html lang={locale} dir={dir}>` from locale config; wraps with `QueryProvider`, `AuthProvider`, and `DIProvider`

**Checkpoint**: `npm run build` passes with zero type errors; `localhost:3000` redirects to `/en/`

---

## Phase 3: User Story 1 — Admin Authentication (Priority: P1) 🎯 MVP

**Goal**: Admins can sign in via email/password or Google, admin role is verified against Firestore `users/{uid}.isAdmin`, non-admins are denied, session persists on reload, sign-out works.

**Independent Test**: Navigate to `localhost:3000`, confirm redirect to `/en/sign-in`; sign in with admin credentials, confirm redirect to `/en/overview`; sign in with non-admin credentials, confirm "Access Denied" message; reload signed-in session, confirm no re-auth required.

### Implementation

- [ ] T024 [P] [US1] Implement `SignInEmailUseCase` and `SignOutUseCase` in `dashborad/src/domain/use-cases/auth/sign-in-email.ts` and `sign-out.ts` — pure functions over `AuthRepository` interface
- [ ] T025 [P] [US1] Implement `SignInGoogleUseCase` in `dashborad/src/domain/use-cases/auth/sign-in-google.ts`
- [ ] T026 [US1] Implement `FirebaseAuthRepository` in `dashborad/src/infrastructure/repositories/firebase-auth-repository.ts` — wraps Firebase Auth SDK; `signInWithEmailAndPassword`, `GoogleAuthProvider` popup, `signOut`, `onAuthStateChanged`; after sign-in reads `users/{uid}.isAdmin` from Firestore and throws `AccessDeniedError` if not `true`
- [ ] T027 [US1] Create `AuthProvider` in `dashborad/src/application/providers/auth-provider.tsx` — subscribes to `onAuthStateChanged`, exposes `{ user: AdminUser | null, loading: boolean }` via React context
- [ ] T028 [US1] Create `DIProvider` in `dashborad/src/application/providers/di-provider.tsx` — instantiates concrete repositories and provides them via context; create `QueryProvider` in `dashborad/src/application/providers/query-provider.tsx`
- [ ] T029 [US1] Implement `useAuth` hook in `dashborad/src/application/hooks/use-auth.ts` — returns `{ user, loading, signInEmail, signInGoogle, signOut, error }`
- [ ] T030 [US1] Build `SignInForm` component in `dashborad/src/presentation/components/auth/sign-in-form.tsx` per component contract — email/password fields, Google button, inline error display, loading states
- [ ] T031 [US1] Create `AdminGuard` in `dashborad/src/presentation/guards/admin-guard.tsx` — while loading show spinner; unauthenticated → redirect `/[locale]/sign-in`; non-admin → redirect `/[locale]/sign-in?reason=unauthorized`; create sign-in page at `dashborad/src/app/[locale]/(auth)/sign-in/page.tsx` and dashboard route group layout at `dashborad/src/app/[locale]/(dashboard)/layout.tsx` wrapping `AdminGuard` + `AppShell`

**Checkpoint**: Sign-in, access-denied, session-persist, and sign-out all work per quickstart.md scenarios 1–4 and 12

---

## Phase 4: User Story 2 — Overview Statistics Screen (Priority: P2)

**Goal**: Signed-in admin sees four stat cards (total users, active listings, pending reports, total bookings) loaded from `stats/overview` Firestore document in under 2 seconds.

**Independent Test**: Navigate to `/en/overview` as signed-in admin; confirm four stat cards render with correct values matching `stats/overview` Firestore document; confirm loading skeleton shown before data arrives; confirm error banner with retry shown if document read fails.

### Implementation

- [ ] T032 [P] [US2] Implement `GetOverviewStatsUseCase` in `dashborad/src/domain/use-cases/stats/get-overview-stats.ts`
- [ ] T033 [P] [US2] Implement `FirebaseStatsRepository` in `dashborad/src/infrastructure/repositories/firebase-stats-repository.ts` — reads `stats/overview` document; returns all-zeros `OverviewStats` if document does not exist
- [ ] T034 [US2] Implement `useStats` hook in `dashborad/src/application/hooks/use-stats.ts` using TanStack Query `useQuery` — 60-second `staleTime`, exposes `{ stats, isLoading, isError, refetch }`
- [ ] T035 [P] [US2] Build `StatCard` component in `dashborad/src/presentation/components/ui/stat-card.tsx` — accepts `label`, `value`, `isLoading`; shows skeleton div when loading
- [ ] T036 [US2] Build `StatsGrid` component in `dashborad/src/presentation/components/overview/stats-grid.tsx` per component contract — renders four `StatCard`s; error banner with retry on failure
- [ ] T037 [US2] Create overview page at `dashborad/src/app/[locale]/(dashboard)/overview/page.tsx` — renders `StatsGrid` using `useStats`

**Checkpoint**: Overview screen passes quickstart.md scenarios 5; stat cards display correct Firestore values

---

## Phase 5: User Story 3 — Property Listings Management (Priority: P3)

**Goal**: Signed-in admin sees paginated listings (20/page), can toggle status with immediate undo toast, changes persist to Firestore.

**Independent Test**: Navigate to `/en/listings`; confirm table renders with pagination; toggle an active listing to inactive; confirm toast with Undo appears; click Undo; confirm listing reverts to active; confirm Firestore reflects both changes.

### Implementation

- [ ] T038 [P] [US3] Implement `GetPaginatedListingsUseCase` in `dashborad/src/domain/use-cases/listings/get-paginated-listings.ts` — returns `{ listings: Listing[], nextCursor: DocumentSnapshot | null }`
- [ ] T039 [P] [US3] Implement `ToggleListingStatusUseCase` in `dashborad/src/domain/use-cases/listings/toggle-listing-status.ts` — takes listingId + current status, returns new status
- [ ] T040 [US3] Implement `FirebaseListingRepository` in `dashborad/src/infrastructure/repositories/firebase-listing-repository.ts` — `getPaginated`: query `listings` ordered by `createdAt` descending, `limit(20)`, `startAfter` cursor; `updateStatus`: Firestore `update({ status, updatedAt })`
- [ ] T041 [US3] Implement `useListings` hook in `dashborad/src/application/hooks/use-listings.ts` using TanStack Query `useInfiniteQuery`; `toggleStatus` mutation uses optimistic update — immediately mutates cache, fires Firestore write; on failure reverts cache; on success shows Sonner toast with Undo action that re-fires the inverse toggle
- [ ] T042 [P] [US3] Build `StatusToggle` component in `dashborad/src/presentation/components/listings/status-toggle.tsx` per component contract — Switch primitive from shadcn/ui; disabled while `isUpdating`
- [ ] T043 [P] [US3] Build `DataTable` primitive in `dashborad/src/presentation/components/ui/data-table.tsx` — generic table wrapper with thead/tbody, loading skeleton rows, empty-state slot, previous/next pagination controls
- [ ] T044 [US3] Build `ListingsTable` component in `dashborad/src/presentation/components/listings/listings-table.tsx` per component contract — uses `DataTable`; columns: property type, owner UID (first 8 chars), status badge, date, `StatusToggle`
- [ ] T045 [US3] Create listings page at `dashborad/src/app/[locale]/(dashboard)/listings/page.tsx` — renders `ListingsTable` using `useListings`; add Sonner `<Toaster />` to dashboard layout

**Checkpoint**: Listings page passes quickstart.md scenarios 6 and 7 (toggle + undo)

---

## Phase 6: User Story 4 — User Reports Management (Priority: P4)

**Goal**: Signed-in admin sees paginated reports, can mark pending reports as reviewed, status updates immediately.

**Independent Test**: Navigate to `/en/reports`; confirm table renders with `listingReports` data; click "Mark Reviewed" on a pending report; confirm status badge changes to "Reviewed" and button disappears; confirm Firestore `listingReports/{id}.status` is `'reviewed'`.

### Implementation

- [ ] T046 [P] [US4] Implement `GetReportsUseCase` in `dashborad/src/domain/use-cases/reports/get-reports.ts`
- [ ] T047 [P] [US4] Implement `MarkReportReviewedUseCase` in `dashborad/src/domain/use-cases/reports/mark-report-reviewed.ts`
- [ ] T048 [US4] Implement `FirebaseReportRepository` in `dashborad/src/infrastructure/repositories/firebase-report-repository.ts` — `getPaginated`: query `listingReports` ordered by `createdAt` descending, `limit(20)`, `startAfter` cursor; `markReviewed`: Firestore `update({ status: 'reviewed', updatedAt: serverTimestamp() })`
- [ ] T049 [US4] Implement `useReports` hook in `dashborad/src/application/hooks/use-reports.ts` using TanStack Query `useInfiniteQuery`; `markReviewed` mutation — optimistic cache update sets status to `'reviewed'`; on failure reverts and shows error toast
- [ ] T050 [US4] Build `ReportsTable` component in `dashborad/src/presentation/components/reports/reports-table.tsx` per component contract — uses `DataTable`; columns: listing ID (first 8 chars), reporter UID (first 8 chars), reason (80-char truncation with full-text `title` tooltip), status badge, date, "Mark Reviewed" button (hidden for reviewed reports)
- [ ] T051 [US4] Create reports page at `dashborad/src/app/[locale]/(dashboard)/reports/page.tsx` — renders `ReportsTable` using `useReports`

**Checkpoint**: Reports page passes quickstart.md scenarios 8 (mark reviewed)

---

## Phase 7: User Story 5 — Language Switching Arabic / English (Priority: P5)

**Goal**: Admin switches between English (LTR) and Arabic (RTL) via top-nav toggle; all labels translate; layout direction flips; preference persists in localStorage across reloads.

**Independent Test**: Load dashboard in English; click language toggle to Arabic; confirm URL changes to `/ar/...`; confirm all text renders in Arabic; confirm `dir="rtl"` on `<html>`; reload; confirm Arabic persists.

### Implementation

- [ ] T052 [P] [US5] Create `dashborad/src/i18n/messages/en.json` with all English strings per data-model.md message key structure — auth, nav, overview, listings, reports, common sections
- [ ] T053 [P] [US5] Create `dashborad/src/i18n/messages/ar.json` with Arabic translations for all keys in en.json
- [ ] T054 [US5] Wire `next-intl` `NextIntlClientProvider` in `dashborad/src/app/[locale]/layout.tsx` — load messages for active locale; set `<html lang={locale} dir={dir}>` using locale config from `src/i18n/config.ts`
- [ ] T055 [US5] Build `AppShell` in `dashborad/src/presentation/components/layout/app-shell.tsx` and `Sidebar` in `dashborad/src/presentation/components/layout/sidebar.tsx` — nav links using `next-intl` `Link` for locale-aware routing; all labels from i18n messages
- [ ] T056 [US5] Build `TopNav` in `dashborad/src/presentation/components/layout/top-nav.tsx` per component contract — language toggle: on switch writes `makani-dashboard-locale` to `localStorage`, sets `NEXT_LOCALE` cookie, navigates to same route under new locale prefix; sign-out button
- [ ] T057 [US5] Replace all hardcoded strings in existing components (SignInForm, StatsGrid, ListingsTable, ReportsTable, AdminGuard) with `useTranslations` calls using the message keys from en.json/ar.json

**Checkpoint**: Language switch passes quickstart.md scenarios 9 and 10; all pages render without untranslated strings in both locales

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Final wiring, error handling, build validation

- [ ] T058 Wire `AppShell` + `Sidebar` + `TopNav` into `dashborad/src/app/[locale]/(dashboard)/layout.tsx` — pass `currentLocale` and `adminName` from `useAuth`; confirm navigation links are correct for both locales
- [ ] T059 [P] Add `dashborad/src/presentation/components/ui/empty-state.tsx` — reusable empty-state component with icon slot and message; replace inline empty messages in `ListingsTable` and `ReportsTable`
- [ ] T060 [P] Add global error handling: wrap `dashborad/src/app/[locale]/(dashboard)/layout.tsx` with an `error.tsx` boundary that shows a translated error message with retry link
- [ ] T061 Create `dashborad/scripts/seed-stats.ts` — a one-time Node.js script that reads Firestore and writes correct counts to `stats/overview`; document usage in quickstart.md
- [ ] T062 [P] Update `dashborad/src/app/[locale]/(auth)/sign-in/page.tsx` to redirect already-authenticated admins to `/[locale]/overview` on mount
- [ ] T063 Run `npm run build` in `dashborad/` — fix all TypeScript errors and ESLint warnings until build passes with zero errors
- [ ] T064 [P] Validate all 12 quickstart.md scenarios against the running development server; check each scenario off as passing
- [ ] T065 [P] Add `README.md` to `dashborad/` documenting setup steps, env vars, and how to grant admin access (set `isAdmin: true` in Firestore Console)

**Checkpoint**: `npm run build` exits 0; all quickstart.md scenarios pass

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies — start immediately
- **Phase 2 (Foundational)**: Depends on Phase 1 — **blocks all user stories**
- **Phase 3 (US1 Auth)**: Depends on Phase 2 — start after foundational complete
- **Phase 4 (US2 Overview)**: Depends on Phase 2; can run in parallel with Phase 3
- **Phase 5 (US3 Listings)**: Depends on Phase 2; can run in parallel with Phase 3 & 4
- **Phase 6 (US4 Reports)**: Depends on Phase 2; can run in parallel with other story phases
- **Phase 7 (US5 i18n)**: Depends on Phase 2; strings work required after components exist — run after Phase 3–6 components are built
- **Phase 8 (Polish)**: Depends on all story phases complete

### User Story Dependencies

- **US1 (P1)**: Can start after Phase 2 — no story dependencies. Delivers sign-in + admin gate = MVP
- **US2 (P2)**: Can start after Phase 2 — no story dependencies. Requires `AdminGuard` from US1 to see the overview page
- **US3 (P3)**: Can start after Phase 2 — shares `DataTable` primitive with US4
- **US4 (P4)**: Can start after Phase 2 — shares `DataTable` primitive with US3
- **US5 (P5)**: Requires components from US1–US4 to exist before string extraction (T057)

### Within Each User Story

- Domain use-cases before infrastructure repositories
- Infrastructure repositories before application hooks
- Application hooks before presentation components
- Presentation components before page assembly

---

## Parallel Opportunities

### Phase 2 Parallel Batch

```
T010 AdminUser entity        T014 AuthRepository interface
T011 Listing entity     →    T015 ListingRepository interface
T012 Report entity           T016 ReportRepository interface
T013 OverviewStats entity    T017 StatsRepository interface
```

### Phase 3 Parallel Batch (US1)

```
T024 SignInEmailUseCase  ─┐
T025 SignInGoogleUseCase  ├──► T026 FirebaseAuthRepository ──► T027 AuthProvider ──► T029 useAuth
                          │
T030 SignInForm component ─┘ (can build against interface, not implementation)
```

### Phase 4–6 Parallel Batch (US2, US3, US4 — after Phase 2)

```
US2: T032 GetOverviewStats + T033 FirebaseStatsRepository (parallel)
US3: T038 GetPaginatedListings + T039 ToggleStatus (parallel)
US4: T046 GetReports + T047 MarkReviewed (parallel)
```

### Phase 7 Parallel Batch (US5)

```
T052 en.json  (parallel)
T053 ar.json  (parallel)
```

---

## Implementation Strategy

### MVP First (US1 Only — ~15 tasks)

1. Complete Phase 1: Setup (T001–T009)
2. Complete Phase 2: Foundational (T010–T023)
3. Complete Phase 3: US1 Auth (T024–T031)
4. **STOP and VALIDATE**: Sign-in, admin gate, session, sign-out all working
5. Deploy preview — admins can authenticate

### Incremental Delivery

1. Phase 1 + 2 → Foundation ready
2. Phase 3 (US1) → Admin auth working — **deploy as MVP**
3. Phase 4 (US2) → Overview stats visible — **demo to stakeholders**
4. Phase 5 (US3) → Listing management working
5. Phase 6 (US4) → Report review working
6. Phase 7 (US5) → Full Arabic/English switching
7. Phase 8 → Production-ready build

### Single Developer Sequential Order

```
T001 → T002 → T003–T009 (parallel)
→ T010–T013 (parallel)
→ T014–T017 (parallel)
→ T018 → T019 (parallel with T020–T022)
→ T023
→ T024–T025 (parallel) → T026 → T027 → T028 → T029 → T030 → T031
→ T032–T033 (parallel) → T034 → T035–T036 (parallel) → T037
→ T038–T039 (parallel) → T040 → T041 → T042–T043 (parallel) → T044 → T045
→ T046–T047 (parallel) → T048 → T049 → T050 → T051
→ T052–T053 (parallel) → T054 → T055 → T056 → T057
→ T058 → T059–T060 (parallel) → T061 → T062–T063 (parallel) → T064–T065 (parallel)
```

---

## Notes

- All paths are relative to `dashborad/` (project root inside the repo)
- `[P]` tasks touch different files — safe to run in parallel
- Each phase ends with a named checkpoint from quickstart.md
- US1 (T024–T031) is the MVP — deliver and validate before continuing
- `stats/overview` Firestore document must exist before US2 works — see quickstart.md Step 0
- Admin access granted by setting `users/{uid}.isAdmin = true` in Firebase Console (not in scope for dashboard v1)
- Total tasks: 65 | Setup: 9 | Foundational: 14 | US1: 8 | US2: 6 | US3: 8 | US4: 6 | US5: 6 | Polish: 8
