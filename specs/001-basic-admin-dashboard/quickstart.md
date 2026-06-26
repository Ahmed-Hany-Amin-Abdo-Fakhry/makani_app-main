# Quickstart Validation Guide: Basic Admin Dashboard (Makani)

**Date**: 2026-06-26 | **Plan**: [plan.md](./plan.md)

This guide describes how to validate that the dashboard works end-to-end after implementation. It does not include implementation code — see `tasks.md` for that.

---

## Prerequisites

1. **Node.js 20 LTS** installed (`node --version` → `v20.x.x`)
2. **Firebase project access**: `makani-99af9` — you need read/write access to Firestore
3. **Admin test account**: A Firebase Auth user with `isAdmin: true` set on their `users/{uid}` Firestore document
4. **Non-admin test account**: A Firebase Auth user without `isAdmin: true`
5. **`stats/overview` document**: Must exist in Firestore (seed it if not — see Step 0 below)

---

## Step 0: Seed the Stats Document (one-time setup)

If `stats/overview` does not exist in Firestore, create it manually in the Firebase Console:

```
Collection: stats
Document ID: overview
Fields:
  totalUsers: 0        (number)
  activeListings: 0    (number)
  pendingReports: 0    (number)
  totalBookings: 0     (number)
  updatedAt: <now>     (timestamp)
```

---

## Step 1: Install and Configure

```bash
cd dashborad
npm install
```

Confirm `.env.local` exists with the Makani Firebase config:
```
NEXT_PUBLIC_FIREBASE_API_KEY=AIzaSyDN-oA_...
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=makani-99af9.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=makani-99af9
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=makani-99af9.firebasestorage.app
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=61809860940
NEXT_PUBLIC_FIREBASE_APP_ID=<web app id from Firebase Console>
```

---

## Step 2: Start the Development Server

```bash
npm run dev
```

Expected: server starts on `http://localhost:3000`, no TypeScript errors in console.

---

## Validation Scenario 1: Root Redirect

**Steps**:
1. Open `http://localhost:3000`

**Expected**: Browser redirects to `http://localhost:3000/en/sign-in` (unauthenticated redirect chain: root → `/en/overview` → `/en/sign-in`)

---

## Validation Scenario 2: Admin Sign-In (Email/Password)

**Steps**:
1. Navigate to `http://localhost:3000/en/sign-in`
2. Enter valid admin account email and password
3. Click "Sign In"

**Expected**:
- Loading state visible on button
- Redirect to `/en/overview`
- Stats cards rendered (may show 0 if no data yet)
- Admin name visible in top navigation

---

## Validation Scenario 3: Non-Admin Access Denied

**Steps**:
1. Sign out (or use incognito)
2. Navigate to `http://localhost:3000/en/sign-in`
3. Enter non-admin account credentials
4. Click "Sign In"

**Expected**:
- Stays on sign-in page
- Error message: "Access denied — not an admin account" (or equivalent translated message)

---

## Validation Scenario 4: Direct Dashboard URL (Unauthenticated)

**Steps**:
1. Sign out (or use incognito)
2. Navigate directly to `http://localhost:3000/en/listings`

**Expected**: Redirect to `/en/sign-in`

---

## Validation Scenario 5: Overview Stats Display

**Precondition**: Signed in as admin. `stats/overview` document has non-zero values.

**Steps**:
1. Navigate to `/en/overview`

**Expected**:
- Four stat cards visible: Total Users, Active Listings, Pending Reports, Total Bookings
- Values match Firestore `stats/overview` document fields

---

## Validation Scenario 6: Listings Table

**Steps**:
1. Navigate to `/en/listings`

**Expected**:
- Paginated list of listings visible
- Each row: property type, owner ID (shortened), status badge (Active/Inactive), creation date, toggle switch
- Next/Previous page buttons functional (if >20 listings exist)

---

## Validation Scenario 7: Listing Status Toggle + Undo

**Precondition**: At least one active listing visible.

**Steps**:
1. Find an active listing
2. Click its toggle to deactivate it

**Expected**:
- Toggle reflects inactive state immediately
- Toast notification appears with "Undo" button and ~5-second timer
- Firestore `listings/{id}.status` updates to `'inactive'`

**Undo test**:
3. Click the "Undo" button within 5 seconds

**Expected**:
- Toggle reverts to active state
- Firestore `listings/{id}.status` reverts to `'active'`

---

## Validation Scenario 8: Reports Table + Mark Reviewed

**Precondition**: At least one pending report exists in `listingReports`.

**Steps**:
1. Navigate to `/en/reports`
2. Find a pending report
3. Click "Mark Reviewed"

**Expected**:
- "Mark Reviewed" button disappears
- Status badge changes to "Reviewed"
- Firestore `listingReports/{id}.status` updates to `'reviewed'`

---

## Validation Scenario 9: Language Switch to Arabic (RTL)

**Steps**:
1. While on any dashboard page (e.g., `/en/overview`)
2. Click the language toggle in the top navigation to switch to Arabic

**Expected**:
- URL changes to `/ar/overview`
- All text labels render in Arabic
- Page layout direction flips to RTL (navigation, text alignment, margins all mirrored)
- Language preference saved to `localStorage` key `makani-dashboard-locale`

---

## Validation Scenario 10: Language Persistence Across Reload

**Precondition**: Arabic selected (Scenario 9 completed).

**Steps**:
1. Reload the page (`F5`)

**Expected**:
- Page loads in Arabic at `/ar/overview`
- Language preference was preserved via `localStorage`

---

## Validation Scenario 11: Session Persistence

**Precondition**: Signed in as admin.

**Steps**:
1. Reload the page

**Expected**:
- Remains on current dashboard page
- No re-authentication required
- Admin name still visible in navigation

---

## Validation Scenario 12: Sign Out

**Steps**:
1. Click "Sign Out" in the top navigation

**Expected**:
- Redirect to `/en/sign-in` (or `/ar/sign-in` if Arabic active)
- Accessing any dashboard route redirects back to sign-in

---

## Build Validation

```bash
npm run build
```

**Expected**: Build completes with zero TypeScript errors and zero ESLint errors.

---

## References

- Data model: [data-model.md](./data-model.md)
- Route contracts: [contracts/routes.md](./contracts/routes.md)
- Component contracts: [contracts/components.md](./contracts/components.md)
