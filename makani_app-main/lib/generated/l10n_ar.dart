// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class SAr extends S {
  SAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'مكاني';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get welcomeToMakani => 'مرحباً بك في مكاني';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور';

  @override
  String get orLoginWith => 'أو سجّل الدخول باستخدام';

  @override
  String get loginWithGoogle => 'تسجيل الدخول بـ Google';

  @override
  String get newToMakaniSignUp => 'جديد على مكاني؟';

  @override
  String get alreadyHaveAccountLogin => 'لديك حساب؟';

  @override
  String get name => 'الاسم';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get enterOtp => 'أدخل الرمز';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String get verify => 'تحقق';

  @override
  String get otpSentToEmail =>
      'الرجاء إدخال الرمز المرسل إلى بريدك الإلكتروني:';

  @override
  String get havenGotOtpYet => 'لم يصلك الرمز بعد؟';

  @override
  String get resendOtp => 'إعادة إرسال الرمز';

  @override
  String get verifyCode => 'تحقق من الرمز';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get setNewPassword => 'تعيين كلمة المرور الجديدة';

  @override
  String get passwordReset => 'تم إعادة تعيين كلمة المرور';

  @override
  String get goToLogin => 'الذهاب لتسجيل الدخول';

  @override
  String get successful => 'تم بنجاح';

  @override
  String get passwordUpdatedSuccessMessage =>
      'تهانينا! تم تحديث كلمة المرور بنجاح. اضغط متابعة لتسجيل الدخول';

  @override
  String get passwordResetEmailSentMessage =>
      'تم إرسال رسالة إعادة تعيين كلمة المرور إلى بريدك الإلكتروني. استخدمها لتحديث كلمة المرور، ثم حاول تسجيل الدخول بكلمة المرور الجديدة.\n\nإذا لم تجد الرسالة، يرجى التحقق من مجلد الرسائل غير المرغوب فيها (Spam/Junk).';

  @override
  String hiUser(String name) {
    return 'أهلاً، $name';
  }

  @override
  String helloUser(String name) {
    return 'مرحباً، $name';
  }

  @override
  String get searchLocationPlaceholder => 'ابحث عن موقع، منطقة...';

  @override
  String get defaultAddress =>
      '23 شارع الجمهورية، حي العرب، بورسعيد 42511، مصر';

  @override
  String get aiRecommendation => 'اقتراحات الذكاء الاصطناعي';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get popularListing => 'الإعلانات الشائعة';

  @override
  String get maleOnly => 'ذكور فقط';

  @override
  String get femaleOnly => 'إناث فقط';

  @override
  String bedsCount(String count) {
    return '$count أسرّة';
  }

  @override
  String bedsAvailable(String count) {
    return '$count سرير متاح';
  }

  @override
  String bathsCount(String count) {
    return '$count حمامات';
  }

  @override
  String get searchForFlat => 'ابحث عن شقة';

  @override
  String get filter => 'تصفية';

  @override
  String get profession => 'المهنة';

  @override
  String get searchProfession => 'ابحث عن مهنة....';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get applyFilters => 'تطبيق الفلاتر';

  @override
  String get minPrice => 'الحد الأدنى للسعر';

  @override
  String get maxPrice => 'الحد الأقصى للسعر';

  @override
  String get rooms => 'الغرف';

  @override
  String get distance => 'المسافة';

  @override
  String get any => 'أي';

  @override
  String get getDirections => 'الحصول على الاتجاهات';

  @override
  String get reportListing => 'الإبلاغ عن الإعلان';

  @override
  String get whyReportingListing => 'لماذا تقوم بالإبلاغ عن هذا الإعلان؟';

  @override
  String get incorrectPrice => 'سعر غير صحيح';

  @override
  String get alreadyRented => 'تم تأجيره بالفعل';

  @override
  String get fakeListing => 'إعلان وهمي';

  @override
  String get inappropriateContent => 'محتوى غير لائق';

  @override
  String get other => 'أخرى';

  @override
  String get send => 'إرسال';

  @override
  String get availableNow => 'متاح الآن';

  @override
  String get contactOwner => 'تواصل مع المالك';

  @override
  String get reserve => 'احجز';

  @override
  String get readMore => 'اقرأ المزيد';

  @override
  String get readLess => 'عرض أقل';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get video => 'فيديو';

  @override
  String get ratings => 'التقييمات';

  @override
  String get reviews => 'المراجعات';

  @override
  String get writeReview => 'اكتب مراجعة';

  @override
  String get editYourReview => 'عدّل مراجعتك';

  @override
  String get tapToRate => 'اضغط على النجوم لتقييم هذا العقار';

  @override
  String get shareYourExperience => 'شارك تجربتك (اختياري)';

  @override
  String get submitReview => 'إرسال المراجعة';

  @override
  String get noReviewsYet => 'لا توجد مراجعات بعد.';

  @override
  String get loginToRateProperty =>
      'سجّل الدخول لإضافة تقييم ومراجعة لهذا العقار.';

  @override
  String get ownerCannotReviewProperty => 'لا يمكنك تقييم عقارك الخاص.';

  @override
  String get reviewSubmittedSuccess => 'شكرًا! تم إرسال مراجعتك.';

  @override
  String get reviewUpdatedSuccess => 'تم تحديث مراجعتك.';

  @override
  String get reviewSubmitError => 'تعذر إرسال المراجعة. حاول مرة أخرى.';

  @override
  String get yourReviewLabel => 'مراجعتك';

  @override
  String get reviewerLabel => 'مراجع';

  @override
  String get ratingJustNow => 'الآن';

  @override
  String ratingSummary(int ratingsCount, int reviewsCount) {
    return '$ratingsCount تقييم، $reviewsCount مراجعة';
  }

  @override
  String get home => 'الرئيسية';

  @override
  String get favorites => 'المفضلة';

  @override
  String get saved => 'المحفوظ';

  @override
  String get myAds => 'إعلاناتي';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get location => 'الموقع';

  @override
  String get priceRange => 'نطاق السعر';

  @override
  String get propertyType => 'نوع العقار';

  @override
  String get bedrooms => 'غرف النوم';

  @override
  String get bathrooms => 'الحمامات';

  @override
  String get amenities => 'المرافق';

  @override
  String get search => 'بحث';

  @override
  String get description => 'الوصف';

  @override
  String get viewOnMap => 'عرض على الخريطة';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get booking => 'الحجز';

  @override
  String get checkIn => 'تاريخ الوصول';

  @override
  String get checkOut => 'تاريخ المغادرة';

  @override
  String get guests => 'الضيوف';

  @override
  String get total => 'الإجمالي';

  @override
  String get confirmBooking => 'تأكيد الحجز';

  @override
  String get addNewAd => 'إضافة إعلان جديد';

  @override
  String get title => 'العنوان';

  @override
  String get rentalType => 'نوع الإيجار';

  @override
  String get furnished => 'مُؤثّث';

  @override
  String get unfurnished => 'غير مُؤثّث';

  @override
  String get next => 'التالي';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get propertyPhotos => 'صور العقار';

  @override
  String get addVideo => 'إضافة فيديو';

  @override
  String get pricePerMonth => 'السعر شهرياً';

  @override
  String get utilitiesIncluded => 'المرافق مشمولة';

  @override
  String get publish => 'نشر';

  @override
  String get publishAd => 'نشر الإعلان';

  @override
  String get recentChats => 'المحادثات الأخيرة';

  @override
  String get myFavorites => 'المفضلة';

  @override
  String get myBookings => 'حجوزاتي';

  @override
  String get wallet => 'المحفظة';

  @override
  String get inviteFriends => 'دعوة أصدقاء';

  @override
  String get language => 'اللغة';

  @override
  String get help => 'المساعدة';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get personalInformation => 'المعلومات الشخصية';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get address => 'العنوان';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get wifi => 'واي فاي';

  @override
  String get ac => 'تكييف';

  @override
  String get balcony => 'شرفة';

  @override
  String get parking => 'موقف سيارات';

  @override
  String get garden => 'حديقة';

  @override
  String get pool => 'مسبح';

  @override
  String get gym => 'جيم';

  @override
  String get laundry => 'غسيل';

  @override
  String get flat => 'شقة';

  @override
  String get villa => 'فيلا';

  @override
  String get room => 'غرفة';

  @override
  String perMonth(String price) {
    return '$price ج.م / شهر';
  }

  @override
  String get sell => 'بيع';

  @override
  String get skipForNow => 'تخطي الان -->';

  @override
  String get findYourPerfectHome => 'اعثر على منزلك المثالي';

  @override
  String get edit => 'تعديل';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get accountInformation => 'معلومات الحساب';

  @override
  String get security => 'الأمان';

  @override
  String get accountSettings => 'إعدادات الحساب';

  @override
  String get languageSettings => 'إعدادات اللغة';

  @override
  String get propertyManagement => 'إدارة العقارات';

  @override
  String get myActiveAds => 'إعلاناتي النشطة';

  @override
  String propertiesCurrentlyLive(String count) {
    return '$count عقارات نشطة حالياً';
  }

  @override
  String get savedProperties => 'العقارات المحفوظة';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get available => 'متاح';

  @override
  String get unavailable => 'غير متاح';

  @override
  String get shared => 'مشترك';

  @override
  String get private => 'خاص';

  @override
  String get camera => 'الكاميرا';

  @override
  String get gallery => 'المعرض';

  @override
  String get addAdMediaSourceTitle => 'اختر المصدر';

  @override
  String get back => 'رجوع';

  @override
  String get addAdStepPropertyType => 'نوع العقار';

  @override
  String get addAdStepLocation => 'الموقع';

  @override
  String get addAdStepDetails => 'التفاصيل والمرافق';

  @override
  String get addAdStepMedia => 'رفع الوسائط';

  @override
  String get addAdStepReview => 'مراجعة ونشر';

  @override
  String get addAdWhatRenting => 'ماذا تؤجر؟';

  @override
  String get addAdWhoCanRent => 'من يمكنه استئجار هذا المكان؟';

  @override
  String get addAdPreferredFieldOfStudy => 'مجال الدراسة المفضل';

  @override
  String get addAdRentingSingleBed => 'سرير مفرد';

  @override
  String get addAdRentingPrivateRoom => 'غرفة خاصة';

  @override
  String get addAdRentingEntireApartment => 'شقة كاملة';

  @override
  String get addAdRentingStudio => 'استوديو';

  @override
  String get addAdMale => 'ذكر';

  @override
  String get addAdFemale => 'أنثى';

  @override
  String get addAdLocationDetails => 'تفاصيل الموقع';

  @override
  String get addAdLocationDetailsSubtitle =>
      'ساعد الطلاب على إيجاد مكانك. اختر المحافظة والمنطقة وثبّت الموقع على الخريطة.';

  @override
  String get addAdGovernorate => 'المحافظة';

  @override
  String get addAdSelectGovernorate => 'اختر المحافظة';

  @override
  String get addAdDistrict => 'المنطقة / الحي';

  @override
  String get addAdSelectDistrict => 'اختر المنطقة';

  @override
  String get addAdExtractLocation => 'استخراج الموقع';

  @override
  String get addAdUseCurrentLocation => 'استخدام موقعي الحالي';

  @override
  String get addAdTapMapToAdjustPin => 'اضغط على الخريطة لضبط الدبوس';

  @override
  String get addAdDetailsAndAmenities => 'التفاصيل والمرافق';

  @override
  String get addAdDetailsSubtitle => 'حدد الإيجار، السعة، المساحة، وما تقدمه.';

  @override
  String get addAdMonthlyRent => 'الإيجار الشهري';

  @override
  String get addAdRentHint => '0.00';

  @override
  String get addAdMonthlySuffix => 'شهرياً';

  @override
  String get addAdTotalBeds => 'إجمالي الأسرّة';

  @override
  String get addAdBedsAvailable => 'الأسرّة المتاحة';

  @override
  String get addAdContractTitle => 'عقد الشقة';

  @override
  String get addAdContractHint =>
      'ارفع صورة عقد الإيجار للتحقق. لن تظهر للمستخدمين.';

  @override
  String get addAdContractTapToUpload => 'اضغط لرفع صورة العقد';

  @override
  String get addAdContractRequiredWarning => 'صورة العقد مطلوبة قبل المتابعة.';

  @override
  String get addAdContractUploaded => 'تم رفع العقد للتحقق';

  @override
  String get addAdTestPayment => 'دفع تجريبي (MyFatoorah)';

  @override
  String get addAdTestPaymentTitle => 'الدفع';

  @override
  String get addAdTestPaymentLoading => 'جاري إنشاء فاتورة تجريبية…';

  @override
  String get addAdTestPaymentSandboxHint =>
      'وضع تجريبي — استخدم بطاقات MyFatoorah التجريبية. لا يوجد خصم حقيقي.';

  @override
  String get addAdTestPaymentSuccess => 'تم إكمال الدفع التجريبي.';

  @override
  String get addAdTestPaymentCancelled => 'لم يكتمل الدفع التجريبي.';

  @override
  String get addAdTestPaymentError =>
      'تعذر بدء الدفع التجريبي. تحقق من الاتصال وحاول مرة أخرى.';

  @override
  String get addAdTestPaymentRetry => 'إعادة المحاولة';

  @override
  String get addAdNationalIdTitle => 'البطاقة الشخصية';

  @override
  String get addAdNationalIdHint =>
      'ارفع صورتي وجه وظهر البطاقة الشخصية للتحقق. لن تظهر للمستخدمين.';

  @override
  String get addAdNationalIdFrontLabel => 'الوجه';

  @override
  String get addAdNationalIdBackLabel => 'الظهر';

  @override
  String get addAdNationalIdFrontTapToUpload => 'اضغط لرفع الوجه';

  @override
  String get addAdNationalIdBackTapToUpload => 'اضغط لرفع الظهر';

  @override
  String get addAdNationalIdRequiredWarning =>
      'صور وجه وظهر البطاقة الشخصية مطلوبة قبل المتابعة.';

  @override
  String get addAdNationalIdUploaded => 'تم رفع البطاقة الشخصية للتحقق';

  @override
  String get addAdRoomSize => 'مساحة الغرفة';

  @override
  String get addAdSqmSuffix => 'م² (متر مربع)';

  @override
  String get addAdMediaUpload => 'رفع الوسائط';

  @override
  String get addAdMediaSubtitle => 'اقتربنا من النهاية! أضف صوراً';

  @override
  String addAdPhotosUploaded(String count, String max) {
    return '$count/$max مرفوع';
  }

  @override
  String get addAdAddPhoto => 'إضافة صورة';

  @override
  String get addAdMinTwoPhotosWarning =>
      'يلزم صورتان على الأقل. جودة أعلى تجذب المزيد من الطلاب.';

  @override
  String get addAdUploadPropertyVideo => 'ارفع فيديو للعقار';

  @override
  String get addAdVideoFormats => 'MP4 أو MOV حتى 50 ميجابايت';

  @override
  String get addAdReviewPublish => 'مراجعة ونشر';

  @override
  String get addAdListingSummary => 'ملخص الإعلان';

  @override
  String get addAdDetailsAmenitiesSection => 'التفاصيل والمرافق';

  @override
  String get addAdLocationSection => 'تفاصيل الموقع';

  @override
  String get addAdMediaOverview => 'نظرة على الوسائط';

  @override
  String addAdOpenTo(String gender) {
    return 'متاح لـ: $gender';
  }

  @override
  String addAdPreferredField(String fields) {
    return 'المجال المفضل: $fields';
  }

  @override
  String addAdPerBed(String price) {
    return '$price ج.م / لكل سرير';
  }

  @override
  String addAdPriceMonthlyShort(String price) {
    return '$price ج.م / شهر';
  }

  @override
  String get addAdStudyEngineering => 'هندسة';

  @override
  String get addAdStudyEducation => 'تربية';

  @override
  String get addAdStudySales => 'مبيعات';

  @override
  String get addAdStudyLaw => 'قانون';

  @override
  String get addAdStudyFinance => 'مالية';

  @override
  String get addAdStudyMedicine => 'طب';

  @override
  String get addAdStudyMarketing => 'تسويق';

  @override
  String get addAdStudyPsychology => 'علم نفس';

  @override
  String get addAdStudyArchitecture => 'عمارة';

  @override
  String get addAdStudyNursing => 'تمريض';

  @override
  String get addAdStudyBusiness => 'أعمال';

  @override
  String get addAdStudyIt => 'تقنية معلومات';

  @override
  String get addAdStudyOpenToAll => 'مفتوح للجميع';

  @override
  String get addAmenityKitchen => 'مطبخ';

  @override
  String get addAmenityStudyDesk => 'مكتب دراسة';

  @override
  String get addAdContinue => 'متابعة';

  @override
  String get addAdPublishListing => 'نشر';

  @override
  String get addAdVideoTooLarge => 'يجب ألا يتجاوز الفيديو 50 ميجابايت';

  @override
  String get addAdLocationPermissionDenied => 'تم رفض إذن الموقع';

  @override
  String get addAdLocationServicesOff => 'خدمات الموقع غير مفعّلة';

  @override
  String get addAdPublishingTitle => 'جاري نشر إعلانك…';

  @override
  String addAdUploadProgressPercent(int percent) {
    return '$percent٪';
  }

  @override
  String get addAdListingPublishedTitle => 'تم نشر الإعلان!';

  @override
  String get addAdListingPublishedSubtitle =>
      'عقارك متاح الآن ليطّلع عليه المستخدمين.';

  @override
  String get addAdPublishSuccessDone => 'العودة للرئيسية';

  @override
  String get addAdPublishErrorGeneric => 'حدث خطأ أثناء النشر. حاول مرة أخرى.';

  @override
  String get addAdPublishErrorUnauthorized =>
      'رفض الرفع. تحقق من إعدادات Cloudinary.';

  @override
  String get addAdPublishErrorNetwork =>
      'تعذّر الاتصال بالخادم. تحقق من الإنترنت.';

  @override
  String get addAdPublishErrorNotSignedIn => 'يجب تسجيل الدخول للنشر.';

  @override
  String get addAdPublishErrorNotConfigured =>
      'الرفع غير مهيأ. أضف مفاتيح Cloudinary للبناء.';
}
