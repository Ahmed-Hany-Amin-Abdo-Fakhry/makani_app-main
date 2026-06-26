
import 'package:flutter/material.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_enums.dart';
import 'package:makani_app/generated/l10n.dart';

String addAdStudyLabel(S s, String id) {
  switch (id) {
    case 'engineering':
      return s.addAdStudyEngineering;
    case 'education':
      return s.addAdStudyEducation;
    case 'sales':
      return s.addAdStudySales;
    case 'law':
      return s.addAdStudyLaw;
    case 'finance':
      return s.addAdStudyFinance;
    case 'medicine':
      return s.addAdStudyMedicine;
    case 'marketing':
      return s.addAdStudyMarketing;
    case 'psychology':
      return s.addAdStudyPsychology;
    case 'architecture':
      return s.addAdStudyArchitecture;
    case 'nursing':
      return s.addAdStudyNursing;
    case 'business':
      return s.addAdStudyBusiness;
    case 'it':
      return s.addAdStudyIt;
    case 'open_to_all':
      return s.addAdStudyOpenToAll;
    default:
      return id;
  }
}

String addAdGenderLabel(S s, AddAdGenderPreference g) {
  switch (g) {
    case AddAdGenderPreference.male:
      return s.addAdMale;
    case AddAdGenderPreference.female:
      return s.addAdFemale;
    case AddAdGenderPreference.any:
      return s.any;
  }
}

String addAdPropertyTypeLabel(S s, AddAdPropertyType t) {
  switch (t) {
    case AddAdPropertyType.singleBed:
      return s.addAdRentingSingleBed;
    case AddAdPropertyType.privateRoom:
      return s.addAdRentingPrivateRoom;
    case AddAdPropertyType.entireApartment:
      return s.addAdRentingEntireApartment;
    case AddAdPropertyType.studio:
      return s.addAdRentingStudio;
  }
}

IconData addAdPropertyTypeIcon(AddAdPropertyType t) {
  switch (t) {
    case AddAdPropertyType.singleBed:
      return Icons.single_bed_outlined;
    case AddAdPropertyType.privateRoom:
      return Icons.door_front_door_outlined;
    case AddAdPropertyType.entireApartment:
      return Icons.apartment_outlined;
    case AddAdPropertyType.studio:
      return Icons.weekend_outlined;
  }
}

String addAdAmenityLabel(S s, String id) {
  switch (id) {
    case 'wifi':
      return s.wifi;
    case 'ac':
      return s.ac;
    case 'kitchen':
      return s.addAmenityKitchen;
    case 'balcony':
      return s.balcony;
    case 'study_desk':
      return s.addAmenityStudyDesk;
    case 'parking':
      return s.parking;
    default:
      return id;
  }
}

String addAdPublishErrorMessage(S s, String? key) {
  switch (key) {
    case 'unauthorized':
      return s.addAdPublishErrorUnauthorized;
    case 'network':
      return s.addAdPublishErrorNetwork;
    case 'not_signed_in':
      return s.addAdPublishErrorNotSignedIn;
    case 'not_configured':
      return s.addAdPublishErrorNotConfigured;
    default:
      return s.addAdPublishErrorGeneric;
  }
}
