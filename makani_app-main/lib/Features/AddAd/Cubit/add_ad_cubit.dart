import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:makani_app/Core/Services/current_location_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:makani_app/Features/AddAd/Cubit/add_ad_state.dart';
import 'package:path/path.dart' as p;
import 'package:makani_app/Features/AddAd/Model/add_ad_constants.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_draft.dart';
import 'package:uuid/uuid.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_enums.dart';
import 'package:makani_app/Features/AddAd/Repositories/add_property_repository.dart';
import 'package:makani_app/Features/AddAd/Services/listing_verification_firestore_service.dart';
import 'package:makani_app/Features/Listings/Model/property_listing.dart';

class AddAdCubit extends Cubit<AddAdState> {
  AddAdCubit({
    required AddPropertyRepository addPropertyRepository,
    required ListingVerificationStore verificationStore,
    CurrentLocationService? locationService,
  })  : _addPropertyRepository = addPropertyRepository,
        _verificationStore = verificationStore,
        _locationService = locationService ?? CurrentLocationService(),
        super(AddAdState());

  final AddPropertyRepository _addPropertyRepository;
  final ListingVerificationStore _verificationStore;
  final CurrentLocationService _locationService;
  final ImagePicker _picker = ImagePicker();
  static const _uuid = Uuid();

  static String _formatDouble(num? value) {
    if (value == null) return '';
    final asInt = value.toInt();
    if (value == asInt) return '$asInt';
    return value.toString();
  }

  static AddAdPropertyType _parsePropertyType(String key) {
    return AddAdPropertyType.values.firstWhere(
      (e) => e.name == key,
      orElse: () => AddAdPropertyType.singleBed,
    );
  }

  static AddAdGenderPreference _parseGender(String key) {
    return AddAdGenderPreference.values.firstWhere(
      (e) => e.name == key,
      orElse: () => AddAdGenderPreference.any,
    );
  }

  /// Android often returns `content://` URIs; native compressors need a real file path.
  Future<String> _materializePickToTemp(XFile file, {required bool isVideo}) async {
    final dir = Directory.systemTemp;
    var ext = p.extension(file.name);
    if (ext.isEmpty || ext == '.') {
      ext = isVideo ? '.mp4' : '.jpg';
    }
    final dest = File(p.join(dir.path, 'addad_pick_${_uuid.v4()}$ext'));
    await dest.writeAsBytes(await file.readAsBytes(), flush: true);
    return dest.path;
  }

  void setPropertyType(AddAdPropertyType type) {
    emit(state.copyWith(draft: state.draft.copyWith(propertyType: type)));
  }

  void setGenderPreference(AddAdGenderPreference value) {
    emit(state.copyWith(draft: state.draft.copyWith(genderPreference: value)));
  }

  void toggleStudyField(String id) {
    final next = Set<String>.from(state.draft.studyFieldIds);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    emit(state.copyWith(draft: state.draft.copyWith(studyFieldIds: next)));
  }

  void setGovernorate(String? value) {
    emit(
      state.copyWith(
        draft: state.draft.copyWith(
          governorate: value,
          clearDistrict: true,
        ),
      ),
    );
  }

  void setDistrict(String? value) {
    emit(state.copyWith(draft: state.draft.copyWith(district: value)));
  }

  void setPin(double lat, double lng) {
    emit(
      state.copyWith(
        draft: state.draft.copyWith(latitude: lat, longitude: lng),
        clearLocationMessage: true,
      ),
    );
  }

  Future<void> useCurrentLocation() async {
    emit(state.copyWith(locationLoading: true, clearLocationMessage: true));
    try {
      final pos = await _locationService.getCurrentPosition();
      emit(
        state.copyWith(
          draft: state.draft.copyWith(
            latitude: pos.latitude,
            longitude: pos.longitude,
          ),
          locationLoading: false,
          clearLocationMessage: true,
        ),
      );
    } on CurrentLocationException catch (e) {
      emit(
        state.copyWith(
          locationLoading: false,
          locationMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          locationLoading: false,
          locationMessage: e.toString(),
        ),
      );
    }
  }

  void setAddressLine(String? line) {
    emit(state.copyWith(draft: state.draft.copyWith(addressLine: line)));
  }

  void setMonthlyRentText(String text) {
    emit(state.copyWith(draft: state.draft.copyWith(monthlyRentText: text)));
  }

  void setUtilitiesIncluded(bool value) {
    emit(state.copyWith(draft: state.draft.copyWith(utilitiesIncluded: value)));
  }

  void incrementBeds() {
    final v = state.draft.totalBeds + 1;
    if (v > 20) return;
    final bedsAvailable = state.draft.bedsAvailable > v ? v : state.draft.bedsAvailable;
    emit(
      state.copyWith(
        draft: state.draft.copyWith(
          totalBeds: v,
          bedsAvailable: bedsAvailable,
        ),
      ),
    );
  }

  void decrementBeds() {
    final v = state.draft.totalBeds - 1;
    if (v < 1) return;
    final bedsAvailable = state.draft.bedsAvailable > v ? v : state.draft.bedsAvailable;
    emit(
      state.copyWith(
        draft: state.draft.copyWith(
          totalBeds: v,
          bedsAvailable: bedsAvailable,
        ),
      ),
    );
  }

  void incrementBedsAvailable() {
    final v = state.draft.bedsAvailable + 1;
    if (v > state.draft.totalBeds || v > 20) return;
    emit(state.copyWith(draft: state.draft.copyWith(bedsAvailable: v)));
  }

  void decrementBedsAvailable() {
    final v = state.draft.bedsAvailable - 1;
    if (v < 1) return;
    emit(state.copyWith(draft: state.draft.copyWith(bedsAvailable: v)));
  }

  void incrementBathrooms() {
    final v = state.draft.bathrooms + 1;
    if (v > 20) return;
    emit(state.copyWith(draft: state.draft.copyWith(bathrooms: v)));
  }

  void decrementBathrooms() {
    final v = state.draft.bathrooms - 1;
    if (v < 1) return;
    emit(state.copyWith(draft: state.draft.copyWith(bathrooms: v)));
  }

  void setRoomSizeText(String text) {
    emit(state.copyWith(draft: state.draft.copyWith(roomSizeText: text)));
  }

  void setOwnerPhone(String value) {
    emit(state.copyWith(draft: state.draft.copyWith(ownerPhone: value)));
  }

  void toggleAmenity(String id) {
    final next = Set<String>.from(state.draft.amenityIds);
    if (next.contains(id)) {
      next.remove(id);
    } else {
      next.add(id);
    }
    emit(state.copyWith(draft: state.draft.copyWith(amenityIds: next)));
  }

  Future<void> pickPhotoForSlot(int index, ImageSource source) async {
    if (index < 0 || index >= AddAdConstants.maxPhotos) return;
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 88,
    );
    if (file == null) return;
    final localPath = await _materializePickToTemp(file, isVideo: false);
    final slots = List<String>.from(state.draft.photoSlots);
    slots[index] = localPath;
    emit(state.copyWith(draft: state.draft.copyWith(photoSlots: slots)));
  }

  void removePhotoAt(int displayIndex) {
    if (displayIndex < 0 ||
        displayIndex >= state.draft.photoSlots.length) {
      return;
    }
    final slots = List<String>.from(state.draft.photoSlots);
    slots[displayIndex] = '';
    emit(state.copyWith(draft: state.draft.copyWith(photoSlots: slots)));
  }

  Future<void> pickVideo(ImageSource source) async {
    final file = await _picker.pickVideo(source: source);
    if (file == null) return;
    final localPath = await _materializePickToTemp(file, isVideo: true);
    final len = await File(localPath).length();
    if (len > AddAdConstants.maxVideoBytes) {
      emit(
        state.copyWith(
          locationMessage: 'Video must be 50MB or smaller',
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        draft: state.draft.copyWith(videoPath: localPath),
        clearLocationMessage: true,
      ),
    );
  }

  void clearVideo() {
    emit(state.copyWith(draft: state.draft.copyWith(clearVideo: true)));
  }

  Future<void> pickContractImage(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 88,
    );
    if (file == null) return;
    final localPath = await _materializePickToTemp(file, isVideo: false);
    emit(
      state.copyWith(
        draft: state.draft.copyWith(contractImagePath: localPath),
        clearLocationMessage: true,
      ),
    );
  }

  void clearContractImage() {
    emit(state.copyWith(draft: state.draft.copyWith(clearContractImage: true)));
  }

  Future<void> pickNationalIdFront(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 88,
    );
    if (file == null) return;
    final localPath = await _materializePickToTemp(file, isVideo: false);
    emit(
      state.copyWith(
        draft: state.draft.copyWith(nationalIdFrontPath: localPath),
        clearLocationMessage: true,
      ),
    );
  }

  Future<void> pickNationalIdBack(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 88,
    );
    if (file == null) return;
    final localPath = await _materializePickToTemp(file, isVideo: false);
    emit(
      state.copyWith(
        draft: state.draft.copyWith(nationalIdBackPath: localPath),
        clearLocationMessage: true,
      ),
    );
  }

  void clearNationalIdFront() {
    emit(state.copyWith(draft: state.draft.copyWith(clearNationalIdFront: true)));
  }

  void clearNationalIdBack() {
    emit(state.copyWith(draft: state.draft.copyWith(clearNationalIdBack: true)));
  }

  Future<void> loadEditListing(PropertyListing listing) async {
    startEdit(listing);
    final verification =
        await _verificationStore.getVerificationData(listing.id);
    if (verification != null && !isClosed) {
      emit(
        state.copyWith(
          draft: state.draft.copyWith(
            contractImagePath: verification.contractImageUrl,
            nationalIdFrontPath: verification.nationalIdFrontUrl,
            nationalIdBackPath: verification.nationalIdBackUrl,
          ),
        ),
      );
    }
  }

  void startEdit(PropertyListing listing) {
    final slots = List<String>.filled(AddAdConstants.maxPhotos, '');
    for (var i = 0;
        i < listing.imageUrls.length && i < AddAdConstants.maxPhotos;
        i++) {
      slots[i] = listing.imageUrls[i];
    }
    final draft = AddAdDraft(
      propertyType: _parsePropertyType(listing.propertyTypeKey),
      genderPreference: _parseGender(listing.genderPreferenceKey),
      studyFieldIds: listing.studyFieldIds.toSet(),
      governorate: listing.governorate,
      district: listing.district,
      latitude: listing.latitude,
      longitude: listing.longitude,
      addressLine: listing.addressLine,
      monthlyRentText: _formatDouble(listing.monthlyRent),
      utilitiesIncluded: listing.utilitiesIncluded ?? false,
      totalBeds: listing.totalBeds ?? 1,
      bedsAvailable: listing.bedsAvailable ?? listing.totalBeds ?? 1,
      bathrooms: listing.bathrooms ?? 1,
      roomSizeText: _formatDouble(listing.roomSizeSqm),
      ownerPhone: listing.ownerPhone ?? '',
      amenityIds: listing.amenityIds.toSet(),
      photoSlots: slots,
      videoPath: listing.videoUrl,
    );
    emit(
      AddAdState(
        draft: draft,
        isEditing: true,
        editingListingId: listing.id,
      ),
    );
  }

  static String _publishErrorKey(Object e) {
    if (e is StateError) {
      final m = e.message;
      if (m.contains('signed in')) return 'not_signed_in';
      if (m.contains('Cloudinary')) return 'not_configured';
      return 'generic';
    }
    if (e is DioException) {
      if (e.response?.statusCode == 401) return 'unauthorized';
      return 'network';
    }
    return 'generic';
  }

  Future<void> submit() async {
    if (!state.canPublish) return;
    emit(
      state.copyWith(
        submitting: true,
        clearSubmitError: true,
        publishSucceeded: false,
        uploadProgress: 0,
      ),
    );
    try {
      if (state.isEditing && state.editingListingId != null) {
        await _addPropertyRepository.updateListing(
          listingId: state.editingListingId!,
          draft: state.draft,
          onProgress: (p) {
            if (!isClosed) {
              emit(state.copyWith(uploadProgress: p));
            }
          },
        );
      } else {
        await _addPropertyRepository.publishListing(
          state.draft,
          onProgress: (p) {
            if (!isClosed) {
              emit(state.copyWith(uploadProgress: p));
            }
          },
        );
      }
      if (!isClosed) {
        emit(
          state.copyWith(
            submitting: false,
            clearUploadProgress: true,
            publishSucceeded: true,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(
          state.copyWith(
            submitting: false,
            clearUploadProgress: true,
            submitErrorKey: _publishErrorKey(e),
          ),
        );
      }
    }
  }

  void clearSubmitError() {
    emit(state.copyWith(clearSubmitError: true));
  }

  void clearPublishSuccess() {
    emit(state.copyWith(clearPublishSucceeded: true));
  }


  void clearTransientMessage() {
    emit(state.copyWith(clearLocationMessage: true));
  }

  void resetFlow() {
    emit(AddAdState());
  }
}
