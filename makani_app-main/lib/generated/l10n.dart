import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_ar.dart';
import 'l10n_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Makani'**
  String get appName;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @welcomeToMakani.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Makani'**
  String get welcomeToMakani;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// No description provided for @orLoginWith.
  ///
  /// In en, this message translates to:
  /// **'Or login with'**
  String get orLoginWith;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get loginWithGoogle;

  /// No description provided for @newToMakaniSignUp.
  ///
  /// In en, this message translates to:
  /// **'New to Makani?'**
  String get newToMakaniSignUp;

  /// No description provided for @alreadyHaveAccountLogin.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccountLogin;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @enterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter OTP'**
  String get enterOtp;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @otpSentToEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter the OTP sent to your email:'**
  String get otpSentToEmail;

  /// No description provided for @havenGotOtpYet.
  ///
  /// In en, this message translates to:
  /// **'Haven\'t got the otp yet?'**
  String get havenGotOtpYet;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend otp'**
  String get resendOtp;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify code'**
  String get verifyCode;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set new password'**
  String get setNewPassword;

  /// No description provided for @passwordReset.
  ///
  /// In en, this message translates to:
  /// **'Password reset'**
  String get passwordReset;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to login'**
  String get goToLogin;

  /// No description provided for @successful.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get successful;

  /// No description provided for @passwordUpdatedSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Your password has been successfully updated. Click Continue to login'**
  String get passwordUpdatedSuccessMessage;

  /// No description provided for @passwordResetEmailSentMessage.
  ///
  /// In en, this message translates to:
  /// **'A password reset email has been sent to your email. Use it to update your password, then try logging in with your new password.\n\nIf you do not see the email, check your spam/junk folder.'**
  String get passwordResetEmailSentMessage;

  /// No description provided for @hiUser.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name}'**
  String hiUser(String name);

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String helloUser(String name);

  /// No description provided for @searchLocationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search location, area...'**
  String get searchLocationPlaceholder;

  /// No description provided for @defaultAddress.
  ///
  /// In en, this message translates to:
  /// **'23 El-Gomhoria Street, Al-Arab District, Port Said 42511, Egypt'**
  String get defaultAddress;

  /// No description provided for @aiRecommendation.
  ///
  /// In en, this message translates to:
  /// **'AI Recommendation'**
  String get aiRecommendation;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @popularListing.
  ///
  /// In en, this message translates to:
  /// **'Popular Listing'**
  String get popularListing;

  /// No description provided for @maleOnly.
  ///
  /// In en, this message translates to:
  /// **'Male Only'**
  String get maleOnly;

  /// No description provided for @femaleOnly.
  ///
  /// In en, this message translates to:
  /// **'Female Only'**
  String get femaleOnly;

  /// No description provided for @bedsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Beds'**
  String bedsCount(String count);

  /// No description provided for @bedsAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} beds available'**
  String bedsAvailable(String count);

  /// No description provided for @bathsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Baths'**
  String bathsCount(String count);

  /// No description provided for @searchForFlat.
  ///
  /// In en, this message translates to:
  /// **'Search for a flat'**
  String get searchForFlat;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @profession.
  ///
  /// In en, this message translates to:
  /// **'Profession'**
  String get profession;

  /// No description provided for @searchProfession.
  ///
  /// In en, this message translates to:
  /// **'Search Profession....'**
  String get searchProfession;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @minPrice.
  ///
  /// In en, this message translates to:
  /// **'Min Price'**
  String get minPrice;

  /// No description provided for @maxPrice.
  ///
  /// In en, this message translates to:
  /// **'Max Price'**
  String get maxPrice;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @getDirections.
  ///
  /// In en, this message translates to:
  /// **'Get Directions'**
  String get getDirections;

  /// No description provided for @reportListing.
  ///
  /// In en, this message translates to:
  /// **'Report Listing'**
  String get reportListing;

  /// No description provided for @whyReportingListing.
  ///
  /// In en, this message translates to:
  /// **'Why are you reporting this listing?'**
  String get whyReportingListing;

  /// No description provided for @incorrectPrice.
  ///
  /// In en, this message translates to:
  /// **'Incorrect price'**
  String get incorrectPrice;

  /// No description provided for @alreadyRented.
  ///
  /// In en, this message translates to:
  /// **'Already rented'**
  String get alreadyRented;

  /// No description provided for @fakeListing.
  ///
  /// In en, this message translates to:
  /// **'Fake listing'**
  String get fakeListing;

  /// No description provided for @inappropriateContent.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate content'**
  String get inappropriateContent;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @availableNow.
  ///
  /// In en, this message translates to:
  /// **'Available Now'**
  String get availableNow;

  /// No description provided for @contactOwner.
  ///
  /// In en, this message translates to:
  /// **'Contact Owner'**
  String get contactOwner;

  /// No description provided for @reserve.
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get reserve;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @readLess.
  ///
  /// In en, this message translates to:
  /// **'Read less'**
  String get readLess;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @ratings.
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get ratings;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @writeReview.
  ///
  /// In en, this message translates to:
  /// **'Write a review'**
  String get writeReview;

  /// No description provided for @editYourReview.
  ///
  /// In en, this message translates to:
  /// **'Edit your review'**
  String get editYourReview;

  /// No description provided for @tapToRate.
  ///
  /// In en, this message translates to:
  /// **'Tap a star to rate this property'**
  String get tapToRate;

  /// No description provided for @shareYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Share your experience (optional)'**
  String get shareYourExperience;

  /// No description provided for @submitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit review'**
  String get submitReview;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet.'**
  String get noReviewsYet;

  /// No description provided for @loginToRateProperty.
  ///
  /// In en, this message translates to:
  /// **'Log in to rate and review this property.'**
  String get loginToRateProperty;

  /// No description provided for @ownerCannotReviewProperty.
  ///
  /// In en, this message translates to:
  /// **'You cannot review your own property.'**
  String get ownerCannotReviewProperty;

  /// No description provided for @reviewSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thanks! Your review was submitted.'**
  String get reviewSubmittedSuccess;

  /// No description provided for @reviewUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your review has been updated.'**
  String get reviewUpdatedSuccess;

  /// No description provided for @reviewSubmitError.
  ///
  /// In en, this message translates to:
  /// **'Could not submit review. Please try again.'**
  String get reviewSubmitError;

  /// No description provided for @yourReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Your review'**
  String get yourReviewLabel;

  /// No description provided for @reviewerLabel.
  ///
  /// In en, this message translates to:
  /// **'Reviewer'**
  String get reviewerLabel;

  /// No description provided for @ratingJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get ratingJustNow;

  /// No description provided for @ratingSummary.
  ///
  /// In en, this message translates to:
  /// **'{ratingsCount} ratings, {reviewsCount} reviews'**
  String ratingSummary(int ratingsCount, int reviewsCount);

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorites;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @myAds.
  ///
  /// In en, this message translates to:
  /// **'My ads'**
  String get myAds;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @propertyType.
  ///
  /// In en, this message translates to:
  /// **'Property Type'**
  String get propertyType;

  /// No description provided for @bedrooms.
  ///
  /// In en, this message translates to:
  /// **'Bedrooms'**
  String get bedrooms;

  /// No description provided for @bathrooms.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get bathrooms;

  /// No description provided for @amenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenities;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMap;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @booking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get booking;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get checkOut;

  /// No description provided for @guests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guests;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @addNewAd.
  ///
  /// In en, this message translates to:
  /// **'Add New Ad'**
  String get addNewAd;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @rentalType.
  ///
  /// In en, this message translates to:
  /// **'Rental Type'**
  String get rentalType;

  /// No description provided for @furnished.
  ///
  /// In en, this message translates to:
  /// **'Furnished'**
  String get furnished;

  /// No description provided for @unfurnished.
  ///
  /// In en, this message translates to:
  /// **'Unfurnished'**
  String get unfurnished;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @propertyPhotos.
  ///
  /// In en, this message translates to:
  /// **'Property photos'**
  String get propertyPhotos;

  /// No description provided for @addVideo.
  ///
  /// In en, this message translates to:
  /// **'Add Video'**
  String get addVideo;

  /// No description provided for @pricePerMonth.
  ///
  /// In en, this message translates to:
  /// **'Price per month'**
  String get pricePerMonth;

  /// No description provided for @utilitiesIncluded.
  ///
  /// In en, this message translates to:
  /// **'Utilities included'**
  String get utilitiesIncluded;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @publishAd.
  ///
  /// In en, this message translates to:
  /// **'Publish Ad'**
  String get publishAd;

  /// No description provided for @recentChats.
  ///
  /// In en, this message translates to:
  /// **'Recent Chats'**
  String get recentChats;

  /// No description provided for @myFavorites.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get myFavorites;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @inviteFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite Friends'**
  String get inviteFriends;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @wifi.
  ///
  /// In en, this message translates to:
  /// **'Wifi'**
  String get wifi;

  /// No description provided for @ac.
  ///
  /// In en, this message translates to:
  /// **'AC'**
  String get ac;

  /// No description provided for @balcony.
  ///
  /// In en, this message translates to:
  /// **'Balcony'**
  String get balcony;

  /// No description provided for @parking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parking;

  /// No description provided for @garden.
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get garden;

  /// No description provided for @pool.
  ///
  /// In en, this message translates to:
  /// **'Pool'**
  String get pool;

  /// No description provided for @gym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get gym;

  /// No description provided for @laundry.
  ///
  /// In en, this message translates to:
  /// **'Laundry'**
  String get laundry;

  /// No description provided for @flat.
  ///
  /// In en, this message translates to:
  /// **'Flat'**
  String get flat;

  /// No description provided for @villa.
  ///
  /// In en, this message translates to:
  /// **'Villa'**
  String get villa;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'{price} EGP / month'**
  String perMonth(String price);

  /// No description provided for @sell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get sell;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip now -->'**
  String get skipForNow;

  /// No description provided for @findYourPerfectHome.
  ///
  /// In en, this message translates to:
  /// **'Find Your Perfect Home'**
  String get findYourPerfectHome;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @propertyManagement.
  ///
  /// In en, this message translates to:
  /// **'Property Management'**
  String get propertyManagement;

  /// No description provided for @myActiveAds.
  ///
  /// In en, this message translates to:
  /// **'My Active Ads'**
  String get myActiveAds;

  /// No description provided for @propertiesCurrentlyLive.
  ///
  /// In en, this message translates to:
  /// **'{count} properties currently live'**
  String propertiesCurrentlyLive(String count);

  /// No description provided for @savedProperties.
  ///
  /// In en, this message translates to:
  /// **'Saved Properties'**
  String get savedProperties;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @shared.
  ///
  /// In en, this message translates to:
  /// **'SHARED'**
  String get shared;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'PRIVATE'**
  String get private;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @addAdMediaSourceTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose source'**
  String get addAdMediaSourceTitle;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @addAdStepPropertyType.
  ///
  /// In en, this message translates to:
  /// **'Property Type'**
  String get addAdStepPropertyType;

  /// No description provided for @addAdStepLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get addAdStepLocation;

  /// No description provided for @addAdStepDetails.
  ///
  /// In en, this message translates to:
  /// **'Details & Amenities'**
  String get addAdStepDetails;

  /// No description provided for @addAdStepMedia.
  ///
  /// In en, this message translates to:
  /// **'Media Upload'**
  String get addAdStepMedia;

  /// No description provided for @addAdStepReview.
  ///
  /// In en, this message translates to:
  /// **'Review & Publish'**
  String get addAdStepReview;

  /// No description provided for @addAdWhatRenting.
  ///
  /// In en, this message translates to:
  /// **'What are you renting?'**
  String get addAdWhatRenting;

  /// No description provided for @addAdWhoCanRent.
  ///
  /// In en, this message translates to:
  /// **'Who can rent this place?'**
  String get addAdWhoCanRent;

  /// No description provided for @addAdPreferredFieldOfStudy.
  ///
  /// In en, this message translates to:
  /// **'Preferred field of study'**
  String get addAdPreferredFieldOfStudy;

  /// No description provided for @addAdRentingSingleBed.
  ///
  /// In en, this message translates to:
  /// **'Single Bed'**
  String get addAdRentingSingleBed;

  /// No description provided for @addAdRentingPrivateRoom.
  ///
  /// In en, this message translates to:
  /// **'Private room'**
  String get addAdRentingPrivateRoom;

  /// No description provided for @addAdRentingEntireApartment.
  ///
  /// In en, this message translates to:
  /// **'Entire apartment'**
  String get addAdRentingEntireApartment;

  /// No description provided for @addAdRentingStudio.
  ///
  /// In en, this message translates to:
  /// **'Studio'**
  String get addAdRentingStudio;

  /// No description provided for @addAdMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get addAdMale;

  /// No description provided for @addAdFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get addAdFemale;

  /// No description provided for @addAdLocationDetails.
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get addAdLocationDetails;

  /// No description provided for @addAdLocationDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help students find your place. Pick governorate, district, and pin the exact spot.'**
  String get addAdLocationDetailsSubtitle;

  /// No description provided for @addAdGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get addAdGovernorate;

  /// No description provided for @addAdSelectGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Select governorate'**
  String get addAdSelectGovernorate;

  /// No description provided for @addAdDistrict.
  ///
  /// In en, this message translates to:
  /// **'Area / District'**
  String get addAdDistrict;

  /// No description provided for @addAdSelectDistrict.
  ///
  /// In en, this message translates to:
  /// **'Select district'**
  String get addAdSelectDistrict;

  /// No description provided for @addAdExtractLocation.
  ///
  /// In en, this message translates to:
  /// **'Extract Location'**
  String get addAdExtractLocation;

  /// No description provided for @addAdUseCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get addAdUseCurrentLocation;

  /// No description provided for @addAdTapMapToAdjustPin.
  ///
  /// In en, this message translates to:
  /// **'Tap map to adjust pin location'**
  String get addAdTapMapToAdjustPin;

  /// No description provided for @addAdDetailsAndAmenities.
  ///
  /// In en, this message translates to:
  /// **'Details & Amenities'**
  String get addAdDetailsAndAmenities;

  /// No description provided for @addAdDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set rent, capacity, size, and what you offer.'**
  String get addAdDetailsSubtitle;

  /// No description provided for @addAdMonthlyRent.
  ///
  /// In en, this message translates to:
  /// **'Monthly rent'**
  String get addAdMonthlyRent;

  /// No description provided for @addAdRentHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get addAdRentHint;

  /// No description provided for @addAdMonthlySuffix.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get addAdMonthlySuffix;

  /// No description provided for @addAdTotalBeds.
  ///
  /// In en, this message translates to:
  /// **'TOTAL BEDS'**
  String get addAdTotalBeds;

  /// No description provided for @addAdBedsAvailable.
  ///
  /// In en, this message translates to:
  /// **'BEDS AVAILABLE'**
  String get addAdBedsAvailable;

  /// No description provided for @addAdContractTitle.
  ///
  /// In en, this message translates to:
  /// **'Apartment contract'**
  String get addAdContractTitle;

  /// No description provided for @addAdContractHint.
  ///
  /// In en, this message translates to:
  /// **'Upload a photo of the rental contract for verification. This will not be shown to users.'**
  String get addAdContractHint;

  /// No description provided for @addAdContractTapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload contract image'**
  String get addAdContractTapToUpload;

  /// No description provided for @addAdContractRequiredWarning.
  ///
  /// In en, this message translates to:
  /// **'A contract image is required before you can continue.'**
  String get addAdContractRequiredWarning;

  /// No description provided for @addAdContractUploaded.
  ///
  /// In en, this message translates to:
  /// **'Contract uploaded for verification'**
  String get addAdContractUploaded;

  /// No description provided for @addAdTestPayment.
  ///
  /// In en, this message translates to:
  /// **'Test payment (MyFatoorah)'**
  String get addAdTestPayment;

  /// No description provided for @addAdTestPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get addAdTestPaymentTitle;

  /// No description provided for @addAdTestPaymentLoading.
  ///
  /// In en, this message translates to:
  /// **'Creating test invoice…'**
  String get addAdTestPaymentLoading;

  /// No description provided for @addAdTestPaymentSandboxHint.
  ///
  /// In en, this message translates to:
  /// **'Sandbox mode — use MyFatoorah test cards. No real charge.'**
  String get addAdTestPaymentSandboxHint;

  /// No description provided for @addAdTestPaymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Test payment completed.'**
  String get addAdTestPaymentSuccess;

  /// No description provided for @addAdTestPaymentCancelled.
  ///
  /// In en, this message translates to:
  /// **'Test payment was not completed.'**
  String get addAdTestPaymentCancelled;

  /// No description provided for @addAdTestPaymentError.
  ///
  /// In en, this message translates to:
  /// **'Could not start test payment. Check your connection and try again.'**
  String get addAdTestPaymentError;

  /// No description provided for @addAdTestPaymentRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get addAdTestPaymentRetry;

  /// No description provided for @addAdNationalIdTitle.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get addAdNationalIdTitle;

  /// No description provided for @addAdNationalIdHint.
  ///
  /// In en, this message translates to:
  /// **'Upload front and back photos of your national ID for verification. These will not be shown to users.'**
  String get addAdNationalIdHint;

  /// No description provided for @addAdNationalIdFrontLabel.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get addAdNationalIdFrontLabel;

  /// No description provided for @addAdNationalIdBackLabel.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get addAdNationalIdBackLabel;

  /// No description provided for @addAdNationalIdFrontTapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload front'**
  String get addAdNationalIdFrontTapToUpload;

  /// No description provided for @addAdNationalIdBackTapToUpload.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload back'**
  String get addAdNationalIdBackTapToUpload;

  /// No description provided for @addAdNationalIdRequiredWarning.
  ///
  /// In en, this message translates to:
  /// **'Front and back national ID images are required before you can continue.'**
  String get addAdNationalIdRequiredWarning;

  /// No description provided for @addAdNationalIdUploaded.
  ///
  /// In en, this message translates to:
  /// **'National ID uploaded for verification'**
  String get addAdNationalIdUploaded;

  /// No description provided for @addAdRoomSize.
  ///
  /// In en, this message translates to:
  /// **'ROOM SIZE'**
  String get addAdRoomSize;

  /// No description provided for @addAdSqmSuffix.
  ///
  /// In en, this message translates to:
  /// **'sqm (m²)'**
  String get addAdSqmSuffix;

  /// No description provided for @addAdMediaUpload.
  ///
  /// In en, this message translates to:
  /// **'Media Upload'**
  String get addAdMediaUpload;

  /// No description provided for @addAdMediaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Almost done! Add some visuals'**
  String get addAdMediaSubtitle;

  /// No description provided for @addAdPhotosUploaded.
  ///
  /// In en, this message translates to:
  /// **'{count}/{max} Uploaded'**
  String addAdPhotosUploaded(String count, String max);

  /// No description provided for @addAdAddPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get addAdAddPhoto;

  /// No description provided for @addAdMinTwoPhotosWarning.
  ///
  /// In en, this message translates to:
  /// **'Minimum 2 photos required. Higher quality attracts more students.'**
  String get addAdMinTwoPhotosWarning;

  /// No description provided for @addAdUploadPropertyVideo.
  ///
  /// In en, this message translates to:
  /// **'Upload a property video'**
  String get addAdUploadPropertyVideo;

  /// No description provided for @addAdVideoFormats.
  ///
  /// In en, this message translates to:
  /// **'MP4, MOV up to 50MB'**
  String get addAdVideoFormats;

  /// No description provided for @addAdReviewPublish.
  ///
  /// In en, this message translates to:
  /// **'Review & Publish'**
  String get addAdReviewPublish;

  /// No description provided for @addAdListingSummary.
  ///
  /// In en, this message translates to:
  /// **'Listing Summary'**
  String get addAdListingSummary;

  /// No description provided for @addAdDetailsAmenitiesSection.
  ///
  /// In en, this message translates to:
  /// **'Details & Amenities'**
  String get addAdDetailsAmenitiesSection;

  /// No description provided for @addAdLocationSection.
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get addAdLocationSection;

  /// No description provided for @addAdMediaOverview.
  ///
  /// In en, this message translates to:
  /// **'Media Overview'**
  String get addAdMediaOverview;

  /// No description provided for @addAdOpenTo.
  ///
  /// In en, this message translates to:
  /// **'Open to: {gender}'**
  String addAdOpenTo(String gender);

  /// No description provided for @addAdPreferredField.
  ///
  /// In en, this message translates to:
  /// **'Preferred Field: {fields}'**
  String addAdPreferredField(String fields);

  /// No description provided for @addAdPerBed.
  ///
  /// In en, this message translates to:
  /// **'EGP {price} / Per Bed'**
  String addAdPerBed(String price);

  /// No description provided for @addAdPriceMonthlyShort.
  ///
  /// In en, this message translates to:
  /// **'EGP {price} / mo'**
  String addAdPriceMonthlyShort(String price);

  /// No description provided for @addAdStudyEngineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering'**
  String get addAdStudyEngineering;

  /// No description provided for @addAdStudyEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get addAdStudyEducation;

  /// No description provided for @addAdStudySales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get addAdStudySales;

  /// No description provided for @addAdStudyLaw.
  ///
  /// In en, this message translates to:
  /// **'Law'**
  String get addAdStudyLaw;

  /// No description provided for @addAdStudyFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get addAdStudyFinance;

  /// No description provided for @addAdStudyMedicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get addAdStudyMedicine;

  /// No description provided for @addAdStudyMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get addAdStudyMarketing;

  /// No description provided for @addAdStudyPsychology.
  ///
  /// In en, this message translates to:
  /// **'Psychology'**
  String get addAdStudyPsychology;

  /// No description provided for @addAdStudyArchitecture.
  ///
  /// In en, this message translates to:
  /// **'Architecture'**
  String get addAdStudyArchitecture;

  /// No description provided for @addAdStudyNursing.
  ///
  /// In en, this message translates to:
  /// **'Nursing'**
  String get addAdStudyNursing;

  /// No description provided for @addAdStudyBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get addAdStudyBusiness;

  /// No description provided for @addAdStudyIt.
  ///
  /// In en, this message translates to:
  /// **'IT'**
  String get addAdStudyIt;

  /// No description provided for @addAdStudyOpenToAll.
  ///
  /// In en, this message translates to:
  /// **'Open to all'**
  String get addAdStudyOpenToAll;

  /// No description provided for @addAmenityKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get addAmenityKitchen;

  /// No description provided for @addAmenityStudyDesk.
  ///
  /// In en, this message translates to:
  /// **'Study desk'**
  String get addAmenityStudyDesk;

  /// No description provided for @addAdContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get addAdContinue;

  /// No description provided for @addAdPublishListing.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get addAdPublishListing;

  /// No description provided for @addAdVideoTooLarge.
  ///
  /// In en, this message translates to:
  /// **'Video must be 50MB or smaller'**
  String get addAdVideoTooLarge;

  /// No description provided for @addAdLocationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied'**
  String get addAdLocationPermissionDenied;

  /// No description provided for @addAdLocationServicesOff.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled'**
  String get addAdLocationServicesOff;

  /// No description provided for @addAdPublishingTitle.
  ///
  /// In en, this message translates to:
  /// **'Publishing your listing…'**
  String get addAdPublishingTitle;

  /// No description provided for @addAdUploadProgressPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String addAdUploadProgressPercent(int percent);

  /// No description provided for @addAdListingPublishedTitle.
  ///
  /// In en, this message translates to:
  /// **'Listing published!'**
  String get addAdListingPublishedTitle;

  /// No description provided for @addAdListingPublishedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your property is live for users to discover.'**
  String get addAdListingPublishedSubtitle;

  /// No description provided for @addAdPublishSuccessDone.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get addAdPublishSuccessDone;

  /// No description provided for @addAdPublishErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while publishing. Please try again.'**
  String get addAdPublishErrorGeneric;

  /// No description provided for @addAdPublishErrorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Upload was rejected. Check your Cloudinary settings.'**
  String get addAdPublishErrorUnauthorized;

  /// No description provided for @addAdPublishErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the server. Check your connection.'**
  String get addAdPublishErrorNetwork;

  /// No description provided for @addAdPublishErrorNotSignedIn.
  ///
  /// In en, this message translates to:
  /// **'You must be signed in to publish.'**
  String get addAdPublishErrorNotSignedIn;

  /// No description provided for @addAdPublishErrorNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Upload is not configured. Add Cloudinary keys to your build.'**
  String get addAdPublishErrorNotConfigured;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
  }

  throw FlutterError(
      'S.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
