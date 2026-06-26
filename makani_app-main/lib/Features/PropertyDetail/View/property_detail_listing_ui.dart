import 'package:flutter/material.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_l10n_helpers.dart';
import 'package:makani_app/Features/Listings/Model/listing_presenter.dart';
import 'package:makani_app/Features/Listings/Model/property_listing.dart';
import 'package:makani_app/Features/PropertyDetail/View/Widgets/property_overview_tab.dart';
import 'package:makani_app/generated/l10n.dart';

IconData amenityIconForId(String id) {
  switch (id) {
    case 'wifi':
      return Icons.wifi;
    case 'ac':
      return Icons.ac_unit;
    case 'kitchen':
      return Icons.kitchen_outlined;
    case 'balcony':
      return Icons.balcony;
    case 'parking':
      return Icons.local_parking;
    case 'study_desk':
      return Icons.desk;
    default:
      return Icons.check_circle_outline;
  }
}

List<AmenityItem> listingAmenityItems(S s, PropertyListing p) {
  return p.amenityIds
      .map(
        (id) => AmenityItem(
          icon: amenityIconForId(id),
          label: addAdAmenityLabel(s, id),
        ),
      )
      .toList();
}

String listingOverviewDescription(S s, PropertyListing p) {
  final vm = listingToCardViewModel(s, p);
  final buf = StringBuffer();
  buf.writeln(vm.title);
  buf.writeln(vm.location);
  buf.writeln();
  final gender = parseGenderPreferenceKey(p.genderPreferenceKey);
  if (gender != null) {
    buf.writeln(s.addAdOpenTo(addAdGenderLabel(s, gender)));
  }
  if (p.studyFieldIds.isNotEmpty) {
    final fields =
        p.studyFieldIds.map((id) => addAdStudyLabel(s, id)).join(', ');
    buf.writeln(s.addAdPreferredField(fields));
  }
  buf.writeln();
  buf.writeln('${s.addAdMonthlyRent}: ${vm.price}');
  if (p.totalBeds != null) {
    buf.writeln('${s.addAdTotalBeds}: ${p.totalBeds}');
  }
  final available = p.bedsAvailable ?? p.totalBeds;
  if (available != null) {
    buf.writeln(s.bedsAvailable('$available'));
  }
  if (p.bathrooms != null) {
    buf.writeln(s.bathsCount(p.bathrooms!.toString()));
  }
  if (p.roomSizeSqm != null) {
    buf.writeln('${p.roomSizeSqm!.toStringAsFixed(0)} ${s.addAdSqmSuffix}');
  }
  if (p.governorate != null && p.governorate!.isNotEmpty) {
    buf.writeln('${s.addAdGovernorate}: ${p.governorate}');
  }
  if (p.district != null && p.district!.isNotEmpty) {
    buf.writeln('${s.addAdDistrict}: ${p.district}');
  }
  return buf.toString().trim();
}
