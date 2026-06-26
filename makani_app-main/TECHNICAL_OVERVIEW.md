# Makani App - Complete Technical Overview

**Project Name:** Makani (ﻣﻜﺎﻧﻲ - Arabic: "My Place")  
**Application Type:** Property Rental Mobile Application  
**Platform:** Cross-platform Flutter (Android, iOS, Web)  
**Backend:** Firebase (Authentication, Firestore, Storage)  

---

## 1. PROJECT PURPOSE AND IDEA

### Vision
Makani is a university student-focused property rental platform that bridges the gap between property owners and students seeking accommodation near their educational institutions. The application streamlines the property discovery, listing, booking, and payment process.

### Key Objectives
- **Enable student accommodation discovery**: Search and filter rental properties based on location, price, and amenities
- **Simplify property listing**: Allow property owners to quickly publish and manage their listings
- **Facilitate transactions**: Integrate payment processing for secure rental transactions
- **Build community trust**: Implement rating and review systems for properties and users
- **Optimize location-based search**: Use geolocation to recommend properties based on student location and preferred study fields

### Target Users
- **Students**: Looking for off-campus/on-campus accommodation
- **Property Owners**: Seeking to rent properties to student tenants
- **Admin Users**: Managing reports, content moderation, and system administration

---

## 2. MAIN FEATURES AND FUNCTIONALITIES

### Core Features

| Feature | Description |
|---------|-------------|
| **Authentication** | Email/password login, Google Sign-In, OTP verification, password reset |
| **Property Listings** | Browse active property listings with filtering and search capabilities |
| **Advanced Search & Filter** | Filter by rent range, location, beds, amenities, property type, gender preference, study fields |
| **Property Recommendations** | Algorithm-based recommendations on home page and dedicated recommendation section |
| **Property Details** | Comprehensive property information: amenities, images, videos, owner contact, location map |
| **Add/Edit Listings** | Multi-step form to create and modify property listings with media upload |
| **Media Management** | Upload multiple images and videos with automatic compression and Cloudinary storage |
| **Favorites** | Save favorite properties for later viewing |
| **My Ads** | Manage owned listings: create, edit, view statistics |
| **Booking System** | Reserve/book properties with transaction history |
| **Payments** | Integrate MyFatoorah payment gateway for secure transactions |
| **Ratings & Reviews** | Rate and review properties; view owner and property ratings |
| **Location Services** | GPS-based location detection, reverse geocoding, map integration |
| **Reporting** | Report inappropriate or fraudulent listings to admin |
| **User Profile** | Manage personal information, phone number, profile photo |
| **Multilingual Support** | Arabic and English language support with dynamic switching |

---

## 3. USER ROLES AND PERMISSIONS

### Role Hierarchy

#### **Guest User**
- **Permissions**: View home feed, search/filter listings, view property details
- **Restrictions**: Cannot save favorites, create listings, book, or submit reviews

#### **Authenticated User (Student/Tenant)**
- **Permissions**: 
  - All guest permissions
  - Save and manage favorites
  - Create and manage property listings (as owner)
  - Book properties
  - Submit ratings and reviews
  - Access booking history
  - Update profile information
- **Restrictions**: Cannot delete other users' listings or modify system settings

#### **Property Owner**
- **Permissions**: 
  - Create multiple property listings
  - Edit own listings
  - View listing statistics (views, inquiries)
  - Manage availability and pricing
  - Respond to booking requests
  - Receive and manage reviews
- **Restrictions**: Cannot access other owners' data

#### **Admin User**
- **Permissions**: 
  - View and moderate all listings (mark as active/inactive)
  - Manage user reports
  - Delete fraudulent listings
  - Access system statistics
  - Override user data when necessary
- **Restrictions**: Cannot directly modify user personal data without audit trail

---

## 4. APPLICATION WORKFLOW FROM USER PERSPECTIVE

### User Journey Map

#### **First-Time User Flow**
```
App Launch
    ↓
[Not Authenticated] → Splash/Login Screen
    ↓
Login Options: Email/Password or Google Sign-In
    ↓
Create Account (Sign Up) or Login
    ↓
Verify Email (OTP if needed)
    ↓
Complete Profile (Name, Phone, Photo)
    ↓
[Authenticated] → Home Screen
```

#### **Property Discovery Flow**
```
Home Screen (Feed)
    ↓
[Browse Listings] or [Use Filter]
    ↓
Apply Filters: Location, Price, Beds, Amenities, Gender, Study Field
    ↓
View Recommended Properties
    ↓
Tap Property → Property Detail Screen
    ↓
View: Images, Video, Amenities, Map, Owner Contact, Reviews
    ↓
Options: Save to Favorites, Share, Report, Book, Rate
```

#### **Property Listing Creation Flow**
```
Home/Sell Tab → Add New Listing
    ↓
Step 1: Select Property Type (Single Bed, Private Room, Apartment, Studio)
    ↓
Step 2: Set Gender Preference (Male, Female, Any)
    ↓
Step 3: Select Study Fields (optional, for targeting)
    ↓
Step 4: Location Details (Governorate, District, Address, Map Pin)
    ↓
Step 5: Property Details (Beds, Bathrooms, Rent, Utilities, Amenities)
    ↓
Step 6: Upload Images & Video
    ↓
Step 7: Verify & Publish
    ↓
Listing Active on Platform
```

#### **Booking & Payment Flow**
```
View Property Detail
    ↓
Tap "Book Now" Button
    ↓
Booking Screen (Confirm Property, Dates, Terms)
    ↓
Proceed to Payment
    ↓
MyFatoorah Payment Gateway
    ↓
[Payment Success] → Booking Confirmation
    ↓
Add to Booking History
    ↓
Owner Notified of Booking
```

#### **Rating & Review Flow**
```
After Booking Completion
    ↓
Notification: "Rate Your Experience"
    ↓
Rate Property (1-5 Stars)
    ↓
Write Review (Optional)
    ↓
Submit Review
    ↓
Property Rating Updated (Average Calculation)
    ↓
Review Visible to Other Users
```

---

## 5. ARCHITECTURE PATTERN USED

### Architecture Style: **Clean Architecture + Feature-Driven Design**

```
┌─────────────────────────────────────────────┐
│           PRESENTATION LAYER (UI)            │
│  Screens, Widgets, BlocListener, BlocBuilder│
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│      STATE MANAGEMENT LAYER (BLoC/Cubit)    │
│  Cubits, State Classes, Event Handling      │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│      REPOSITORY PATTERN (Data Abstraction)   │
│  Repository Interfaces & Implementations    │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│        SERVICES LAYER (Business Logic)       │
│ Firebase, Cloudinary, API Calls, Compression│
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│      EXTERNAL SERVICES & DATA SOURCES        │
│ Firebase, APIs, Local Storage, Databases    │
└─────────────────────────────────────────────┘
```

### Key Principles
1. **Separation of Concerns**: Each layer has a distinct responsibility
2. **Dependency Injection**: Dependencies injected via BLoC providers
3. **Feature Modularity**: Features are self-contained packages
4. **Testability**: Repository pattern enables easy mocking and testing
5. **Reusability**: Shared services and utilities in Core layer

### Layer Responsibilities

| Layer | Role |
|-------|------|
| **Presentation** | Display UI, handle user interactions, observe state changes |
| **State Management** | Manage business logic, handle events, emit states |
| **Repository** | Abstract data sources, provide clean API to cubits |
| **Services** | Implement Firebase queries, API calls, business computations |
| **Data Sources** | Raw data access (Firebase, APIs, Local storage) |

---

## 6. STATE MANAGEMENT APPROACH

### Framework: **Flutter BLoC Library (Cubit + Bloc)**

**Cubit** is the primary state management pattern used (simpler than full Bloc).

### Global State Management

#### **AuthCubit** (lib/Features/Auth/Cubit/auth_cubit.dart)
- **Responsibility**: Manages user authentication state
- **States**: 
  - `AuthInitial`: Initial state
  - `AuthLoading`: During login/signup
  - `AuthError`: Authentication failed
  - `AuthUnauthenticated`: User not logged in
  - `AuthAuthenticated`: User logged in (with UserProfile data)
  - `AuthOtpSent`, `AuthPasswordResetSuccess`: Intermediate states
- **Features**:
  - Monitors Firebase auth state changes
  - Listens to UID stream and loads user profile
  - Handles email/password login, Google Sign-In, signup, password reset
  - Auto-redirects unauthenticated users to login

#### **LanguageCubit** (lib/Core/Cubit/language_cubit.dart)
- **Responsibility**: Manages app language (i18n)
- **States**: `Locale` (English or Arabic)
- **Features**: Global language switching affects all screens

#### **FavoritesCubit** (lib/Features/Favorites/Cubit/favorites_cubit.dart)
- **Responsibility**: Manages user's favorite listings
- **States**: 
  - `FavoritesInitial`: Initial
  - `FavoritesLoading`: Loading from Firestore
  - `FavoritesLoaded`: Favorites loaded
  - `FavoritesFailure`: Error occurred
- **Features**: 
  - Maintains set of favorite listing IDs
  - Provides `isFavorited(id)` method for quick lookup
  - Auto-refreshes on auth state change

### Feature-Specific State Management

#### **HomeCubit**
- **States**: `HomeInitial`, `HomeLoading`, `HomeLoaded`, `HomeFailure`
- **Responsibility**: Fetch and filter listings, manage recommendations
- **Features**: Search, filter application, real-time filtering

#### **AddAdCubit**
- **States**: `AddAdState` (mutable state)
- **Responsibility**: Manage multi-step property listing form
- **Features**: 
  - Validate form fields
  - Handle media selection and compression
  - Manage draft state across steps
  - Geolocation integration

#### **PropertyDetailCubit**
- **States**: `PropertyDetailLoading`, `PropertyDetailLoaded`, `PropertyDetailError`
- **Responsibility**: Fetch and display detailed property information
- **Features**: Load single listing by ID, handle user reviews

### State Pattern

```dart
// Example: HomeCubit State Hierarchy
sealed class HomeState {}
class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeLoaded extends HomeState {
  final List<PropertyListing> items;
  final List<HomeRecommendation> recommendations;
}
class HomeFailure extends HomeState {
  final String message;
}
```

### Dependency Injection

**MultiRepositoryProvider** in `main.dart` provides repositories globally:
```dart
MultiRepositoryProvider(
  providers: [
    RepositoryProvider(create: (_) => CurrentLocationService()),
    RepositoryProvider(create: (c) => AddPropertyRepositoryImpl(...)),
    // More providers...
  ],
)

MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => AuthCubit()),
    BlocProvider(create: (_) => LanguageCubit()),
    // More cubits...
  ],
)
```

---

## 7. DATABASE STRUCTURE AND FIREBASE USAGE

### Firebase Services Used

| Service | Purpose |
|---------|---------|
| **Firebase Authentication** | User login, signup, password reset, Google Sign-In |
| **Cloud Firestore** | Persistent data storage (listings, profiles, bookings, etc.) |
| **Firebase Storage** | Store profile photos, property images, videos (via Cloudinary redirect) |
| **Firebase Security Rules** | Control read/write access to data |

### Firestore Collection Structure

```
firestore_root
├── users/
│   └── {uid}
│       ├── fullName: string
│       ├── email: string
│       ├── phone: string (optional)
│       ├── photoBase64: string (optional)
│       ├── provider: string ("google" | "password")
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── listings/
│   └── {listingId}
│       ├── ownerId: string (reference to users/{uid})
│       ├── ownerPhone: string (optional)
│       ├── propertyType: string ("singleBed" | "privateRoom" | "entireApartment" | "studio")
│       ├── genderPreference: string ("male" | "female" | "any")
│       ├── studyFieldIds: array<string> (tags for targeted filtering)
│       ├── governorate: string (state/province)
│       ├── district: string (city/district)
│       ├── latitude: number
│       ├── longitude: number
│       ├── geo: GeoPoint (for spatial queries)
│       ├── addressLine: string
│       ├── monthlyRent: number
│       ├── utilitiesIncluded: boolean
│       ├── totalBeds: number
│       ├── bedsAvailable: number
│       ├── bathrooms: number
│       ├── roomSizeSqm: number
│       ├── amenityIds: array<string>
│       ├── imageUrls: array<string> (Cloudinary URLs)
│       ├── videoUrl: string (optional, Cloudinary URL)
│       ├── status: string ("active" | "inactive" | "archived")
│       ├── ratingAverage: number (0-5)
│       ├── ratingCount: number
│       ├── reviewCount: number
│       ├── createdAt: timestamp
│       ├── updatedAt: timestamp
│       │
│       └── /private/verification {subcollection}
│           ├── verificationStatus: string
│           ├── verifiedAt: timestamp
│           └── verifiedBy: string (admin uid)
│
├── favorites/
│   └── {userId}
│       └── {listingId}
│           ├── addedAt: timestamp
│           └── listingReference: reference
│
├── bookings/
│   └── {bookingId}
│       ├── userId: string
│       ├── listingId: string
│       ├── startDate: timestamp
│       ├── endDate: timestamp
│       ├── totalAmount: number
│       ├── status: string ("pending" | "confirmed" | "completed" | "cancelled")
│       ├── paymentId: string (MyFatoorah transaction ID)
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── ratings/
│   └── {ratingId}
│       ├── listingId: string
│       ├── userId: string
│       ├── rating: number (1-5)
│       ├── review: string (optional)
│       ├── createdAt: timestamp
│       └── updatedAt: timestamp
│
├── reports/
│   └── {reportId}
│       ├── listingId: string
│       ├── reporterId: string
│       ├── reason: string
│       ├── description: string
│       ├── status: string ("pending" | "resolved" | "dismissed")
│       ├── createdAt: timestamp
│       └── resolvedAt: timestamp (optional)
│
└── metadata/ (optional)
    └── appConfig
        ├── amenities: array<{id, name}>
        ├── studyFields: array<{id, name}>
        ├── districts: object {governorate: [district]}
        └── lastUpdated: timestamp
```

### Firebase Security Rules

```firestore_rules
- **Listings**: Public read, authenticated create, owner update/delete
- **Users**: Private, self-update only
- **Favorites**: Private, user-specific access
- **Bookings**: Private, user-specific access
- **Ratings**: Public read, authenticated create, self-update/delete
- **Reports**: Authenticated create, admin manage
```

---

## 8. AUTHENTICATION FLOW

### Multi-Method Authentication

#### **Email & Password Authentication**
1. User enters email and password on Login Screen
2. `AuthCubit.login()` validates inputs
3. Firebase Authentication performs credential verification
4. On success, user profile fetched from Firestore
5. `AuthAuthenticated` state emitted with user data

#### **Google Sign-In**
1. User taps "Sign in with Google"
2. `GoogleSignInService` initiates native Google Sign-In flow
3. User selects Google account
4. Google credential exchanged with Firebase
5. User profile auto-created in Firestore if new user
6. `AuthAuthenticated` state emitted

#### **Sign Up (Registration)**
1. User enters name, email, password on Sign Up Screen
2. Validation checks for email uniqueness and format
3. Firebase Authentication creates user account
4. User profile document created in Firestore `users/{uid}`
5. Optional: OTP sent for email verification
6. Auto-login and redirect to Home

#### **Password Reset**
1. User enters email on Forgot Password Screen
2. `FirebaseAuthService.sendPasswordResetEmail()` called
3. Firebase sends password reset link
4. User clicks link, sets new password
5. `AuthPasswordResetSuccess` state emitted

#### **OTP Verification** (Optional)
1. After signup, OTP sent to user email
2. User enters OTP on Verify Screen
3. Firebase backend verifies OTP
4. `AuthOtpVerified` state emitted

### Auth State Stream

```dart
// AuthCubit listens to Firebase auth state changes
_uidSubscription = _repository.authUidChanges().listen(_onUidChanged);

// When UID changes (login/logout):
void _onUidChanged(String? uid) {
  if (uid == null) {
    emit(AuthUnauthenticated());  // Logout
  } else {
    _loadAndEmitProfile(uid);     // Login
  }
}
```

### Auth-Based Navigation

The app uses GoRouter redirect to enforce auth state routing:
```dart
redirect: (context, state) {
  final authState = context.read<AuthCubit>().state;
  
  if (authState is AuthUnauthenticated) {
    // Redirect to login if accessing protected routes
    if (!guestAllowedPaths.contains(state.uri.path)) {
      return '/login';
    }
  } else if (authState is AuthAuthenticated) {
    // Redirect authenticated users away from login
    if (authOnlyPaths.contains(state.uri.path)) {
      return '/home';
    }
  }
  return null;  // Allow navigation
}
```

---

## 9. EXPLANATION OF EACH FEATURE MODULE

### Feature Module Structure

Each feature follows Clean Architecture:
```
Feature/
├── Cubit/              # State management
├── Models/             # Data classes (domain models)
├── Repositories/       # Repository interface & implementation
├── Services/           # Business logic, Firebase operations
├── View/               # UI screens and widgets
└── Helper/             # Utilities specific to feature
```

---

### **1. Auth Feature** (lib/Features/Auth/)
**Purpose**: User authentication and profile management

| Component | Details |
|-----------|---------|
| **Cubit** | `AuthCubit` manages login, signup, password reset, Google Sign-In |
| **Models** | `UserProfile` (uid, name, email, phone, photo, provider) |
| **Services** | `FirebaseAuthService` (Firebase), `GoogleSignInService`, `UserProfileService` |
| **Screens** | Login, Sign Up, Forgot Password, Enter OTP, Reset Success, Personal Info |
| **Views** | Email/password forms, Google Sign-In button, OTP input, profile editor |

**Key Workflows**:
- Email/password authentication with Firebase
- OAuth 2.0 Google Sign-In integration
- User profile creation and updates
- Password reset via email link
- Phone number management

---

### **2. Home Feature** (lib/Features/Home/)
**Purpose**: Main application hub with property feed and recommendations

| Component | Details |
|-----------|---------|
| **Cubit** | `HomeCubit` manages listing feed, filtering, search, recommendations |
| **Models** | `HomeRecommendation` (id, title, location, price, rating, image) |
| **Repositories** | `ListingsRepository`, `RecommendationRepository` |
| **Services** | Database queries, recommendation algorithm |
| **Screens** | Main Shell (tabbed interface), Sell Tab, Recommendations See All |
| **Views** | Property cards, filter bar, recommendation carousel |

**Key Features**:
- Property listing feed with pagination
- Search by location (governorate, district, address)
- Filter application: price range, beds, gender, property type
- Recommendation engine based on user preferences
- Tab-based navigation (Home, Sell, Profile)
- Active filters indicator

**Data Flow**:
```
HomeCubit.loadListings()
  ├── ListingsRepository.fetchListings(query, searchText)
  │   └── PropertyListingFirestoreService.queryListings()
  └── RecommendationRepository.fetchRecommendations()
```

---

### **3. Listings Feature** (lib/Features/Listings/)
**Purpose**: Display and query active property listings

| Component | Details |
|-----------|---------|
| **Cubit** | Stateless; used by other features |
| **Models** | `PropertyListing` (complete listing data), `ListingQuery` (filter criteria) |
| **Repositories** | `ListingsRepository` interface for querying |
| **Services** | Firestore queries, geospatial filtering, search |

**Filtering Capabilities**:
- Price range filter (minMonthlyRent, maxMonthlyRent)
- Minimum beds filter
- Gender preference filter
- Property type filter (Single Bed, Private Room, Apartment, Studio)
- Geolocation filter (distance in km)
- Study field tags filter
- Text search (location fields)

**Client-Side Filtering**:
```dart
ListingQuery.matchesListing(PropertyListing)
  ├── Price check
  ├── Beds check
  ├── Gender preference check
  ├── Property type check
  ├── Geospatial distance calculation (Haversine formula)
  └── Study field tag matching
```

---

### **4. AddAd Feature** (lib/Features/AddAd/)
**Purpose**: Multi-step property listing creation and editing

| Component | Details |
|-----------|---------|
| **Cubit** | `AddAdCubit` manages form state across steps |
| **Models** | `AddAdDraft` (working copy), `PropertyListingFirestoreDto` (mapping) |
| **Repositories** | `AddPropertyRepository` abstracts publish/update operations |
| **Services** | Media compression, Cloudinary upload, Firestore writes, verification |
| **Screens** | Multi-step form (7 steps), draft autosave |
| **Views** | Form inputs, media pickers, location map, verification |

**Multi-Step Form**:
1. Property Type & Gender Preference (Single Bed, Private Room, Apartment, Studio) + (Male, Female, Any)
2. Study Field Selection (tags for targeting)
3. Location (Governorate, District, Address, Map Pin)
4. Property Details (Beds, Bathrooms, Rent, Size, Utilities)
5. Amenities (Checkboxes for WiFi, AC, Parking, etc.)
6. Media Upload (Images × N, Video × 1)
7. Verification & Review (Preview before publish)

**Media Processing**:
```
Media Selection (ImagePicker)
  ├── Materialize to temp file (handle content:// URIs)
  ├── Compress (MediaCompressionService)
  │   ├── Images: flutter_image_compress (quality reduction)
  │   └── Videos: video_compress
  └── Upload to Cloudinary
      └── Get secure_url
      └── Store URL in Firestore
```

**Draft Management**:
- Auto-save to local SharedPreferences
- Multi-device persistence
- Resume editing later
- Clear after successful publish

---

### **5. PropertyDetail Feature** (lib/Features/PropertyDetail/)
**Purpose**: Display comprehensive property information

| Component | Details |
|-----------|---------|
| **Cubit** | `PropertyDetailCubit` fetches and manages single listing |
| **Models** | `PropertyListing` (extended view with ratings/reviews) |
| **Services** | Firestore single-document queries |
| **Screens** | Detail view with image gallery, amenities, map, reviews |
| **Views** | Image carousel, rating display, amenity list, contact info |

**Information Displayed**:
- Full property photos and video
- Basic info: type, beds, bathrooms, size, rent
- Location on interactive map
- Amenities
- Owner profile and contact
- Ratings and reviews
- Availability status
- Gender preference and study field tags

---

### **6. Favorites Feature** (lib/Features/Favorites/)
**Purpose**: Save and manage favorite listings

| Component | Details |
|-----------|---------|
| **Cubit** | `FavoritesCubit` manages user's favorites |
| **Models** | `PropertyListing` (favorite items) |
| **Repositories** | `FavoritesRepository` (Firestore operations) |
| **Services** | Favorites Firestore service (add, remove, list) |
| **Screens** | Favorites list view |
| **Views** | Favorite items grid, empty state |

**Operations**:
- `loadFavoriteListings(userId)`: Fetch all favorites
- `addFavorite(userId, listingId)`: Add to favorites
- `removeFavorite(userId, listingId)`: Remove from favorites
- `isFavorited(listingId)`: Quick check

**Data Structure** (Firestore):
```
favorites/{userId}/{listingId}
  ├── addedAt: timestamp
  └── listingReference: reference
```

---

### **7. Booking Feature** (lib/Features/Booking/)
**Purpose**: Property reservation and booking management

| Component | Details |
|-----------|---------|
| **Cubit** | `BookingCubit` (if exists) |
| **Models** | `Booking` model (booking details) |
| **Services** | Firestore booking operations, payment integration |
| **Screens** | Booking confirmation, booking list, booking details |

**Booking Process**:
1. User views property detail
2. Tap "Book Now" → Booking Screen
3. Confirm property, select dates
4. Review terms and cost
5. Proceed to payment
6. MyFatoorah payment gateway
7. On success: Create booking document in Firestore
8. Send confirmation email/notification

---

### **8. Payment Feature** (lib/Features/Payment/)
**Purpose**: Payment processing via MyFatoorah

| Component | Details |
|-----------|---------|
| **Services** | `MyFatoorahPaymentService` (payment API integration) |
| **Screens** | Payment confirmation, receipt view |

**Integration**:
- Payment gateway: MyFatoorah
- Transaction types: One-time payments for bookings
- Payment methods: Credit card, Debit card, Bank transfer
- Transaction ID tracking
- Payment status verification

---

### **9. MyAds Feature** (lib/Features/MyAds/)
**Purpose**: Manage user's own property listings

| Component | Details |
|-----------|---------|
| **Cubit** | `MyAdsCubit` fetches owner's listings |
| **Models** | `PropertyListing` (owner's perspective) |
| **Services** | Firestore queries filtered by ownerId |
| **Screens** | My listings grid, edit listing screen |
| **Views** | Listing cards with stats, edit/delete buttons |

**Features**:
- View all own listings
- Edit listing details
- Delete listings
- View inquiry count
- Monitor rating/reviews
- Toggle active/inactive status

---

### **10. Profile Feature** (lib/Features/Profile/)
**Purpose**: User profile management and settings

| Component | Details |
|-----------|---------|
| **Cubit** | Profile state management |
| **Models** | `UserProfile` |
| **Services** | Profile update, photo upload |
| **Screens** | Profile edit, personal info, settings |
| **Views** | Profile form, photo picker, language selector |

**User Settings**:
- Edit name, email, phone
- Update profile photo
- Change language (Arabic/English)
- Notification preferences
- Privacy settings
- Logout

---

### **11. Ratings Feature** (lib/Features/Ratings/)
**Purpose**: Rate and review properties

| Component | Details |
|-----------|---------|
| **Cubit** | `PropertyRatingCubit` (if exists) |
| **Models** | `PropertyRating` model |
| **Services** | Rating Firestore service |
| **Screens** | Rate property screen, review list |

**Operations**:
- Submit 1-5 star rating
- Write optional review text
- View rating distribution
- Delete own ratings
- Auto-calculate property average rating

---

### **12. Reports Feature** (lib/Features/Reports/)
**Purpose**: Report inappropriate or fraudulent listings

| Component | Details |
|-----------|---------|
| **Cubit** | `ListingReportCubit` manages report submission |
| **Models** | `ListingReport` model |
| **Services** | Report Firestore service |
| **Screens** | Report form, reason selection |

**Report Categories**:
- Fraudulent listing
- Inappropriate content
- Harassment or scam
- Fake photos
- Other

**Admin Actions**:
- Review reported listings
- Mark as resolved/dismissed
- Take action (delete listing, warn user, ban)

---

### **13. Filter Feature** (lib/Features/Filter/)
**Purpose**: Advanced search and filtering interface

| Component | Details |
|-----------|---------|
| **Screens** | Dedicated filter screen with all filter options |
| **Logic** | Builds `ListingQuery` and passes to Home |

**Filters Available**:
- Price range slider (min-max)
- Minimum beds counter
- Location (map selector or text input)
- Distance from current location
- Property type multi-select
- Gender preference
- Study fields multi-select
- Amenities multi-select

---

### **14. Location Feature** (lib/Features/Location/)
**Purpose**: Geolocation services and map integration

| Component | Details |
|-----------|---------|
| **Cubit** | `UserLocationCubit` |
| **Services** | `CurrentLocationService`, `ReverseGeocodeService` |
| **Features** | GPS, map, geocoding |

**Capabilities**:
- Get user's current GPS coordinates
- Reverse geocode coordinates to address
- Request location permissions
- Store location state
- Calculate distance between two points (Haversine formula)
- Display properties on map

---

## 10. DATA FLOW BETWEEN UI, CUBIT, REPOSITORY, SERVICES, AND FIREBASE

### Complete Data Flow Example: Fetching Property Listings

```
┌─────────────────────────────────────────────────────────────┐
│ 1. UI LAYER (Home Screen)                                   │
│                                                              │
│  User taps "Apply Filters"                                  │
│  HomeScreen calls: context.read<HomeCubit>().setListingQuery│
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. STATE MANAGEMENT (HomeCubit)                             │
│                                                              │
│  setListingQuery(ListingQuery query)                        │
│    └─ _listingQuery = query                                 │
│    └─ loadListings()  # Call repository                     │
│        └─ emit(HomeLoading())                               │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. REPOSITORY LAYER (ListingsRepository Implementation)     │
│                                                              │
│  fetchListings(query, searchText, limit=80, fetchCap=200)  │
│    ├─ Query Firestore for up to fetchCap documents         │
│    ├─ Build PropertyListing objects                        │
│    ├─ Filter client-side with query.matchesListing()      │
│    ├─ Filter by search text                               │
│    └─ Return up to limit items                            │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. SERVICE LAYER (PropertyListingFirestoreService)          │
│                                                              │
│  queryActiveListings(limit, offset)                         │
│    ├─ FirebaseFirestore.instance                           │
│    ├─    .collection('listings')                           │
│    ├─    .where('status', isEqualTo: 'active')             │
│    ├─    .orderBy('createdAt', descending: true)           │
│    ├─    .limit(limit)                                     │
│    ├─    .get()                                            │
│    └─ Convert QuerySnapshot to PropertyListing list        │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ 5. DATA SOURCE (Firebase Firestore)                         │
│                                                              │
│  listings/ {collection}                                     │
│    ├─ {id1} {document}                                      │
│    │   ├─ status: "active"                                 │
│    │   ├─ monthlyRent: 1500                                 │
│    │   ├─ totalBeds: 2                                      │
│    │   └─ ...                                               │
│    ├─ {id2} {document}                                      │
│    └─ ...                                                   │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼ (Response)
┌─────────────────────────────────────────────────────────────┐
│ 4. Service returns List<PropertyListing>                    │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼ (List<PropertyListing>)
┌─────────────────────────────────────────────────────────────┐
│ 3. Repository filters client-side with query predicates     │
│    Example: price range, distance, study fields            │
│    Returns filtered List<PropertyListing>                  │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼ (List<PropertyListing>)
┌─────────────────────────────────────────────────────────────┐
│ 2. Cubit receives List and emits HomeLoaded state           │
│                                                              │
│  emit(HomeLoaded(                                           │
│    items: listings,                                         │
│    recommendations: [...],                                 │
│    hasActiveFilters: true                                   │
│  ))                                                         │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│ 1. UI observes state change                                 │
│                                                              │
│  BlocBuilder<HomeCubit, HomeState>(                         │
│    builder: (context, state) {                             │
│      if (state is HomeLoaded) {                            │
│        return ListView(items: state.items);                │
│      }                                                      │
│    }                                                        │
│  )                                                          │
│                                                              │
│  Screen updates with filtered property list               │
└─────────────────────────────────────────────────────────────┘
```

### Another Example: Creating a Property Listing

```
┌──────────────────────────────────┐
│ 1. UI: Multi-Step Form           │
│                                  │
│ Step 1-6: Fill form fields      │
│           Select media          │
│                                  │
│ Step 7: Tap "Publish"           │
│         AddAdCubit.publishListing│
└─────────────────┬────────────────┘
                  │
                  ▼
┌──────────────────────────────────┐
│ 2. Cubit: AddAdCubit             │
│                                  │
│ publishListing(draft)            │
│   ├─ emit(AddAdLoading)         │
│   └─ _repository.publishListing()│
└─────────────────┬────────────────┘
                  │
                  ▼
┌──────────────────────────────────┐
│ 3. Repository: AddPropertyRepo   │
│                                  │
│ publishListing(draft)            │
│   ├─ Compress images & videos   │
│   │  (MediaCompressionService)  │
│   ├─ Upload to Cloudinary       │
│   │  (CloudinaryUploadService)  │
│   │  ├─ imageUrls[]             │
│   │  └─ videoUrl                │
│   ├─ Create Firestore document  │
│   │  (PropertyListingFirestore)  │
│   └─ Create verification record │
│      (ListingVerificationStore) │
└─────────────────┬────────────────┘
                  │
                  ▼
┌──────────────────────────────────┐
│ 4. Services Layer                │
│                                  │
│ A) MediaCompressionService:      │
│    ├─ Image: Quality reduction   │
│    └─ Video: Bitrate reduction   │
│                                  │
│ B) CloudinaryUploadService:      │
│    ├─ FormData with compressed   │
│    ├─ POST to Cloudinary API    │
│    └─ Receive secure_url         │
│                                  │
│ C) PropertyListingFirestore:    │
│    ├─ PropertyListingFirestoreDto│
│    │  .toCreateMap(draft, urls) │
│    └─ Firestore create document │
│                                  │
│ D) ListingVerificationFirestore: │
│    ├─ Create verification doc   │
│    ├─ Set status: "pending"     │
│    └─ Store in subcollection    │
└─────────────────┬────────────────┘
                  │
                  ▼
┌──────────────────────────────────┐
│ 5. Firebase                      │
│                                  │
│ A) Cloudinary API:               │
│    ├─ Store images              │
│    ├─ Store video               │
│    └─ Return secure URLs        │
│                                  │
│ B) Firestore:                    │
│    ├─ listings/{newId}          │
│    │  ├─ ownerId: uid           │
│    │  ├─ propertyType: string   │
│    │  ├─ imageUrls: [urls]      │
│    │  ├─ ...                    │
│    │  └─ status: "active"       │
│    │                            │
│    └─ listings/{newId}/private/ │
│       verification              │
│         ├─ status: "pending"   │
│         └─ createdAt: now()    │
└─────────────────┬────────────────┘
                  │
                  ▼ Success
┌──────────────────────────────────┐
│ 2. Cubit emits AddAdPublished    │
│    state with listingId          │
└─────────────────┬────────────────┘
                  │
                  ▼
┌──────────────────────────────────┐
│ 1. UI displays success message   │
│    Navigate to HomeScreen        │
│    or ListingDetailScreen        │
└──────────────────────────────────┘
```

---

## 11. EXTERNAL SERVICES AND APIs USED

### Third-Party Integrations

| Service | Purpose | Integration | API Type |
|---------|---------|-------------|----------|
| **Firebase** | Backend infrastructure | firebase_core, firebase_auth, cloud_firestore | REST + Realtime |
| **Google Sign-In** | OAuth authentication | google_sign_in plugin | OAuth 2.0 |
| **Cloudinary** | Media storage & CDN | dio (HTTP client) | REST (Multipart Upload) |
| **MyFatoorah** | Payment processing | Custom integration | REST API |
| **Google Maps** | Location services | flutter_map, latlong2 | Maps/Geocoding |
| **Geolocator** | GPS services | geolocator plugin | Native APIs |
| **Geocoding** | Reverse geocoding | geocoding plugin | Google Geocoding API |

### Firebase Configuration

```dart
// lib/firebase_options.dart
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Platform-specific config (Android, iOS, Web)
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return ios;
    }
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError('');
  }
}
```

### Cloudinary Configuration

**Unsigned Uploads** (no backend required):
- Upload Preset: `makani`
- Cloud Name: `dvgxwf9pr`
- Image Upload URL: `https://api.cloudinary.com/v1_1/{cloudName}/image/upload`
- Video Upload URL: `https://api.cloudinary.com/v1_1/{cloudName}/video/upload`

**Build Configuration**:
```bash
flutter run --dart-define=CLOUDINARY_CLOUD_NAME=dvgxwf9pr \
           --dart-define=CLOUDINARY_UPLOAD_PRESET=makani
```

### MyFatoorah Payment API

- **Payment Gateway**: MyFatoorah (Kuwait/Middle East payment processor)
- **Integration Method**: HTTP REST API
- **Supported Methods**: Credit Card, Debit Card, Bank Transfer
- **Transaction Flow**: 
  1. Create invoice
  2. Redirect to MyFatoorah checkout
  3. User completes payment
  4. Webhook notification or status check
  5. Update booking status in Firestore

### Google Maps & Geolocation

- **Map Library**: flutter_map (OpenStreetMap)
- **Geolocation**: geolocator plugin (native iOS/Android)
- **Geocoding**: geocoding plugin for address↔coordinates conversion
- **Distance Calculation**: Haversine formula for km between two points

---

## 12. FOLDER STRUCTURE EXPLANATION

### Root Level

```
makani_app/
├── analysis_options.yaml          # Dart linting rules
├── firebase.json                  # Firebase deployment config
├── firestore.rules                # Firestore security rules
├── pubspec.yaml                   # Dependencies & assets
├── pubspec.lock                   # Locked dependency versions
├── README.md                       # Project documentation
│
├── android/                       # Android native code
│   ├── app/build.gradle.kts       # App-level build config
│   ├── build.gradle.kts           # Project-level build config
│   ├── settings.gradle.kts        # Settings
│   ├── app/src/main/
│   │   ├── AndroidManifest.xml   # Permissions, components
│   │   └── google-services.json  # Firebase credentials
│   └── local.properties          # Local SDK paths
│
├── ios/                           # iOS native code
│   ├── Runner/                   # Main app files
│   │   ├── AppDelegate.swift    # App lifecycle
│   │   ├── Info.plist          # App configuration
│   │   ├── GoogleService-Info.plist # Firebase credentials
│   │   └── Assets.xcassets      # App icons
│   ├── Runner.xcodeproj/        # Xcode project
│   └── Podfile                  # CocoaPods dependencies
│
├── web/                           # Web platform
│   ├── index.html                # HTML entry point
│   ├── manifest.json             # PWA manifest
│   └── icons/                    # Web icons
│
├── lib/                           # Dart source code (main)
│   ├── main.dart                 # App entry point
│   ├── firebase_options.dart     # Firebase initialization
│   │
│   ├── Core/                     # Shared resources
│   │   ├── Config/              # Configs (Cloudinary, MyFatoorah)
│   │   ├── Const/               # Constants (colors, strings, assets)
│   │   ├── Cubit/               # Global cubits (Language)
│   │   ├── Helper/              # Utilities
│   │   ├── Services/            # Shared services (Location, Geocoding)
│   │   └── Widgets/             # Reusable UI components
│   │
│   ├── Features/                # Feature modules
│   │   ├── Auth/                # Authentication
│   │   │   ├── Cubit/          # auth_cubit, auth_state
│   │   │   ├── Models/         # UserProfile
│   │   │   ├── Repositories/   # auth_repository interface
│   │   │   ├── Services/       # Firebase auth, Google Sign-In
│   │   │   ├── Helper/         # Validation logic
│   │   │   └── View/           # Screens, Widgets
│   │   │
│   │   ├── Home/               # Home/Feed
│   │   │   ├── Cubit/         # home_cubit, home_state
│   │   │   ├── Model/         # HomeRecommendation
│   │   │   ├── Repositories/  # Recommendation, Listings
│   │   │   ├── Services/      # Feed generation, recommendations
│   │   │   └── View/          # Main Shell, Sell Tab, Screens
│   │   │
│   │   ├── Listings/          # Listing query & display
│   │   │   ├── Model/         # PropertyListing, ListingQuery
│   │   │   ├── Repositories/  # listings_repository interface
│   │   │   ├── Services/      # Firestore queries, filtering
│   │   │   ├── Data/          # Query helpers (geo-distance)
│   │   │   └── View/          # Listing cards, detail view
│   │   │
│   │   ├── AddAd/             # Create/Edit listings
│   │   │   ├── Cubit/         # add_ad_cubit, add_ad_state
│   │   │   ├── Model/         # AddAdDraft, enums, DTOs
│   │   │   ├── Repositories/  # add_property_repository interface
│   │   │   ├── Services/      # Media compression, Cloudinary, Firestore
│   │   │   ├── Helper/        # Validation, location helper
│   │   │   └── View/          # Multi-step form, media picker
│   │   │
│   │   ├── PropertyDetail/    # Single property view
│   │   │   ├── Cubit/         # property_detail_cubit
│   │   │   ├── Repositories/  # Detail data fetching
│   │   │   ├── Services/      # Load single listing, reviews
│   │   │   └── View/          # Detail screen, gallery
│   │   │
│   │   ├── Favorites/         # Favorites management
│   │   │   ├── Cubit/         # favorites_cubit, favorites_state
│   │   │   ├── Repositories/  # favorites_repository interface
│   │   │   ├── Services/      # Firestore favorites operations
│   │   │   └── View/          # Favorites list screen
│   │   │
│   │   ├── Booking/           # Booking system
│   │   │   ├── Services/      # Firestore booking operations
│   │   │   └── View/          # Booking screens
│   │   │
│   │   ├── Payment/           # Payment processing
│   │   │   ├── Services/      # MyFatoorah integration
│   │   │   └── View/          # Payment confirmation
│   │   │
│   │   ├── MyAds/             # User's listings management
│   │   │   ├── Cubit/         # my_ads_cubit
│   │   │   ├── Services/      # User's listing queries
│   │   │   └── View/          # My listings screen
│   │   │
│   │   ├── Profile/           # User profile
│   │   │   ├── Cubit/         # profile_cubit
│   │   │   ├── Services/      # Profile CRUD, photo upload
│   │   │   └── View/          # Profile edit, settings
│   │   │
│   │   ├── Ratings/           # Property ratings
│   │   │   ├── Model/         # PropertyRating
│   │   │   ├── Repositories/  # rating_repository interface
│   │   │   ├── Services/      # Firestore rating operations
│   │   │   └── View/          # Rate screen, reviews list
│   │   │
│   │   ├── Reports/           # Report listings
│   │   │   ├── Cubit/         # listing_report_cubit
│   │   │   ├── Repositories/  # report_repository interface
│   │   │   ├── Services/      # Firestore report operations
│   │   │   └── View/          # Report form
│   │   │
│   │   ├── Filter/            # Advanced filtering
│   │   │   ├── Cubit/         # filter_cubit
│   │   │   └── View/          # Filter screen with options
│   │   │
│   │   └── Location/          # Geolocation & maps
│   │       ├── Cubit/         # user_location_cubit
│   │       ├── Services/      # Location, geocoding
│   │       └── View/          # Map selection screen
│   │
│   ├── Routing/               # Navigation
│   │   ├── app_router.dart    # GoRouter configuration
│   │   ├── routes.dart        # Route definitions
│   │   └── router_transitions.dart # Page transitions
│   │
│   ├── generated/             # Auto-generated i18n files
│   │   ├── l10n.dart         # Localization base
│   │   ├── l10n_ar.dart      # Arabic strings
│   │   └── l10n_en.dart      # English strings
│   │
│   └── l10n/                  # i18n source files
│       ├── intl_ar.arb       # Arabic translations
│       └── intl_en.arb       # English translations
│
├── test/                       # Unit & widget tests
│   ├── add_ad_cubit_test.dart
│   ├── property_listing_mapper_test.dart
│   └── widget_test.dart
│
├── assets/                     # App resources
│   ├── images/               # PNG/JPEG/SVG images
│   ├── icons/               # App icons by category
│   │   ├── auth_icons/     # Login/signup icons
│   │   ├── home_icons/     # Home screen icons
│   │   ├── navBar_icons/   # Navigation bar icons
│   │   └── logo.png        # App logo
│   └── fonts/               # Custom fonts (optional)
│
└── build/                     # Build outputs (generated)
    └── [platform builds]
```

### Feature Module Template

```
Feature/
├── Cubit/
│   ├── {feature}_cubit.dart        # State management logic
│   └── {feature}_state.dart        # State classes
│
├── Model/ (or Models/)
│   ├── {domain_model}.dart         # Business entity
│   └── {dto}.dart                  # Data Transfer Object
│
├── Repositories/
│   ├── {feature}_repository.dart   # Abstract interface
│   └── {feature}_repository_impl.dart # Concrete implementation
│
├── Services/
│   ├── {firebase}_service.dart     # Firebase operations
│   └── {api}_service.dart          # External API calls
│
├── Helper/
│   ├── {validation}.dart           # Input validation
│   └── {utility}.dart              # Helper functions
│
└── View/
    ├── Screens/
    │   ├── {feature}_screen.dart   # Main screen
    │   └── {feature}_detail_screen.dart # Detail view
    └── Widgets/
        ├── {custom}_widget.dart    # Custom components
        └── {item}_card.dart        # List item widgets
```

---

## 13. TECHNOLOGY STACK

### Framework & Languages
- **Language**: Dart 3.0+
- **Framework**: Flutter
- **Minimum SDK**: Flutter 3.x

### UI/UX Libraries
| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_screenutil` | 5.9.3 | Responsive design adaptation |
| `google_fonts` | 8.0.2 | Custom typography |
| `flutter_svg` | 2.2.3 | SVG rendering |
| `cached_network_image` | 3.4.1 | Image caching & optimization |
| `cupertino_icons` | 1.0.8 | iOS-style icons |
| `flutter_map` | 7.0.2 | Interactive maps |

### State Management & Architecture
| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_bloc` | 9.0.0 | BLoC pattern implementation |
| `bloc` | 9.0.0 | Core BLoC library |
| `equatable` | 2.0.5 | Value-based equality |

### Networking & API
| Package | Version | Purpose |
|---------|---------|---------|
| `dio` | 5.7.0 | HTTP client |
| `pretty_dio_logger` | 1.4.0 | Request/response logging |

### Firebase & Backend
| Package | Version | Purpose |
|---------|---------|---------|
| `firebase_core` | 3.8.1 | Firebase initialization |
| `firebase_auth` | 5.3.4 | User authentication |
| `cloud_firestore` | 5.6.12 | Database |
| `firebase_storage` | 12.4.10 | File storage |

### Authentication & Social
| Package | Version | Purpose |
|---------|---------|---------|
| `google_sign_in` | 6.2.2 | Google OAuth |

### Location & Maps
| Package | Version | Purpose |
|---------|---------|---------|
| `geolocator` | 13.0.2 | GPS positioning |
| `geocoding` | 4.0.0 | Reverse geocoding |
| `latlong2` | 0.9.1 | Geographic coordinates |
| `permission_handler` | 11.3.1 | Runtime permissions |

### Media Handling
| Package | Version | Purpose |
|---------|---------|---------|
| `image_picker` | 1.2.1 | Photo/video selection |
| `flutter_image_compress` | 2.4.0 | Image compression |
| `video_compress` | 3.1.4 | Video compression |
| `video_player` | 2.9.5 | Video playback |

### Storage & Utilities
| Package | Version | Purpose |
|---------|---------|---------|
| `shared_preferences` | 2.3.3 | Local key-value storage |
| `path_provider` | 2.1.5 | File system paths |
| `path` | 1.9.1 | Path manipulation |
| `uuid` | 4.5.1 | Unique ID generation |

### i18n & Localization
| Package | Version | Purpose |
|---------|---------|---------|
| `intl` | any | Internationalization |
| `flutter_localizations` | SDK | Localization support |

### Routing & Navigation
| Package | Version | Purpose |
|---------|---------|---------|
| `go_router` | 14.6.2 | Deep linking & navigation |

### UI Components
| Package | Version | Purpose |
|---------|---------|---------|
| `pinput` | 3.0.1 | OTP input field |
| `webview_flutter` | 4.13.1 | Embedded web view |

### Development & Testing
| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_lints` | 6.0.0 | Lint rules |
| `bloc_test` | 10.0.0 | BLoC testing |
| `mocktail` | 1.0.4 | Mocking for tests |

### Others
| Package | Purpose |
|---------|---------|
| `url_launcher` | Open URLs |
| `share_plus` | Share functionality |

---

## 14. POSSIBLE UML ENTITIES AND RELATIONSHIPS

### Domain Models & Relationships

```
┌─────────────────────────────────────────────────────────────┐
│                       USER (UserProfile)                    │
├─────────────────────────────────────────────────────────────┤
│ - uid: String (PK)                                         │
│ - fullName: String                                         │
│ - email: String (UK)                                       │
│ - phone: String?                                           │
│ - photoBase64: String?                                     │
│ - provider: String ("google" | "password")                 │
│ - createdAt: DateTime                                      │
│ - updatedAt: DateTime                                      │
│                                                             │
│ Relationships:                                              │
│   1-to-Many: Listings (as owner)                           │
│   1-to-Many: Bookings (as booker)                          │
│   1-to-Many: Ratings (as rater)                            │
│   1-to-Many: Favorites                                     │
│   1-to-Many: Reports (as reporter)                         │
└─────────────────────────────────────────────────────────────┘
         │
         │ owns (1-to-Many)
         ▼
┌─────────────────────────────────────────────────────────────┐
│                   LISTING (PropertyListing)                 │
├─────────────────────────────────────────────────────────────┤
│ - id: String (PK)                                          │
│ - ownerId: String (FK → USER.uid)                          │
│ - ownerPhone: String?                                      │
│ - propertyType: String                                     │
│ - genderPreference: String                                 │
│ - studyFieldIds: List<String>                              │
│ - governorate: String                                      │
│ - district: String                                         │
│ - latitude: Double                                         │
│ - longitude: Double                                        │
│ - addressLine: String                                      │
│ - monthlyRent: Double                                      │
│ - utilitiesIncluded: Boolean                               │
│ - totalBeds: Int                                           │
│ - bedsAvailable: Int                                       │
│ - bathrooms: Int                                           │
│ - roomSizeSqm: Double                                      │
│ - amenityIds: List<String> (FK → AMENITY.id)              │
│ - imageUrls: List<String>                                  │
│ - videoUrl: String?                                        │
│ - status: String ("active"|"inactive"|"archived")          │
│ - ratingAverage: Double (0-5)                              │
│ - ratingCount: Int                                         │
│ - reviewCount: Int                                         │
│ - createdAt: DateTime                                      │
│ - updatedAt: DateTime                                      │
│                                                             │
│ Relationships:                                              │
│   Many-to-1: USER (owner)                                  │
│   1-to-Many: Ratings                                       │
│   1-to-Many: Bookings                                      │
│   1-to-Many: Reports                                       │
│   Many-to-Many: AMENITY                                    │
│   Many-to-Many: STUDY_FIELD                                │
│   1-to-1: VERIFICATION (subcollection)                     │
└─────────────────────────────────────────────────────────────┘
         │  ▲
         │  │
         │  └─── references (0-to-Many)
         │
         ├─ is_rated_by (1-to-Many)
         │  ▼
         │  ┌──────────────────────────────────┐
         │  │ RATING (PropertyRating)          │
         │  ├──────────────────────────────────┤
         │  │ - id: String (PK)               │
         │  │ - listingId: String (FK)        │
         │  │ - userId: String (FK)           │
         │  │ - rating: Int (1-5)             │
         │  │ - review: String?               │
         │  │ - createdAt: DateTime           │
         │  │ - updatedAt: DateTime           │
         │  └──────────────────────────────────┘
         │
         ├─ is_reported_by (1-to-Many)
         │  ▼
         │  ┌──────────────────────────────────┐
         │  │ REPORT (ListingReport)           │
         │  ├──────────────────────────────────┤
         │  │ - id: String (PK)               │
         │  │ - listingId: String (FK)        │
         │  │ - reporterId: String (FK)       │
         │  │ - reason: String                │
         │  │ - description: String           │
         │  │ - status: String ("pending"|..) │
         │  │ - createdAt: DateTime           │
         │  └──────────────────────────────────┘
         │
         └─ is_booked (1-to-Many)
            ▼
            ┌──────────────────────────────────┐
            │ BOOKING (Booking)                │
            ├──────────────────────────────────┤
            │ - id: String (PK)               │
            │ - userId: String (FK → USER)    │
            │ - listingId: String (FK)        │
            │ - startDate: DateTime           │
            │ - endDate: DateTime             │
            │ - totalAmount: Double           │
            │ - paymentId: String (FK → PMT) │
            │ - status: String (pending|..)   │
            │ - createdAt: DateTime           │
            │ - updatedAt: DateTime           │
            └──────────────────────────────────┘

┌──────────────────────────────────────────┐
│ FAVORITE (Favorites)                     │
├──────────────────────────────────────────┤
│ - id: String (PK)                       │
│ - userId: String (FK → USER)            │
│ - listingId: String (FK → LISTING)      │
│ - addedAt: DateTime                     │
│                                          │
│ Composite Key: (userId, listingId)      │
└──────────────────────────────────────────┘

┌──────────────────────────────────────────┐
│ PAYMENT (Payment Transaction)            │
├──────────────────────────────────────────┤
│ - id: String (PK)                       │
│ - bookingId: String (FK → BOOKING)      │
│ - userId: String (FK → USER)            │
│ - amount: Double                        │
│ - currency: String                      │
│ - status: String (success|failed|..)    │
│ - gatewayId: String (MyFatoorah ID)     │
│ - createdAt: DateTime                   │
└──────────────────────────────────────────┘

┌──────────────────────────────────────────┐
│ AMENITY (Reference Data)                 │
├──────────────────────────────────────────┤
│ - id: String (PK)                       │
│ - name: String                          │
│ - icon: String                          │
│ - category: String                      │
│                                          │
│ Examples: WiFi, AC, Parking, Kitchen    │
└──────────────────────────────────────────┘

┌──────────────────────────────────────────┐
│ STUDY_FIELD (Reference Data)             │
├──────────────────────────────────────────┤
│ - id: String (PK)                       │
│ - name: String                          │
│ - abbreviation: String                  │
│                                          │
│ Examples: Engineering, Medicine, Law    │
└──────────────────────────────────────────┘

┌──────────────────────────────────────────┐
│ VERIFICATION (Subcollection of LISTING) │
├──────────────────────────────────────────┤
│ - path: listings/{id}/private/verif.   │
│ - status: String (pending|verified|..) │
│ - verifiedAt: DateTime?                 │
│ - verifiedBy: String (admin uid)?       │
│ - notes: String?                        │
└──────────────────────────────────────────┘
```

### Entity-Relationship Diagram (ERD)

```
┌──────────┐          ┌──────────┐
│   USER   │◄─────────│ LISTING  │
│  (uid)   │ 1:Many  │  (id)    │
└──────────┘         └──────────┘
    │                     │
    │                     │
   1│M                    │1M
    │                     │
    │                ┌────┴─────┐
    │                │           │
    ▼                ▼           ▼
┌──────────┐   ┌──────────┐  ┌────────┐
│ BOOKING  │   │ RATING   │  │REPORT  │
└──────────┘   └──────────┘  └────────┘
    │                │
    │                │
   1│M              1│M
    │                │
    ├────┬───────────┘
    │    │
    └────┤
         │ (via Firestore subcollection)
         ▼
    ┌──────────┐
    │VERIFICATION
    └──────────┘

MANY-TO-MANY Relationships:
- LISTING ◄──────────► AMENITY
- LISTING ◄──────────► STUDY_FIELD
- USER ◄──────────────► LISTING (via FAVORITE)
- USER ◄──────────────► LISTING (via RATING)
```

---

## 15. SUMMARY SUITABLE FOR GRADUATION PROJECT DOCUMENTATION

### Executive Summary

**Makani** is a comprehensive, production-ready mobile property rental application developed using Flutter. The application addresses the accommodation needs of university students by providing a user-friendly platform where students can discover rental properties, and property owners can list their properties.

### Key Achievements

1. **Cross-Platform Deployment**: Successfully deployed on Android, iOS, and Web platforms using a single Flutter codebase

2. **Scalable Architecture**: Implemented Clean Architecture with feature-driven design enabling easy feature addition and maintenance

3. **Robust State Management**: Utilized Flutter BLoC/Cubit pattern for predictable, testable state management across 14 feature modules

4. **Secure Backend Integration**: Integrated Firebase with comprehensive Firestore security rules for user data protection and access control

5. **Advanced Search & Filtering**: Implemented multi-criteria filtering including geolocation-based search using Haversine distance calculation

6. **Media Management**: Integrated Cloudinary CDN for efficient image and video storage with automatic compression

7. **Payment Integration**: Integrated MyFatoorah payment gateway for secure booking transactions

8. **Multilingual Support**: Implemented Arabic and English localization using intl package

9. **Location Services**: Integrated Google Maps and native geolocation APIs for location-based features

10. **Real-Time Updates**: Leveraged Firestore's real-time capabilities for dynamic property listings and ratings

### Technical Highlights

- **Architecture Pattern**: Clean Architecture + Feature-Driven Design
- **State Management**: Flutter BLoC/Cubit (9.0.0)
- **Navigation**: GoRouter with deep linking support
- **Database**: Cloud Firestore with hierarchical collections
- **Authentication**: Multi-method (Email/Password, Google OAuth)
- **Media Upload**: Cloudinary API with compression services
- **Responsive Design**: flutter_screenutil for adaptive UI
- **Testing**: BLoC testing, unit tests with mocktail

### Project Structure

- **14 Feature Modules**: Each independently testable and deployable
- **Shared Core Layer**: Reusable services, widgets, and configurations
- **Modular Repositories**: Dependency injection for loose coupling
- **Comprehensive Routing**: Named routes with deep linking

### Deliverables

1. **Source Code**: Complete Flutter application with 3000+ lines of Dart code
2. **Database Schema**: Firestore collection structure with security rules
3. **API Integration**: Firebase, Cloudinary, MyFatoorah, Google APIs
4. **UI/UX**: Material Design with responsive layouts
5. **Testing**: Unit tests, BLoC tests, widget tests
6. **Documentation**: Inline code comments, README, technical overview

### Future Enhancement Opportunities

- Implement real-time chat between property owners and renters
- Add property inspection scheduling and virtual tours
- Develop admin dashboard for content moderation
- Implement machine learning for personalized recommendations
- Add payment method diversity (Apple Pay, Google Pay)
- Offline-first caching with background sync
- Performance optimization with lazy loading

### Learning Outcomes

This project demonstrates proficiency in:
- Full-stack mobile application development
- Clean Architecture and SOLID principles
- State management patterns (BLoC/Cubit)
- Firebase ecosystem integration
- RESTful API integration
- Responsive UI design
- Cross-platform development
- Test-driven development
- Git version control and collaboration
- Project documentation and technical writing

---

## References & Resources

- **Flutter Documentation**: https://flutter.dev/docs
- **Firebase Documentation**: https://firebase.google.com/docs
- **Clean Architecture in Flutter**: https://resocoder.com/flutter-clean-architecture
- **BLoC Documentation**: https://bloclibrary.dev/
- **Firestore Best Practices**: https://firebase.google.com/docs/firestore/best-practices

---

**Document Version**: 1.0  
**Last Updated**: 2026-06-25  
**Author**: Development Team  
**Status**: Complete Technical Overview for Academic/Professional Documentation
