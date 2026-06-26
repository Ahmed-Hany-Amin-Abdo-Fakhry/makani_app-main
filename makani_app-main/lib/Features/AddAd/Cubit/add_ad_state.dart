import 'package:equatable/equatable.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_draft.dart';

class AddAdState extends Equatable {
  AddAdState({
    AddAdDraft? draft,
    this.isEditing = false,
    this.editingListingId,
    this.submitting = false,
    this.submitErrorKey,
    this.publishSucceeded = false,
    this.locationLoading = false,
    this.locationMessage,
    this.uploadProgress,
  }) : draft = draft ?? AddAdDraft();

  final AddAdDraft draft;
  final bool isEditing;
  final String? editingListingId;
  final bool submitting;

  /// L10n lookup key for publish errors; see [AddAdCubit] mapping.
  final String? submitErrorKey;
  final bool publishSucceeded;
  final bool locationLoading;
  final String? locationMessage;
  final double? uploadProgress;

  AddAdState copyWith({
    AddAdDraft? draft,
    bool? isEditing,
    String? editingListingId,
    bool? submitting,
    String? submitErrorKey,
    bool? publishSucceeded,
    bool? locationLoading,
    String? locationMessage,
    double? uploadProgress,
    bool clearSubmitError = false,
    bool clearPublishSucceeded = false,
    bool clearLocationMessage = false,
    bool clearUploadProgress = false,
    bool clearEditingListingId = false,
  }) {
    return AddAdState(
      draft: draft ?? this.draft,
      isEditing: isEditing ?? this.isEditing,
      editingListingId: clearEditingListingId
          ? null
          : (editingListingId ?? this.editingListingId),
      submitting: submitting ?? this.submitting,
      submitErrorKey: clearSubmitError
          ? null
          : (submitErrorKey ?? this.submitErrorKey),
      publishSucceeded: clearPublishSucceeded
          ? false
          : (publishSucceeded ?? this.publishSucceeded),
      locationLoading: locationLoading ?? this.locationLoading,
      locationMessage: clearLocationMessage
          ? null
          : (locationMessage ?? this.locationMessage),
      uploadProgress: clearUploadProgress
          ? null
          : (uploadProgress ?? this.uploadProgress),
    );
  }

  bool get canContinueStep1 => draft.propertyType != null;

  bool get canContinueStep2 =>
      draft.governorate != null &&
      draft.district != null &&
      draft.latitude != null &&
      draft.longitude != null;

  double? get _parsedRent =>
      double.tryParse(draft.monthlyRentText.replaceAll(',', '').trim());

  double? get _parsedRoomSize =>
      double.tryParse(draft.roomSizeText.replaceAll(',', '').trim());

  bool get canContinueStep3 {
    final rent = _parsedRent;
    final sqm = _parsedRoomSize;
    return rent != null &&
        rent > 0 &&
        sqm != null &&
        sqm > 0 &&
        draft.totalBeds >= 1 &&
        draft.bedsAvailable >= 1 &&
        draft.bedsAvailable <= draft.totalBeds &&
        draft.bathrooms >= 1;
  }

  bool get canContinueStep4 =>
      draft.filledPhotoCount >= 2 &&
      draft.hasContractImage &&
      draft.hasNationalIdImages;

  bool get hasValidOwnerPhone {
    final digits = draft.ownerPhone.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 8;
  }

  bool get canPublish =>
      canContinueStep1 &&
      canContinueStep2 &&
      canContinueStep3 &&
      canContinueStep4 &&
      hasValidOwnerPhone;

  @override
  List<Object?> get props => [
        draft,
        isEditing,
        editingListingId,
        submitting,
        submitErrorKey,
        publishSucceeded,
        locationLoading,
        locationMessage,
        uploadProgress,
      ];
}
