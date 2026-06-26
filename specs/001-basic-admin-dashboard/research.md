# Research: Basic Admin Dashboard (Makani)

**Date**: 2026-06-26 | **Plan**: [plan.md](./plan.md)

---

## Decision 1: Next.js Router Strategy

**Decision**: App Router (`app/` directory) with `[locale]` dynamic segment

**Rationale**: App Router is the current Next.js standard (v13+). It enables React Server Components, nested layouts (critical for the auth-guard pattern), and first-class support for `next-intl`'s server-side message loading. The `(auth)` and `(dashboard)` route groups cleanly separate the sign-in page (no shell) from the admin shell without extra routing logic.

**Alternatives considered**:
- Pages Router — mature but deprecated path; lacks nested layouts natively; `next-intl` requires more boilerplate
- Parallel routes — unnecessary complexity for four screens

---

## Decision 2: i18n Library

**Decision**: `next-intl` 3.x

**Rationale**: `next-intl` is the only i18n library with native Next.js App Router support (Server Components + Client Components), built-in locale middleware, and typed message keys. It integrates with `[locale]` routing out of the box. RTL is handled at the CSS/layout level (see Decision 5) — `next-intl` handles only the string translation concern.

**Alternatives considered**:
- `react-i18next` — excellent library but requires custom middleware wiring for App Router locale routing; no built-in Next.js App Router adapter
- `next-translate` — Pages Router only; not App Router compatible
- Manual JSON + `useContext` — too much boilerplate; no pluralization or date formatting

**Language persistence**: `localStorage` key `makani-dashboard-locale`. On app load, middleware reads the `NEXT_LOCALE` cookie set by `next-intl`; on language toggle, the client writes to `localStorage` and updates the cookie + navigates to the new locale prefix. This satisfies FR-011.

---

## Decision 3: Server-State Management

**Decision**: TanStack Query v5 (`@tanstack/react-query`)

**Rationale**: Firestore reads in the dashboard (listings, reports, stats) are inherently async fetches with caching, refetch, and invalidation needs. TanStack Query handles all of this without additional state management overhead. Optimistic updates (for the listing toggle undo flow) are a first-class TanStack Query feature. Auth state (which is push-based via `onAuthStateChanged`) is managed separately in a React context.

**Alternatives considered**:
- Zustand + manual fetch — viable but requires writing caching logic from scratch
- SWR — lighter but less capable optimistic update API; undo pattern is harder
- Redux Toolkit Query — overkill for a small admin app

---

## Decision 4: UI Component Strategy

**Decision**: `shadcn/ui` primitives + `tailwindcss`

**Rationale**: `shadcn/ui` generates accessible, unstyled Radix UI–based components directly into the project (no runtime dependency). This means no version conflicts and full customization control. Tailwind CSS with CSS logical properties (`ms-`, `me-`, `ps-`, `pe-`) handles RTL layout automatically when the `dir` attribute on `<html>` is set to `rtl`. The `tailwindcss-rtl` plugin is not required if using Tailwind v3.3+ logical properties.

**Alternatives considered**:
- Ant Design — has good RTL support but adds ~500 KB to bundle; overkill for a basic dashboard
- Material UI — React 18 + Next.js App Router SSR compatibility issues with emotion
- Chakra UI — RTL support is not fully automatic; requires manual mirroring

---

## Decision 5: RTL Layout Strategy

**Decision**: CSS logical properties via Tailwind (`dir="rtl"` on `<html>`) — no component-level mirroring

**Rationale**: Setting `dir="rtl"` on the `<html>` element (driven by the active locale) and using Tailwind's logical property utilities (`ms-*`, `me-*`, `ps-*`, `pe-*`, `text-start`, `text-end`) means all layout automatically mirrors for Arabic with zero component-level if-checks. The `next.config.ts` i18n `dir` mapping drives the `lang` and `dir` attributes in the root layout.

---

## Decision 6: Toast / Undo Notifications

**Decision**: `sonner` library

**Rationale**: `sonner` is a modern, accessible, zero-configuration toast library from the creator of Radix UI. It supports promise-based toasts (perfect for async Firestore writes), action buttons (the "Undo" button), and RTL. It renders in a portal so it doesn't affect layout.

**Alternatives considered**:
- `react-hot-toast` — no built-in action button; undo pattern requires manual implementation
- `react-toastify` — larger bundle, more configuration required for RTL

---

## Decision 7: Admin Role Determination

**Decision**: `isAdmin: boolean` field on `users/{uid}` Firestore document

**Rationale**: The existing `users` collection already stores user profiles (confirmed in `UserProfileFirestoreMapper`). Adding `isAdmin: true` to admin documents is the minimal change — no new collection needed. The `AdminGuard` component reads `users/{currentUser.uid}` on mount and checks `isAdmin`. If the field is absent or `false`, the user is redirected to sign-in.

**Firestore path**: `users/{uid}` → `{ ..., isAdmin: true }`

**How to grant admin access**: Manually set `isAdmin: true` on the target user's Firestore document via the Firebase Console (or a one-time script). This is intentionally out of dashboard scope for v1.

---

## Decision 8: Statistics Counter Document

**Decision**: Pre-aggregated `stats/overview` Firestore document

**Rationale**: The Makani Flutter app does not currently maintain this document (confirmed by collection scan). Creating and maintaining it is in scope for this dashboard's setup. The dashboard will seed it with a one-time Cloud Firestore transaction and the Flutter app will be responsible for incrementing/decrementing counters on relevant writes. For v1, the dashboard setup script creates the document; Flutter app integration is out of scope.

**Document path**: `stats/overview`
**Fields**: `{ totalUsers: number, activeListings: number, pendingReports: number, totalBookings: number, updatedAt: Timestamp }`

**Note**: If the document does not exist when the dashboard loads, the overview page displays zero for all counters rather than an error.

---

## Decision 9: Pagination Strategy

**Decision**: Firestore cursor-based pagination (`startAfter` + `limit(20)`)

**Rationale**: Offset-based pagination is not supported by Firestore. Cursor-based pagination (using the last document snapshot as a cursor) is the Firestore standard. TanStack Query's `useInfiniteQuery` maps naturally to this pattern. Page size is 20.

---

## Decision 10: Firestore Collections Used by Dashboard

| Collection | Dashboard Operations |
|------------|---------------------|
| `users/{uid}` | Read: check `isAdmin` field on sign-in |
| `listings` | Read: paginated list (title, ownerId, status, createdAt); Write: update `status` field |
| `listingReports` | Read: paginated list (listingId, reporterUid, reason, status, createdAt); Write: update `status` to `'reviewed'` |
| `stats/overview` | Read: single document for overview stats |

**Not accessed**: `favorites`, `bookings`, `users/{uid}/reportedListings` (guard subcollection — mobile only)
