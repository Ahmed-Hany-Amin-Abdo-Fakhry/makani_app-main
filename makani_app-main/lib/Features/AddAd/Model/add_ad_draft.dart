import 'package:equatable/equatable.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_constants.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_enums.dart';

class AddAdDraft extends Equatable {
  AddAdDraft({
    this.propertyType,
    this.genderPreference = AddAdGenderPreference.male,
    this.studyFieldIds = const {},
    this.governorate,
    this.district,
    this.latitude,
    this.longitude,
    this.addressLine,
    this.monthlyRentText = '',
    this.utilitiesIncluded = false,
    this.totalBeds = 1,
    this.bedsAvailable = 1,
    this.bathrooms = 2,
    this.roomSizeText = '25',
    this.ownerPhone = '',
    this.amenityIds = const {},
    List<String>? photoSlots,
    this.videoPath,
    this.contractImagePath,
    this.nationalIdFrontPath,
    this.nationalIdBackPath,
  }) : photoSlots = photoSlots ??
            List<String>.filled(AddAdConstants.maxPhotos, '');

  final AddAdPropertyType? propertyType;
  final AddAdGenderPreference genderPreference;
  final Set<String> studyFieldIds;
  final String? governorate;
  final String? district;
  final double? latitude;
  final double? longitude;
  final String? addressLine;
  final String monthlyRentText;
  final bool utilitiesIncluded;
  final int totalBeds;
  final int bedsAvailable;
  final int bathrooms;
  final String roomSizeText;
  final String ownerPhone;
  final Set<String> amenityIds;
  /// Fixed slots; empty string means no photo at that index.
  final List<String> photoSlots;
  final String? videoPath;
  /// Local path or remote HTTPS URL for verification contract image.
  final String? contractImagePath;
  /// Local path or remote HTTPS URL for national ID front image.
  final String? nationalIdFrontPath;
  /// Local path or remote HTTPS URL for national ID back image.
  final String? nationalIdBackPath;

  int get filledPhotoCount =>
      photoSlots.where((p) => p.isNotEmpty).length;

  bool get hasContractImage =>
      contractImagePath != null && contractImagePath!.trim().isNotEmpty;

  bool get hasNationalIdFront =>
      nationalIdFrontPath != null && nationalIdFrontPath!.trim().isNotEmpty;

  bool get hasNationalIdBack =>
      nationalIdBackPath != null && nationalIdBackPath!.trim().isNotEmpty;

  bool get hasNationalIdImages => hasNationalIdFront && hasNationalIdBack;

  AddAdDraft copyWith({
    AddAdPropertyType? propertyType,
    AddAdGenderPreference? genderPreference,
    Set<String>? studyFieldIds,
    String? governorate,
    String? district,
    double? latitude,
    double? longitude,
    String? addressLine,
    String? monthlyRentText,
    bool? utilitiesIncluded,
    int? totalBeds,
    int? bedsAvailable,
    int? bathrooms,
    String? roomSizeText,
    String? ownerPhone,
    Set<String>? amenityIds,
    List<String>? photoSlots,
    String? videoPath,
    String? contractImagePath,
    String? nationalIdFrontPath,
    String? nationalIdBackPath,
    bool clearGovernorate = false,
    bool clearDistrict = false,
    bool clearVideo = false,
    bool clearCoordinates = false,
    bool clearContractImage = false,
    bool clearNationalIdFront = false,
    bool clearNationalIdBack = false,
  }) {
    return AddAdDraft(
      propertyType: propertyType ?? this.propertyType,
      genderPreference: genderPreference ?? this.genderPreference,
      studyFieldIds: studyFieldIds ?? this.studyFieldIds,
      governorate: clearGovernorate ? null : (governorate ?? this.governorate),
      district: clearDistrict ? null : (district ?? this.district),
      latitude: clearCoordinates ? null : (latitude ?? this.latitude),
      longitude: clearCoordinates ? null : (longitude ?? this.longitude),
      addressLine: addressLine ?? this.addressLine,
      monthlyRentText: monthlyRentText ?? this.monthlyRentText,
      utilitiesIncluded: utilitiesIncluded ?? this.utilitiesIncluded,
      totalBeds: totalBeds ?? this.totalBeds,
      bedsAvailable: bedsAvailable ?? this.bedsAvailable,
      bathrooms: bathrooms ?? this.bathrooms,
      roomSizeText: roomSizeText ?? this.roomSizeText,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      amenityIds: amenityIds ?? this.amenityIds,
      photoSlots: photoSlots ?? this.photoSlots,
      videoPath: clearVideo ? null : (videoPath ?? this.videoPath),
      contractImagePath: clearContractImage
          ? null
          : (contractImagePath ?? this.contractImagePath),
      nationalIdFrontPath: clearNationalIdFront
          ? null
          : (nationalIdFrontPath ?? this.nationalIdFrontPath),
      nationalIdBackPath: clearNationalIdBack
          ? null
          : (nationalIdBackPath ?? this.nationalIdBackPath),
    );
  }

  @override
  List<Object?> get props => [
        propertyType,
        genderPreference,
        studyFieldIds,
        governorate,
        district,
        latitude,
        longitude,
        addressLine,
        monthlyRentText,
        utilitiesIncluded,
        totalBeds,
        bedsAvailable,
        bathrooms,
        roomSizeText,
        ownerPhone,
        amenityIds,
        photoSlots,
        videoPath,
        contractImagePath,
        nationalIdFrontPath,
        nationalIdBackPath,
      ];
}
