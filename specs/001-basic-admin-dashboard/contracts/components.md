# Component Contracts: Basic Admin Dashboard (Makani)

**Date**: 2026-06-26 | **Plan**: [plan.md](../plan.md)

Key component interfaces. These are the boundaries between the presentation layer and the application layer hooks.

---

## AdminGuard

**File**: `src/presentation/guards/admin-guard.tsx`

**Purpose**: Wraps dashboard route groups. Reads auth state and Firestore `isAdmin`; renders children or redirects.

```typescript
interface AdminGuardProps {
  children: React.ReactNode;
}
```

**Behavior**:
- While checking auth state: renders a full-screen loading indicator
- If no authenticated user: redirects to `/[locale]/sign-in`
- If authenticated but `isAdmin !== true`: redirects to `/[locale]/sign-in?reason=unauthorized`
- If authenticated and `isAdmin === true`: renders `children`

---

## StatsGrid

**File**: `src/presentation/components/overview/stats-grid.tsx`

**Purpose**: Renders the four stat cards on the overview page.

```typescript
interface StatsGridProps {
  stats: OverviewStats | undefined;
  isLoading: boolean;
  isError: boolean;
  onRetry: () => void;
}
```

**Behavior**:
- `isLoading`: shows skeleton placeholders for each card
- `isError`: shows error banner with `onRetry` trigger
- `stats === undefined` after load: shows all counts as `0`
- Normal: renders four `StatCard` components

---

## StatCard

**File**: `src/presentation/components/ui/stat-card.tsx`

```typescript
interface StatCardProps {
  label: string;       // translated label
  value: number;
  isLoading?: boolean;
}
```

---

## ListingsTable

**File**: `src/presentation/components/listings/listings-table.tsx`

```typescript
interface ListingsTableProps {
  listings: Listing[];
  isLoading: boolean;
  isError: boolean;
  onRetry: () => void;
  onToggleStatus: (listingId: string, currentStatus: string) => void;
  hasNextPage: boolean;
  hasPreviousPage: boolean;
  onNextPage: () => void;
  onPreviousPage: () => void;
}
```

**Behavior**:
- `isLoading`: renders skeleton rows
- `isError`: renders error banner with retry
- Empty listings array: renders empty-state message
- Each row has a `StatusToggle` for the listing

---

## StatusToggle

**File**: `src/presentation/components/listings/status-toggle.tsx`

```typescript
interface StatusToggleProps {
  listingId: string;
  currentStatus: string;       // 'active' | 'inactive'
  onToggle: (id: string, status: string) => void;
  isUpdating: boolean;
}
```

**Behavior**:
- Renders a toggle switch reflecting `currentStatus`
- On click: calls `onToggle`; disables itself while `isUpdating`
- Parent is responsible for the undo toast — this component only triggers the action

---

## ReportsTable

**File**: `src/presentation/components/reports/reports-table.tsx`

```typescript
interface ReportsTableProps {
  reports: Report[];
  isLoading: boolean;
  isError: boolean;
  onRetry: () => void;
  onMarkReviewed: (reportId: string) => void;
  hasNextPage: boolean;
  hasPreviousPage: boolean;
  onNextPage: () => void;
  onPreviousPage: () => void;
}
```

**Behavior**:
- Pending reports show "Mark Reviewed" button
- Reviewed reports show "Reviewed" badge; button hidden
- Reason text truncated to 80 characters with title tooltip for full text

---

## SignInForm

**File**: `src/presentation/components/auth/sign-in-form.tsx`

```typescript
interface SignInFormProps {
  onEmailSignIn: (email: string, password: string) => Promise<void>;
  onGoogleSignIn: () => Promise<void>;
  isLoading: boolean;
  error: string | null;
}
```

**Behavior**:
- Email + password fields with basic validation
- Google sign-in button triggers OAuth popup
- `error` prop renders inline error message below form
- Submit/Google buttons disabled while `isLoading`

---

## TopNav (Language Toggle)

**File**: `src/presentation/components/layout/top-nav.tsx`

```typescript
interface TopNavProps {
  currentLocale: 'en' | 'ar';
  adminName: string;
  onSignOut: () => void;
  onLocaleChange: (locale: 'en' | 'ar') => void;
}
```

**Behavior**:
- Language toggle switches between `en` and `ar`; navigates to same path under new locale prefix and writes to `localStorage`
- Sign out button calls `onSignOut`

---

## AppShell

**File**: `src/presentation/components/layout/app-shell.tsx`

```typescript
interface AppShellProps {
  children: React.ReactNode;
  currentLocale: 'en' | 'ar';
  adminName: string;
}
```

**Behavior**:
- Renders `Sidebar` (navigation links) + `TopNav` + `main` content area
- `dir` attribute on root element is derived from locale: `ar` → `rtl`, `en` → `ltr`
- Sidebar links: Overview, Listings, Reports
