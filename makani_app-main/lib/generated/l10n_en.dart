// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Makani';

  @override
  String get signIn => 'Login';

  @override
  String get signUp => 'Sign Up';

  @override
  String get welcomeToMakani => 'Welcome to Makani';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get orLoginWith => 'Or login with';

  @override
  String get loginWithGoogle => 'Login with Google';

  @override
  String get newToMakaniSignUp => 'New to Makani?';

  @override
  String get alreadyHaveAccountLogin => 'Already have an account?';

  @override
  String get name => 'Name';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get enterOtp => 'Enter OTP';

  @override
  String get resendCode => 'Resend code';

  @override
  String get verify => 'Verify';

  @override
  String get otpSentToEmail => 'Please enter the OTP sent to your email:';

  @override
  String get havenGotOtpYet => 'Haven\'t got the otp yet?';

  @override
  String get resendOtp => 'Resend otp';

  @override
  String get verifyCode => 'Verify code';

  @override
  String get newPassword => 'New password';

  @override
  String get setNewPassword => 'Set new password';

  @override
  String get passwordReset => 'Password reset';

  @override
  String get goToLogin => 'Go to login';

  @override
  String get successful => 'Successful';

  @override
  String get passwordUpdatedSuccessMessage =>
      'Congratulations! Your password has been successfully updated. Click Continue to login';

  @override
  String get passwordResetEmailSentMessage =>
      'A password reset email has been sent to your email. Use it to update your password, then try logging in with your new password.\n\nIf you do not see the email, check your spam/junk folder.';

  @override
  String hiUser(String name) {
    return 'Hi, $name';
  }

  @override
  String helloUser(String name) {
    return 'Hello, $name';
  }

  @override
  String get searchLocationPlaceholder => 'Search location, area...';

  @override
  String get defaultAddress =>
      '23 El-Gomhoria Street, Al-Arab District, Port Said 42511, Egypt';

  @override
  String get aiRecommendation => 'AI Recommendation';

  @override
  String get seeAll => 'See All';

  @override
  String get popularListing => 'Popular Listing';

  @override
  String get maleOnly => 'Male Only';

  @override
  String get femaleOnly => 'Female Only';

  @override
  String bedsCount(String count) {
    return '$count Beds';
  }

  @override
  String bedsAvailable(String count) {
    return '$count beds available';
  }

  @override
  String bathsCount(String count) {
    return '$count Baths';
  }

  @override
  String get searchForFlat => 'Search for a flat';

  @override
  String get filter => 'Filter';

  @override
  String get profession => 'Profession';

  @override
  String get searchProfession => 'Search Profession....';

  @override
  String get reset => 'Reset';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get minPrice => 'Min Price';

  @override
  String get maxPrice => 'Max Price';

  @override
  String get rooms => 'Rooms';

  @override
  String get distance => 'Distance';

  @override
  String get any => 'Any';

  @override
  String get getDirections => 'Get Directions';

  @override
  String get reportListing => 'Report Listing';

  @override
  String get whyReportingListing => 'Why are you reporting this listing?';

  @override
  String get incorrectPrice => 'Incorrect price';

  @override
  String get alreadyRented => 'Already rented';

  @override
  String get fakeListing => 'Fake listing';

  @override
  String get inappropriateContent => 'Inappropriate content';

  @override
  String get other => 'Other';

  @override
  String get send => 'Send';

  @override
  String get availableNow => 'Available Now';

  @override
  String get contactOwner => 'Contact Owner';

  @override
  String get reserve => 'Reserve';

  @override
  String get readMore => 'Read more';

  @override
  String get readLess => 'Read less';

  @override
  String get overview => 'Overview';

  @override
  String get video => 'Video';

  @override
  String get ratings => 'Ratings';

  @override
  String get reviews => 'Reviews';

  @override
  String get writeReview => 'Write a review';

  @override
  String get editYourReview => 'Edit your review';

  @override
  String get tapToRate => 'Tap a star to rate this property';

  @override
  String get shareYourExperience => 'Share your experience (optional)';

  @override
  String get submitReview => 'Submit review';

  @override
  String get noReviewsYet => 'No reviews yet.';

  @override
  String get loginToRateProperty => 'Log in to rate and review this property.';

  @override
  String get ownerCannotReviewProperty =>
      'You cannot review your own property.';

  @override
  String get reviewSubmittedSuccess => 'Thanks! Your review was submitted.';

  @override
  String get reviewUpdatedSuccess => 'Your review has been updated.';

  @override
  String get reviewSubmitError => 'Could not submit review. Please try again.';

  @override
  String get yourReviewLabel => 'Your review';

  @override
  String get reviewerLabel => 'Reviewer';

  @override
  String get ratingJustNow => 'Just now';

  @override
  String ratingSummary(int ratingsCount, int reviewsCount) {
    return '$ratingsCount ratings, $reviewsCount reviews';
  }

  @override
  String get home => 'Home';

  @override
  String get favorites => 'Favorite';

  @override
  String get saved => 'Saved';

  @override
  String get myAds => 'My ads';

  @override
  String get profile => 'Profile';

  @override
  String get location => 'Location';

  @override
  String get priceRange => 'Price Range';

  @override
  String get propertyType => 'Property Type';

  @override
  String get bedrooms => 'Bedrooms';

  @override
  String get bathrooms => 'Bathrooms';

  @override
  String get amenities => 'Amenities';

  @override
  String get search => 'Search';

  @override
  String get description => 'Description';

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get bookNow => 'Book Now';

  @override
  String get booking => 'Booking';

  @override
  String get checkIn => 'Check-in';

  @override
  String get checkOut => 'Check-out';

  @override
  String get guests => 'Guests';

  @override
  String get total => 'Total';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get addNewAd => 'Add New Ad';

  @override
  String get title => 'Title';

  @override
  String get rentalType => 'Rental Type';

  @override
  String get furnished => 'Furnished';

  @override
  String get unfurnished => 'Unfurnished';

  @override
  String get next => 'Next';

  @override
  String get continueLabel => 'Continue';

  @override
  String get propertyPhotos => 'Property photos';

  @override
  String get addVideo => 'Add Video';

  @override
  String get pricePerMonth => 'Price per month';

  @override
  String get utilitiesIncluded => 'Utilities included';

  @override
  String get publish => 'Publish';

  @override
  String get publishAd => 'Publish Ad';

  @override
  String get recentChats => 'Recent Chats';

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get wallet => 'Wallet';

  @override
  String get inviteFriends => 'Invite Friends';

  @override
  String get language => 'Language';

  @override
  String get help => 'Help';

  @override
  String get logout => 'Logout';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get address => 'Address';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get wifi => 'Wifi';

  @override
  String get ac => 'AC';

  @override
  String get balcony => 'Balcony';

  @override
  String get parking => 'Parking';

  @override
  String get garden => 'Garden';

  @override
  String get pool => 'Pool';

  @override
  String get gym => 'Gym';

  @override
  String get laundry => 'Laundry';

  @override
  String get flat => 'Flat';

  @override
  String get villa => 'Villa';

  @override
  String get room => 'Room';

  @override
  String perMonth(String price) {
    return '$price EGP / month';
  }

  @override
  String get sell => 'Sell';

  @override
  String get skipForNow => 'Skip now -->';

  @override
  String get findYourPerfectHome => 'Find Your Perfect Home';

  @override
  String get edit => 'Edit';

  @override
  String get fullName => 'Full Name';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get security => 'Security';

  @override
  String get accountSettings => 'Account Settings';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get propertyManagement => 'Property Management';

  @override
  String get myActiveAds => 'My Active Ads';

  @override
  String propertiesCurrentlyLive(String count) {
    return '$count properties currently live';
  }

  @override
  String get savedProperties => 'Saved Properties';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get available => 'Available';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get shared => 'SHARED';

  @override
  String get private => 'PRIVATE';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get addAdMediaSourceTitle => 'Choose source';

  @override
  String get back => 'Back';

  @override
  String get addAdStepPropertyType => 'Property Type';

  @override
  String get addAdStepLocation => 'Location';

  @override
  String get addAdStepDetails => 'Details & Amenities';

  @override
  String get addAdStepMedia => 'Media Upload';

  @override
  String get addAdStepReview => 'Review & Publish';

  @override
  String get addAdWhatRenting => 'What are you renting?';

  @override
  String get addAdWhoCanRent => 'Who can rent this place?';

  @override
  String get addAdPreferredFieldOfStudy => 'Preferred field of study';

  @override
  String get addAdRentingSingleBed => 'Single Bed';

  @override
  String get addAdRentingPrivateRoom => 'Private room';

  @override
  String get addAdRentingEntireApartment => 'Entire apartment';

  @override
  String get addAdRentingStudio => 'Studio';

  @override
  String get addAdMale => 'Male';

  @override
  String get addAdFemale => 'Female';

  @override
  String get addAdLocationDetails => 'Location Details';

  @override
  String get addAdLocationDetailsSubtitle =>
      'Help students find your place. Pick governorate, district, and pin the exact spot.';

  @override
  String get addAdGovernorate => 'Governorate';

  @override
  String get addAdSelectGovernorate => 'Select governorate';

  @override
  String get addAdDistrict => 'Area / District';

  @override
  String get addAdSelectDistrict => 'Select district';

  @override
  String get addAdExtractLocation => 'Extract Location';

  @override
  String get addAdUseCurrentLocation => 'Use current location';

  @override
  String get addAdTapMapToAdjustPin => 'Tap map to adjust pin location';

  @override
  String get addAdDetailsAndAmenities => 'Details & Amenities';

  @override
  String get addAdDetailsSubtitle =>
      'Set rent, capacity, size, and what you offer.';

  @override
  String get addAdMonthlyRent => 'Monthly rent';

  @override
  String get addAdRentHint => '0.00';

  @override
  String get addAdMonthlySuffix => 'Monthly';

  @override
  String get addAdTotalBeds => 'TOTAL BEDS';

  @override
  String get addAdBedsAvailable => 'BEDS AVAILABLE';

  @override
  String get addAdContractTitle => 'Apartment contract';

  @override
  String get addAdContractHint =>
      'Upload a photo of the rental contract for verification. This will not be shown to users.';

  @override
  String get addAdContractTapToUpload => 'Tap to upload contract image';

  @override
  String get addAdContractRequiredWarning =>
      'A contract image is required before you can continue.';

  @override
  String get addAdContractUploaded => 'Contract uploaded for verification';

  @override
  String get addAdTestPayment => 'Test payment (MyFatoorah)';

  @override
  String get addAdTestPaymentTitle => 'Payment';

  @override
  String get addAdTestPaymentLoading => 'Creating test invoice…';

  @override
  String get addAdTestPaymentSandboxHint =>
      'Sandbox mode — use MyFatoorah test cards. No real charge.';

  @override
  String get addAdTestPaymentSuccess => 'Test payment completed.';

  @override
  String get addAdTestPaymentCancelled => 'Test payment was not completed.';

  @override
  String get addAdTestPaymentError =>
      'Could not start test payment. Check your connection and try again.';

  @override
  String get addAdTestPaymentRetry => 'Try again';

  @override
  String get addAdNationalIdTitle => 'National ID';

  @override
  String get addAdNationalIdHint =>
      'Upload front and back photos of your national ID for verification. These will not be shown to users.';

  @override
  String get addAdNationalIdFrontLabel => 'Front';

  @override
  String get addAdNationalIdBackLabel => 'Back';

  @override
  String get addAdNationalIdFrontTapToUpload => 'Tap to upload front';

  @override
  String get addAdNationalIdBackTapToUpload => 'Tap to upload back';

  @override
  String get addAdNationalIdRequiredWarning =>
      'Front and back national ID images are required before you can continue.';

  @override
  String get addAdNationalIdUploaded => 'National ID uploaded for verification';

  @override
  String get addAdRoomSize => 'ROOM SIZE';

  @override
  String get addAdSqmSuffix => 'sqm (m²)';

  @override
  String get addAdMediaUpload => 'Media Upload';

  @override
  String get addAdMediaSubtitle => 'Almost done! Add some visuals';

  @override
  String addAdPhotosUploaded(String count, String max) {
    return '$count/$max Uploaded';
  }

  @override
  String get addAdAddPhoto => 'Add Photo';

  @override
  String get addAdMinTwoPhotosWarning =>
      'Minimum 2 photos required. Higher quality attracts more students.';

  @override
  String get addAdUploadPropertyVideo => 'Upload a property video';

  @override
  String get addAdVideoFormats => 'MP4, MOV up to 50MB';

  @override
  String get addAdReviewPublish => 'Review & Publish';

  @override
  String get addAdListingSummary => 'Listing Summary';

  @override
  String get addAdDetailsAmenitiesSection => 'Details & Amenities';

  @override
  String get addAdLocationSection => 'Location Details';

  @override
  String get addAdMediaOverview => 'Media Overview';

  @override
  String addAdOpenTo(String gender) {
    return 'Open to: $gender';
  }

  @override
  String addAdPreferredField(String fields) {
    return 'Preferred Field: $fields';
  }

  @override
  String addAdPerBed(String price) {
    return 'EGP $price / Per Bed';
  }

  @override
  String addAdPriceMonthlyShort(String price) {
    return 'EGP $price / mo';
  }

  @override
  String get addAdStudyEngineering => 'Engineering';

  @override
  String get addAdStudyEducation => 'Education';

  @override
  String get addAdStudySales => 'Sales';

  @override
  String get addAdStudyLaw => 'Law';

  @override
  String get addAdStudyFinance => 'Finance';

  @override
  String get addAdStudyMedicine => 'Medicine';

  @override
  String get addAdStudyMarketing => 'Marketing';

  @override
  String get addAdStudyPsychology => 'Psychology';

  @override
  String get addAdStudyArchitecture => 'Architecture';

  @override
  String get addAdStudyNursing => 'Nursing';

  @override
  String get addAdStudyBusiness => 'Business';

  @override
  String get addAdStudyIt => 'IT';

  @override
  String get addAdStudyOpenToAll => 'Open to all';

  @override
  String get addAmenityKitchen => 'Kitchen';

  @override
  String get addAmenityStudyDesk => 'Study desk';

  @override
  String get addAdContinue => 'Continue';

  @override
  String get addAdPublishListing => 'Publish';

  @override
  String get addAdVideoTooLarge => 'Video must be 50MB or smaller';

  @override
  String get addAdLocationPermissionDenied => 'Location permission denied';

  @override
  String get addAdLocationServicesOff => 'Location services are disabled';

  @override
  String get addAdPublishingTitle => 'Publishing your listing…';

  @override
  String addAdUploadProgressPercent(int percent) {
    return '$percent%';
  }

  @override
  String get addAdListingPublishedTitle => 'Listing published!';

  @override
  String get addAdListingPublishedSubtitle =>
      'Your property is live for users to discover.';

  @override
  String get addAdPublishSuccessDone => 'Back to home';

  @override
  String get addAdPublishErrorGeneric =>
      'Something went wrong while publishing. Please try again.';

  @override
  String get addAdPublishErrorUnauthorized =>
      'Upload was rejected. Check your Cloudinary settings.';

  @override
  String get addAdPublishErrorNetwork =>
      'Could not reach the server. Check your connection.';

  @override
  String get addAdPublishErrorNotSignedIn =>
      'You must be signed in to publish.';

  @override
  String get addAdPublishErrorNotConfigured =>
      'Upload is not configured. Add Cloudinary keys to your build.';
}
