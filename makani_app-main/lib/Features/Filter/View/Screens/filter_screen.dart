import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:makani_app/Core/Const/app_colors.dart';
import 'package:makani_app/Core/Const/localization_extension.dart';
import 'package:makani_app/Core/Widgets/primary_button.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_enums.dart';
import 'package:makani_app/Features/AddAd/View/Widgets/add_ad_l10n_helpers.dart';
import 'package:makani_app/Features/Filter/filter_profession_to_study_id.dart';
import 'package:makani_app/Features/Filter/View/Widgets/filter_distance_section.dart';
import 'package:makani_app/Features/Filter/View/Widgets/filter_price_section.dart';
import 'package:makani_app/Features/Filter/View/Widgets/filter_profession_section.dart';
import 'package:makani_app/Features/Filter/View/Widgets/filter_rooms_section.dart';
import 'package:makani_app/Features/Filter/View/Widgets/filter_section_card.dart';
import 'package:makani_app/Features/Listings/Model/listing_query.dart';
import 'package:makani_app/Features/Location/Cubit/user_location_cubit.dart';
import 'package:makani_app/Features/Location/Cubit/user_location_state.dart';

const List<String> _professionOptions = [
  'Engineering',
  'IT',
  'Education',
  'Medicine',
  'Marketing',
  'Nursing',
  'Sales',
  'Law',
  'Finance',
  'Business',
  'Architecture',
  'Psychology',
];

const List<String> _roomsOptions = ['Any', '1', '2', '3', '4+'];

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final _professionSearchController = TextEditingController();
  final _minPriceController = TextEditingController(text: '0');
  final _maxPriceController = TextEditingController(text: '5000');

  final Set<String> _selectedProfessions = {};
  String _roomsValue = 'Any';

  /// 100 km = effectively no distance cap when location is available.
  double _distanceValue = 100;

  /// `null` = Any (no gender filter for feed / recommendations).
  AddAdGenderPreference? _genderFilter;

  /// `null` = Any property type.
  AddAdPropertyType? _propertyTypeFilter;

  @override
  void dispose() {
    _professionSearchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      _professionSearchController.clear();
      _minPriceController.text = '0';
      _maxPriceController.text = '5000';
      _selectedProfessions.clear();
      _roomsValue = 'Any';
      _distanceValue = 100;
      _genderFilter = null;
      _propertyTypeFilter = null;
    });
  }

  ListingQuery _buildQuery(BuildContext context) {
    final minStr = _minPriceController.text.replaceAll(',', '').trim();
    final maxStr = _maxPriceController.text.replaceAll(',', '').trim();
    final minRent = double.tryParse(minStr);
    final maxRent = double.tryParse(maxStr);

    double? minMonthlyRent;
    double? maxMonthlyRent;
    if (minRent != null && minRent > 0) minMonthlyRent = minRent;
    if (maxRent != null && maxRent > 0 && maxRent < 5000) {
      maxMonthlyRent = maxRent;
    }

    final studyFieldIds = _selectedProfessions
        .map((p) => kFilterProfessionToStudyFieldId[p])
        .whereType<String>()
        .toList();

    int? minTotalBeds;
    switch (_roomsValue) {
      case '1':
        minTotalBeds = 1;
        break;
      case '2':
        minTotalBeds = 2;
        break;
      case '3':
        minTotalBeds = 3;
        break;
      case '4+':
        minTotalBeds = 4;
        break;
      default:
        minTotalBeds = null;
    }

    double? userLat;
    double? userLng;
    UserLocationState? loc;
    try {
      loc = context.read<UserLocationCubit>().state;
    } catch (_) {
      loc = null;
    }
    if (loc is UserLocationReady) {
      userLat = loc.latitude;
      userLng = loc.longitude;
    }

    final double? maxDistanceKm;
    if (userLat != null && userLng != null && _distanceValue < 100) {
      maxDistanceKm = _distanceValue;
    } else {
      maxDistanceKm = null;
    }

    return ListingQuery(
      minMonthlyRent: minMonthlyRent,
      maxMonthlyRent: maxMonthlyRent,
      minTotalBeds: minTotalBeds,
      studyFieldIds: studyFieldIds,
      maxDistanceKm: maxDistanceKm,
      userLatitude: userLat,
      userLongitude: userLng,
      genderFilter: _genderFilter,
      propertyTypeFilter: _propertyTypeFilter,
    );
  }

  void _apply(BuildContext context) {
    final q = _buildQuery(context);
    Navigator.of(context).pop<ListingQuery>(q);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.tr;
    final filteredProfessions = _professionSearchController.text.isEmpty
        ? _professionOptions
        : _professionOptions
            .where((p) => p
                .toLowerCase()
                .contains(_professionSearchController.text.toLowerCase()))
            .toList();

    return Container(
      height: .9.sh,
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  s.filter,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary700,
                  ),
                ),
                TextButton(
                  onPressed: _reset,
                  child: Text(
                    s.reset,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilterSectionCard(
                    title: s.profession,
                    child: FilterProfessionSection(
                      searchController: _professionSearchController,
                      filteredProfessions: filteredProfessions,
                      selectedProfessions: _selectedProfessions,
                      onSearchChanged: () => setState(() {}),
                      onToggleProfession: (profession) {
                        setState(() {
                          if (_selectedProfessions.contains(profession)) {
                            _selectedProfessions.remove(profession);
                          } else {
                            _selectedProfessions.add(profession);
                          }
                        });
                      },
                    ),
                  ),
                  FilterSectionCard(
                    title: s.priceRange,
                    child: FilterPriceSection(
                      minPriceController: _minPriceController,
                      maxPriceController: _maxPriceController,
                    ),
                  ),
                  FilterSectionCard(
                    title: s.rooms,
                    child: FilterRoomsSection(
                      value: _roomsValue,
                      options: _roomsOptions,
                      onChanged: (v) =>
                          setState(() => _roomsValue = v ?? 'Any'),
                    ),
                  ),
                  FilterSectionCard(
                    title: s.distance,
                    child: FilterDistanceSection(
                      value: _distanceValue,
                      onChanged: (v) => setState(() => _distanceValue = v),
                    ),
                  ),
                  FilterSectionCard(
                    title: s.addAdWhoCanRent,
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        FilterChip(
                          label: Text(s.any),
                          selected: _genderFilter == null,
                          onSelected: (_) =>
                              setState(() => _genderFilter = null),
                        ),
                        FilterChip(
                          label: Text(
                              addAdGenderLabel(s, AddAdGenderPreference.male)),
                          selected: _genderFilter == AddAdGenderPreference.male,
                          onSelected: (_) => setState(
                            () => _genderFilter = AddAdGenderPreference.male,
                          ),
                        ),
                        FilterChip(
                          label: Text(addAdGenderLabel(
                              s, AddAdGenderPreference.female)),
                          selected:
                              _genderFilter == AddAdGenderPreference.female,
                          onSelected: (_) => setState(
                            () => _genderFilter = AddAdGenderPreference.female,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilterSectionCard(
                    title: s.addAdStepPropertyType,
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        FilterChip(
                          label: Text(s.any),
                          selected: _propertyTypeFilter == null,
                          onSelected: (_) =>
                              setState(() => _propertyTypeFilter = null),
                        ),
                        ...AddAdPropertyType.values.map(
                          (t) => FilterChip(
                            label: Text(addAdPropertyTypeLabel(s, t)),
                            selected: _propertyTypeFilter == t,
                            onSelected: (_) =>
                                setState(() => _propertyTypeFilter = t),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  PrimaryButton(
                    label: s.applyFilters,
                    onPressed: () => _apply(context),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
