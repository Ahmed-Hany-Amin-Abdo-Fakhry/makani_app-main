# Data Model: Basic Admin Dashboard (Makani)

**Date**: 2026-06-26 | **Plan**: [plan.md](./plan.md)

All entities are read from the existing Makani Firebase project (`makani-99af9`). Field names match the Firestore documents in the live app (verified from Flutter source).

---

## Entity: AdminUser

**Source**: Firestore `users/{uid}` document + Firebase Auth current user

```typescript
interface AdminUser {
  uid: string;           // Firebase Auth UID — document ID
  fullName: string;      // from Firestore users/{uid}.fullName
  email: string;         // from Firestore users/{uid}.email
  isAdmin: boolean;      // new field — added to admin user docs manually
  provider: string;      // 'password' | 'google'
  photoBase64?: string;  // optional profile photo
}
```

**State transitions**: none (read-only in dashboard)

**Validation rules**:
- `isAdmin` must be explicitly `true`; absent field or `false` denies dashboard access
- `uid` must match `FirebaseAuth.currentUser.uid`

---

## Entity: Listing

**Source**: Firestore `listings/{id}` collection

```typescript
interface Listing {
  id: string;                // Firestore document ID
  ownerId: string;           // Firebase Auth UID of the owner
  propertyTypeKey: string;   // e.g. 'apartment', 'room', 'studio'
  genderPreferenceKey: string; // e.g. 'male', 'female', 'any'
  governorate?: string;
  district?: string;
  addressLine?: string;
  monthlyRent?: number;
  totalBeds?: number;
  status?: string;           // 'active' | 'inactive' | null (null treated as inactive)
  createdAt?: Date;
  imageUrls: string[];
}
```

**State transitions**:
```
inactive ──[admin toggle]──► active
active   ──[admin toggle]──► inactive
(undo within ~5 seconds reverts the toggle)
```

**Validation rules**:
- Dashboard only writes `status` field; all other fields are read-only
- Valid `status` values: `'active'` | `'inactive'`
- `createdAt` is a Firestore Timestamp — converted to JS `Date` by the infrastructure layer

**Dashboard-read fields** (subset used in listings table):
`id`, `propertyTypeKey`, `ownerId`, `status`, `createdAt`, `governorate`, `district`, `monthlyRent`

---

## Entity: Report

**Source**: Firestore `listingReports/{id}` collection

```typescript
interface Report {
  id: string;          // Firestore document ID
  listingId: string;   // reference to listings/{id}
  reporterUid: string; // Firebase Auth UID of the reporting user
  ownerId: string;     // Firebase Auth UID of the listing owner
  reason: string;      // free-text reason provided by reporter
  status: string;      // 'pending' | 'reviewed'
  createdAt?: Date;
  updatedAt?: Date;
}
```

**State transitions**:
```
pending ──[admin marks reviewed]──► reviewed
(no undo — reviewed is a terminal state)
```

**Validation rules**:
- Dashboard only writes `status` field and `updatedAt` timestamp
- New status must be `'reviewed'`; `'pending'` is the only valid initial state written by the app

---

## Entity: OverviewStats

**Source**: Firestore `stats/overview` document (single document)

```typescript
interface OverviewStats {
  totalUsers: number;
  activeListings: number;
  pendingReports: number;
  totalBookings: number;
  updatedAt?: Date;
}
```

**State transitions**: none (read-only; maintained by app + setup script)

**Validation rules**:
- All count fields default to `0` if absent (document may not exist on first load)
- Dashboard never writes to this document

---

## Firestore Collection Map

```
makani-99af9 (Firebase project)
│
├── users/
│   └── {uid}/                    ← AdminUser source
│       ├── fullName: string
│       ├── email: string
│       ├── isAdmin: boolean      ← NEW field (admin docs only)
│       ├── provider: string
│       ├── createdAt: Timestamp
│       └── updatedAt: Timestamp
│
├── listings/
│   └── {id}/                     ← Listing source
│       ├── ownerId: string
│       ├── propertyTypeKey: string
│       ├── genderPreferenceKey: string
│       ├── status: string        ← dashboard writes this
│       ├── createdAt: Timestamp
│       └── ... (other fields read-only)
│
├── listingReports/
│   └── {id}/                     ← Report source
│       ├── listingId: string
│       ├── reporterUid: string
│       ├── ownerId: string
│       ├── reason: string
│       ├── status: string        ← dashboard writes this ('reviewed')
│       ├── createdAt: Timestamp
│       └── updatedAt: Timestamp
│
└── stats/
    └── overview                  ← OverviewStats source (new document)
        ├── totalUsers: number
        ├── activeListings: number
        ├── pendingReports: number
        ├── totalBookings: number
        └── updatedAt: Timestamp
```

---

## i18n Message Keys (Canonical Structure)

```json
{
  "auth": {
    "signIn": "...",
    "signInWithGoogle": "...",
    "signOut": "...",
    "emailLabel": "...",
    "passwordLabel": "...",
    "accessDenied": "..."
  },
  "nav": {
    "overview": "...",
    "listings": "...",
    "reports": "..."
  },
  "overview": {
    "totalUsers": "...",
    "activeListings": "...",
    "pendingReports": "...",
    "totalBookings": "..."
  },
  "listings": {
    "title": "...",
    "columns": {
      "property": "...",
      "owner": "...",
      "status": "...",
      "date": "..."
    },
    "status": {
      "active": "...",
      "inactive": "..."
    },
    "toggleUndo": "...",
    "empty": "..."
  },
  "reports": {
    "title": "...",
    "columns": {
      "listing": "...",
      "reporter": "...",
      "reason": "...",
      "date": "...",
      "status": "..."
    },
    "status": {
      "pending": "...",
      "reviewed": "..."
    },
    "markReviewed": "...",
    "empty": "..."
  },
  "common": {
    "loading": "...",
    "error": "...",
    "retry": "...",
    "undo": "...",
    "previous": "...",
    "next": "..."
  }
}
```
