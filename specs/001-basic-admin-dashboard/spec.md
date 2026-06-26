# Feature Specification: Basic Admin Dashboard (Makani)

**Feature Branch**: `001-basic-admin-dashboard`

**Created**: 2026-06-26

**Status**: Draft

**Input**: User description: "i want basic dashboard using next js, ts, and take auth system of firebase that in app but in D:\makani_app-main\dashborad clean arc please and transition in18"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Admin Authentication (Priority: P1)

A platform administrator navigates to the dashboard portal and signs in using their existing Makani Firebase account credentials (email/password or Google). Once authenticated, they are redirected to the main overview screen. If they are not an admin user, access is denied with a clear message. On subsequent visits, valid sessions are restored automatically without requiring re-login.

**Why this priority**: Without authentication, no part of the dashboard is accessible. All other stories depend on this working first.

**Independent Test**: Can be fully tested by visiting the login page, entering admin credentials, and confirming the dashboard loads — or confirming access is denied for non-admin credentials.

**Acceptance Scenarios**:

1. **Given** an unauthenticated user visits the dashboard URL, **When** the page loads, **Then** they are redirected to the sign-in page.
2. **Given** a user enters valid admin email and password, **When** they submit the form, **Then** they are redirected to the overview page.
3. **Given** a user signs in with Google using an admin-linked account, **When** authentication succeeds, **Then** they are redirected to the overview page.
4. **Given** a signed-in user reloads the page, **When** their session token is still valid, **Then** they remain on the dashboard without re-authenticating.
5. **Given** an authenticated user with no admin role, **When** they access the dashboard, **Then** they see an "Access Denied" message and cannot view dashboard content.
6. **Given** a signed-in admin, **When** they click "Sign Out", **Then** they are redirected to the sign-in page and the session is cleared.

---

### User Story 2 - Overview Statistics Screen (Priority: P2)

A signed-in admin opens the dashboard and immediately sees a summary of key platform metrics: total number of registered users, active property listings, pending reports, and recent bookings. Each metric is displayed as a card. The admin can understand the platform's health at a glance without navigating elsewhere.

**Why this priority**: The overview is the landing page after login — it provides immediate platform health visibility and is the anchor screen for all navigation.

**Independent Test**: Can be tested by verifying that summary stat cards are displayed after login with accurate counts sourced from the platform's data store.

**Acceptance Scenarios**:

1. **Given** a signed-in admin is on the overview page, **When** the page loads, **Then** they see cards showing: total users, active listings, pending reports, and total bookings.
2. **Given** new data has been added to the platform, **When** the admin refreshes the overview, **Then** the stat cards reflect the updated values.
3. **Given** the overview is displayed, **When** the admin views the page in Arabic, **Then** all labels and numbers are shown in the selected language with proper RTL layout.

---

### User Story 3 - Property Listings Management (Priority: P3)

A signed-in admin navigates to the Listings section and sees a paginated list of all property listings. Each row shows the listing title, owner name, status (active/inactive), and creation date. The admin can toggle a listing's status between active and inactive and see the change reflected immediately.

**Why this priority**: Property moderation is the core admin responsibility — it directly affects what students see in the app.

**Independent Test**: Can be tested by loading the listings page, verifying the list renders with correct data, toggling one listing's status, and confirming the change persists.

**Acceptance Scenarios**:

1. **Given** a signed-in admin opens the Listings page, **When** the page loads, **Then** a paginated list of listings is shown with title, owner, status, and date.
2. **Given** a listing is active, **When** the admin toggles its status, **Then** the listing becomes inactive immediately and a toast notification appears with an undo option for approximately 5 seconds.
3. **Given** a listing is inactive, **When** the admin toggles its status, **Then** the listing becomes active immediately with the same undo toast.
4. **Given** a toggle undo toast is visible, **When** the admin clicks undo within the time window, **Then** the listing status reverts to its previous state.
4. **Given** there are more listings than fit one page, **When** the admin navigates to the next page, **Then** the next batch of listings is shown.

---

### User Story 4 - User Reports Management (Priority: P4)

A signed-in admin navigates to the Reports section and sees a list of user-submitted reports, each showing the reported listing title, the reporting user, the report reason, and the report date. The admin can mark a report as reviewed to track which reports have been handled.

**Why this priority**: Report management is essential for platform trust and safety, but it depends on listings management being in place first.

**Independent Test**: Can be tested by loading the Reports page and verifying report entries appear with relevant metadata, and that marking a report as reviewed updates its state.

**Acceptance Scenarios**:

1. **Given** a signed-in admin opens the Reports page, **When** the page loads, **Then** a list of reports is shown with listing title, reporter, reason, and date.
2. **Given** a report is pending review, **When** the admin marks it as reviewed, **Then** its status updates to "Reviewed" immediately.
3. **Given** no reports exist, **When** the admin opens the Reports page, **Then** an empty-state message is displayed.

---

### User Story 5 - Language Switching (Arabic / English) (Priority: P5)

A signed-in admin can switch the dashboard language between English and Arabic at any time using a language toggle in the navigation bar. When Arabic is selected, the entire UI — including labels, table headers, messages, and navigation — renders in Arabic with proper right-to-left text direction. When English is selected, the layout reverts to left-to-right.

**Why this priority**: Bilingual support is a baseline requirement to match the mobile app's user base and operator expectations.

**Independent Test**: Can be tested by switching to Arabic and verifying all static text changes to Arabic and the layout direction flips to RTL.

**Acceptance Scenarios**:

1. **Given** the dashboard is in English, **When** the admin selects Arabic from the language toggle, **Then** all labels switch to Arabic and the layout direction becomes RTL.
2. **Given** the dashboard is in Arabic, **When** the admin selects English, **Then** all labels switch to English and the layout direction becomes LTR.
3. **Given** a language is selected, **When** the admin navigates to a different page, **Then** the selected language persists across navigation.

---

### Edge Cases

- What happens when the Firebase backend is unreachable and stats cannot be loaded?
- How does the listing toggle behave if the Firestore write fails (network error)?
- What does the admin see if their account is deleted mid-session?
- How are very long listing titles or report reasons truncated in the table?
- What happens when an admin's session token expires while they are actively using the dashboard?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST restrict dashboard access to authenticated users whose Firestore user record includes a designated admin role indicator (field or dedicated document). Access enforcement is client-side route protection only; Firestore security rules are not modified in v1.
- **FR-002**: System MUST support sign-in via email/password using the existing Makani Firebase project.
- **FR-003**: System MUST support sign-in via Google using the existing Makani Firebase project.
- **FR-004**: System MUST display a summary statistics overview showing total users, active listings, pending reports, and total bookings — sourced from a pre-aggregated Firestore counter document (e.g., `/stats/overview`) updated by the app.
- **FR-005**: System MUST display a paginated list of all property listings with title, owner, status, and creation date.
- **FR-006**: System MUST allow admins to toggle individual listing status between active and inactive immediately on click, with a toast notification providing an undo option for approximately 5 seconds after each toggle.
- **FR-007**: System MUST display a list of user-submitted reports with listing title, reporter, reason, and date.
- **FR-008**: System MUST allow admins to mark individual reports as reviewed.
- **FR-009**: System MUST support full UI translation in English and Arabic.
- **FR-010**: System MUST render in RTL layout when Arabic is selected and LTR when English is selected.
- **FR-011**: System MUST persist the selected language using browser local storage so the preference survives page refreshes and new tabs on the same browser.
- **FR-012**: System MUST automatically restore a valid admin session on page reload without requiring re-login.
- **FR-013**: System MUST provide a sign-out action that clears the session and redirects to the sign-in page.
- **FR-014**: System MUST display meaningful empty-state messages when data lists are empty.
- **FR-015**: System MUST display error feedback when data loading or write operations fail.

### Key Entities

- **Admin User**: A platform user with the admin role; identified by Firebase UID; has access to all dashboard sections.
- **Property Listing**: A rental property posted by an owner; has a title, owner reference, status (active/inactive), creation date, and associated metadata.
- **User Report**: A complaint submitted by a user against a listing; has a reported listing reference, reporting user reference, reason text, submission date, and reviewed status.
- **Platform Statistics**: Aggregated counts of users, active listings, pending reports, and bookings — computed from Firestore collections.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Admin authentication completes (sign-in to dashboard visible) in under 3 seconds on a standard connection.
- **SC-002**: Non-admin users are blocked from accessing any dashboard page 100% of the time.
- **SC-003**: Overview stats cards load within 2 seconds of the overview page opening.
- **SC-004**: Listing status toggles are reflected in the UI within 1 second of the admin's action.
- **SC-005**: All dashboard pages render correctly in both English and Arabic, with no untranslated strings visible to the user.
- **SC-006**: RTL layout is applied correctly to 100% of page elements when Arabic is selected.
- **SC-007**: Language preference persists for the full duration of the admin session across all dashboard pages.
- **SC-008**: Dashboard is fully navigable on screens 1280px wide and above.

## Assumptions

- The existing Firebase project (`makani-99af9`) is used as-is; no new Firebase project will be created.
- Admin role is determined by a Firestore document — either a `role` field on the `/users/{uid}` document or a dedicated `/admins/{uid}` document. Custom claims are not used.
- The dashboard is a web-only application; mobile responsiveness beyond 1280px is out of scope for v1.
- The two supported languages are English and Arabic; no additional locales are required for v1.
- Overview statistics (users, listings, reports, bookings counts) are read from a pre-aggregated Firestore counter document rather than full collection scans. If this document does not yet exist in the Makani project, creating it is in scope for this dashboard's setup.
- The dashboard codebase lives in `D:\makani_app-main\dashborad` (separate from the Flutter app) and is a standalone Next.js project.
- Clean architecture means the code is organized by domain layer (presentation, application, domain, infrastructure) rather than by file type.
- No new payment or booking creation features are required in the dashboard for v1; those are read-only.

## Clarifications

### Session 2026-06-26

- Q: How is an admin user identified in the existing Firebase project? → A: Firestore document — field on the user document or a dedicated `admins` collection (not custom claims).
- Q: How should the overview statistics counts be retrieved? → A: Pre-aggregated counter document in Firestore (e.g., `/stats/overview`), not real-time collection scans.
- Q: How should the selected language preference be stored? → A: Browser localStorage — persists across refreshes and new tabs.
- Q: Should Firestore security rules enforce admin-only access server-side? → A: No — client-side route protection only for v1; Firestore rules remain unchanged.
- Q: Should toggling a listing's status require a confirmation prompt? → A: No confirmation — toggle applies immediately with a ~5-second undo toast notification.
