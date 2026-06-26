# Implementation Plan: Basic Admin Dashboard (Makani)

**Branch**: `001-basic-admin-dashboard` | **Date**: 2026-06-26 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/001-basic-admin-dashboard/spec.md`

## Summary

Build a standalone Next.js + TypeScript admin web application located at `dashborad/` that connects to the existing Makani Firebase project (`makani-99af9`). Admins authenticate via Firebase Auth (email/password or Google), and the app enforces access by reading an `isAdmin` field from the `users/{uid}` Firestore document. The dashboard provides four screens: overview stats (from a pre-aggregated `/stats/overview` Firestore document), paginated listings management with immediate-undo status toggles, report review, and bilingual (Arabic RTL / English LTR) support via `next-intl` with `localStorage` persistence.

## Technical Context

**Language/Version**: TypeScript 5.x — Node.js 20 LTS

**Primary Dependencies**:
- `next` 14 (App Router, `[locale]` dynamic segment via `next-intl`)
- `firebase` v10 (JS SDK — Auth + Firestore)
- `next-intl` 3.x (i18n routing, server + client components, RTL-aware)
- `@tanstack/react-query` 5 (server-state caching for Firestore reads)
- `tailwindcss` 3 + `tailwindcss-rtl` plugin (RTL layout via CSS logical properties)
- `sonner` (toast notifications for undo actions)
- `shadcn/ui` (accessible headless UI primitives — Button, Badge, Table, Toggle)

**Storage**: Firestore (project `makani-99af9`)
- Collections read: `users`, `listings`, `listingReports`
- Counter document: `stats/overview` (must be created if absent)
- Admin role field: `users/{uid}.isAdmin: boolean`

**Testing**: Jest + React Testing Library (unit/component); Playwright (e2e flows)

**Target Platform**: Web browser — desktop-first at 1280px minimum width

**Project Type**: Web application (standalone Next.js admin dashboard)

**Performance Goals**:
- Sign-in to dashboard visible: < 3 seconds
- Overview stats cards loaded: < 2 seconds
- Listing status toggle reflected in UI: < 1 second

**Constraints**:
- Admin role enforcement is client-side only (v1); no Firestore security rule changes
- No Firestore collection scans for stats — reads from pre-aggregated counter document only
- Language preference stored in `localStorage`; no server-side locale detection
- Dashboard is web-only; mobile layout (< 1280px) is out of scope for v1

**Scale/Scope**: Small number of admin users; listings paginated at 20 per page; reports paginated at 20 per page

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

The project constitution is a template (not yet ratified with project-specific principles). No governance gates apply. This plan proceeds without constitution violations.

## Project Structure

### Documentation (this feature)

```text
specs/001-basic-admin-dashboard/
├── plan.md              # This file
├── research.md          # Phase 0: tech decisions
├── data-model.md        # Phase 1: Firestore entities
├── quickstart.md        # Phase 1: validation guide
├── contracts/           # Phase 1: route + component contracts
│   ├── routes.md
│   └── components.md
└── tasks.md             # Phase 2 output (/speckit-tasks — not created here)
```

### Source Code (repository root)

```text
dashborad/                          # standalone Next.js project root
├── src/
│   ├── app/
│   │   ├── [locale]/               # next-intl locale dynamic segment
│   │   │   ├── (auth)/             # unauthenticated route group
│   │   │   │   └── sign-in/
│   │   │   │       └── page.tsx
│   │   │   ├── (dashboard)/        # authenticated route group
│   │   │   │   ├── layout.tsx      # admin-guard + app-shell
│   │   │   │   ├── overview/
│   │   │   │   │   └── page.tsx
│   │   │   │   ├── listings/
│   │   │   │   │   └── page.tsx
│   │   │   │   └── reports/
│   │   │   │       └── page.tsx
│   │   │   └── layout.tsx          # next-intl NextIntlClientProvider
│   │   ├── globals.css
│   │   └── layout.tsx              # root layout (html lang + dir)
│   ├── domain/
│   │   ├── entities/               # pure TypeScript types — no Firebase imports
│   │   │   ├── admin-user.ts
│   │   │   ├── listing.ts
│   │   │   ├── report.ts
│   │   │   └── stats.ts
│   │   ├── repositories/           # repository interfaces (abstractions)
│   │   │   ├── auth-repository.ts
│   │   │   ├── listing-repository.ts
│   │   │   ├── report-repository.ts
│   │   │   └── stats-repository.ts
│   │   └── use-cases/              # business logic — depends only on domain
│   │       ├── auth/
│   │       │   ├── sign-in-email.ts
│   │       │   ├── sign-in-google.ts
│   │       │   └── sign-out.ts
│   │       ├── listings/
│   │       │   ├── get-paginated-listings.ts
│   │       │   └── toggle-listing-status.ts
│   │       ├── reports/
│   │       │   ├── get-reports.ts
│   │       │   └── mark-report-reviewed.ts
│   │       └── stats/
│   │           └── get-overview-stats.ts
│   ├── application/
│   │   ├── hooks/                  # React Query hooks — depend on domain interfaces
│   │   │   ├── use-auth.ts
│   │   │   ├── use-listings.ts
│   │   │   ├── use-reports.ts
│   │   │   └── use-stats.ts
│   │   └── providers/
│   │       ├── auth-provider.tsx   # Firebase auth state → React context
│   │       ├── di-provider.tsx     # dependency injection — binds interfaces to implementations
│   │       └── query-provider.tsx  # TanStack Query client
│   ├── infrastructure/
│   │   ├── firebase/
│   │   │   ├── app.ts              # Firebase app init (singleton)
│   │   │   └── collections.ts      # typed collection references
│   │   └── repositories/           # Firebase concrete implementations
│   │       ├── firebase-auth-repository.ts
│   │       ├── firebase-listing-repository.ts
│   │       ├── firebase-report-repository.ts
│   │       └── firebase-stats-repository.ts
│   ├── presentation/
│   │   ├── components/
│   │   │   ├── ui/                 # reusable atoms (shadcn/ui wrappers)
│   │   │   │   ├── button.tsx
│   │   │   │   ├── badge.tsx
│   │   │   │   ├── stat-card.tsx
│   │   │   │   └── data-table.tsx
│   │   │   ├── layout/
│   │   │   │   ├── app-shell.tsx
│   │   │   │   ├── sidebar.tsx
│   │   │   │   └── top-nav.tsx
│   │   │   ├── auth/
│   │   │   │   └── sign-in-form.tsx
│   │   │   ├── overview/
│   │   │   │   └── stats-grid.tsx
│   │   │   ├── listings/
│   │   │   │   ├── listings-table.tsx
│   │   │   │   └── status-toggle.tsx
│   │   │   └── reports/
│   │   │       └── reports-table.tsx
│   │   └── guards/
│   │       └── admin-guard.tsx     # reads Firestore isAdmin; redirects if false
│   └── i18n/
│       ├── routing.ts              # next-intl defineRouting({ locales, defaultLocale })
│       ├── config.ts               # locale → direction map
│       └── messages/
│           ├── en.json
│           └── ar.json
├── public/
├── middleware.ts                   # next-intl locale middleware
├── next.config.ts
├── tailwind.config.ts
├── tsconfig.json
└── package.json
```

**Structure Decision**: Single Next.js project with strict Clean Architecture layering. The `domain/` layer has zero framework imports — only TypeScript. `infrastructure/` implements domain interfaces using Firebase. `application/` wires them together via React context + TanStack Query. `presentation/` contains only React components that consume application hooks. The `app/` directory is the Next.js routing layer only (thin pages that delegate to presentation components).

## Complexity Tracking

> No Constitution violations to justify.
