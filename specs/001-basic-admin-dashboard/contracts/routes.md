# Route Contracts: Basic Admin Dashboard (Makani)

**Date**: 2026-06-26 | **Plan**: [plan.md](../plan.md)

All routes are prefixed with the active locale (`/en` or `/ar`). The `next-intl` middleware rewrites `/` → `/en` (default locale) automatically.

---

## Route Table

| Route | File | Auth Required | Admin Required | Description |
|-------|------|---------------|----------------|-------------|
| `/[locale]/sign-in` | `app/[locale]/(auth)/sign-in/page.tsx` | No | No | Sign-in page |
| `/[locale]/overview` | `app/[locale]/(dashboard)/overview/page.tsx` | Yes | Yes | Stats overview |
| `/[locale]/listings` | `app/[locale]/(dashboard)/listings/page.tsx` | Yes | Yes | Listings management |
| `/[locale]/reports` | `app/[locale]/(dashboard)/reports/page.tsx` | Yes | Yes | Reports management |
| `/` | redirect | — | — | Redirects to `/en/overview` |

---

## Route: Sign-In `/[locale]/sign-in`

**Auth state**: Unauthenticated only. Already-authenticated admins are redirected to `/[locale]/overview`.

**Inputs** (form fields):
- `email: string` — valid email format required
- `password: string` — minimum 6 characters (Firebase minimum)

**Actions**:
- `POST sign-in/email` — calls Firebase `signInWithEmailAndPassword`
- `POST sign-in/google` — triggers Firebase Google OAuth popup

**Outcomes**:

| Condition | Outcome |
|-----------|---------|
| Valid admin credentials | Redirect → `/[locale]/overview` |
| Valid credentials, non-admin `isAdmin` field | Stay on sign-in; show "Access denied — not an admin account" |
| Invalid credentials | Stay on sign-in; show Firebase error message |
| Network error | Stay on sign-in; show generic error with retry |

---

## Route: Overview `/[locale]/overview`

**Auth state**: Authenticated + isAdmin = true required.

**Data loaded**:
- `GET stats/overview` — single Firestore document read

**Displayed data**:
- Total Users count
- Active Listings count
- Pending Reports count
- Total Bookings count

**Error states**:
- Document missing → display `0` for all counts (not an error)
- Network failure → display error banner with retry button

---

## Route: Listings `/[locale]/listings`

**Auth state**: Authenticated + isAdmin = true required.

**Data loaded**:
- `GET listings` — paginated Firestore query, ordered by `createdAt` descending, `limit(20)`, cursor-based

**Query parameters** (client-side state, not URL params):
- `page` — current page cursor (managed by TanStack Query `useInfiniteQuery`)

**Displayed data per row**:
- Property type (from `propertyTypeKey`)
- Owner UID (shortened for display)
- Status badge (active / inactive)
- Creation date (formatted)
- Toggle control

**Actions**:
- Toggle listing status — optimistic update; undo toast displayed for ~5 seconds
- Navigate previous / next page

**Error states**:
- Firestore read failure → error banner + retry
- Toggle write failure → revert optimistic update; show error toast

---

## Route: Reports `/[locale]/reports`

**Auth state**: Authenticated + isAdmin = true required.

**Data loaded**:
- `GET listingReports` — paginated Firestore query, ordered by `createdAt` descending, `limit(20)`, cursor-based

**Displayed data per row**:
- Listing ID (shortened)
- Reporter UID (shortened)
- Reason text (truncated to 80 chars)
- Status badge (pending / reviewed)
- Creation date (formatted)
- "Mark reviewed" button (only shown for pending reports)

**Actions**:
- Mark report as reviewed — immediate Firestore write; button replaced by "Reviewed" badge

**Error states**:
- Firestore read failure → error banner + retry
- Write failure → show error toast; status remains pending

---

## Redirect Rules

| Condition | Redirect destination |
|-----------|---------------------|
| Unauthenticated user accesses any dashboard route | `/[locale]/sign-in` |
| Authenticated non-admin accesses any dashboard route | `/[locale]/sign-in` with `?reason=unauthorized` |
| Authenticated admin accesses `/[locale]/sign-in` | `/[locale]/overview` |
| Root path `/` | `/en/overview` (or `/ar/overview` if locale cookie set) |
