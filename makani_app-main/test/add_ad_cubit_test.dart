import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:makani_app/Features/AddAd/Cubit/add_ad_cubit.dart';
import 'package:makani_app/Features/AddAd/Cubit/add_ad_state.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_constants.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_draft.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_enums.dart';
import 'package:makani_app/Features/AddAd/Repositories/add_property_repository.dart';
import 'package:makani_app/Features/AddAd/Services/listing_verification_firestore_service.dart';
import 'package:makani_app/Features/Listings/Model/property_listing.dart';

class FakeAddPropertyRepository implements AddPropertyRepository {
  int publishCalls = 0;
  int updateCalls = 0;
  AddAdDraft? lastDraft;

  @override
  Future<void> publishListing(AddAdDraft draft, {void Function(double progress)? onProgress}) async {
    publishCalls++;
    lastDraft = draft;
    onProgress?.call(1.0);
  }

  @override
  Future<void> updateListing({
    required String listingId,
    required AddAdDraft draft,
    void Function(double progress)? onProgress,
  }) async {
    updateCalls++;
    lastDraft = draft;
    onProgress?.call(1.0);
  }
}

class FakeListingVerificationStore implements ListingVerificationStore {
  FakeListingVerificationStore({this.verificationData});

  ListingVerificationData? verificationData;

  @override
  Future<ListingVerificationData?> getVerificationData(String listingId) async =>
      verificationData;

  @override
  Future<void> setVerificationData({
    required String listingId,
    required String contractImageUrl,
    required String nationalIdFrontUrl,
    required String nationalIdBackUrl,
  }) async {}
}

AddAdDraft _publishableDraft({
  List<String>? photoSlots,
  String? contractImagePath,
  String? nationalIdFrontPath,
  String? nationalIdBackPath,
  String ownerPhone = '01012345678',
  int totalBeds = 2,
  int bedsAvailable = 2,
}) {
  final slots = photoSlots ?? List<String>.filled(AddAdConstants.maxPhotos, '');
  slots[0] = 'a';
  slots[1] = 'b';
  return AddAdDraft(
    propertyType: AddAdPropertyType.singleBed,
    governorate: 'Cairo',
    district: 'Nasr City',
    latitude: 30.0,
    longitude: 31.0,
    monthlyRentText: '3000',
    totalBeds: totalBeds,
    bedsAvailable: bedsAvailable,
    bathrooms: 1,
    roomSizeText: '20',
    photoSlots: slots,
    ownerPhone: ownerPhone,
    contractImagePath: contractImagePath ?? 'https://contract-1',
    nationalIdFrontPath: nationalIdFrontPath ?? 'https://id-front-1',
    nationalIdBackPath: nationalIdBackPath ?? 'https://id-back-1',
  );
}

AddAdCubit _cubit({FakeAddPropertyRepository? repo}) => AddAdCubit(
      addPropertyRepository: repo ?? FakeAddPropertyRepository(),
      verificationStore: FakeListingVerificationStore(),
    );

void main() {
  group('AddAdCubit', () {
    test('initial state cannot continue without property type', () {
      final c = _cubit();
      expect(c.state.canContinueStep1, false);
      expect(c.state.canContinueStep4, false);
      c.close();
    });

    blocTest<AddAdCubit, AddAdState>(
      'step1 gate opens when property type set',
      build: () => _cubit(),
      act: (c) => c.setPropertyType(AddAdPropertyType.singleBed),
      expect: () => [
        isA<AddAdState>().having(
          (s) => s.canContinueStep1,
          'canContinueStep1',
          true,
        ),
      ],
    );

    test('step4 requires two photos, contract, and national ID images', () {
      final slots = List<String>.filled(AddAdConstants.maxPhotos, '');
      slots[0] = 'a';
      slots[1] = 'b';
      final c = _cubit();
      c.emit(AddAdState(draft: AddAdDraft(photoSlots: slots)));
      expect(c.state.canContinueStep4, false);

      c.emit(
        AddAdState(
          draft: AddAdDraft(
            photoSlots: slots,
            contractImagePath: 'https://contract',
          ),
        ),
      );
      expect(c.state.canContinueStep4, false);

      c.emit(
        AddAdState(
          draft: AddAdDraft(
            photoSlots: slots,
            contractImagePath: 'https://contract',
            nationalIdFrontPath: 'https://id-front',
            nationalIdBackPath: 'https://id-back',
          ),
        ),
      );
      expect(c.state.canContinueStep4, true);
      c.close();
    });

    test('step3 rejects bedsAvailable greater than totalBeds', () {
      final c = _cubit();
      c.emit(
        AddAdState(
          draft: AddAdDraft(
            propertyType: AddAdPropertyType.singleBed,
            governorate: 'Cairo',
            district: 'Nasr City',
            latitude: 30.0,
            longitude: 31.0,
            monthlyRentText: '3000',
            totalBeds: 2,
            bedsAvailable: 3,
            bathrooms: 1,
            roomSizeText: '20',
          ),
        ),
      );
      expect(c.state.canContinueStep3, false);
      c.close();
    });

    test('decrementBeds clamps bedsAvailable to totalBeds', () {
      final c = _cubit();
      c.emit(
        AddAdState(
          draft: AddAdDraft(totalBeds: 3, bedsAvailable: 3),
        ),
      );
      c.decrementBeds();
      expect(c.state.draft.totalBeds, 2);
      expect(c.state.draft.bedsAvailable, 2);
      c.close();
    });

    test('startEdit seeds draft and edit metadata', () {
      final c = _cubit();
      final listing = PropertyListing(
        id: 'l1',
        ownerId: 'o1',
        ownerPhone: '01000000000',
        propertyTypeKey: 'privateRoom',
        genderPreferenceKey: 'female',
        studyFieldIds: const ['engineering'],
        governorate: 'Cairo',
        district: 'Nasr City',
        latitude: 30.1,
        longitude: 31.4,
        addressLine: 'Street 1',
        monthlyRent: 3500,
        utilitiesIncluded: true,
        totalBeds: 3,
        bedsAvailable: 2,
        bathrooms: 2,
        roomSizeSqm: 22,
        amenityIds: const ['wifi'],
        imageUrls: const ['https://img-1', 'https://img-2'],
        videoUrl: 'https://video-1',
      );

      c.startEdit(listing);
      expect(c.state.isEditing, true);
      expect(c.state.editingListingId, 'l1');
      expect(c.state.draft.propertyType, AddAdPropertyType.privateRoom);
      expect(c.state.draft.genderPreference, AddAdGenderPreference.female);
      expect(c.state.draft.photoSlots.first, 'https://img-1');
      expect(c.state.draft.videoPath, 'https://video-1');
      expect(c.state.draft.ownerPhone, '01000000000');
      expect(c.state.draft.bedsAvailable, 2);
      c.close();
    });

    test('loadEditListing hydrates verification data from verification service', () async {
      final verification = FakeListingVerificationStore(
        verificationData: const ListingVerificationData(
          contractImageUrl: 'https://contract-remote',
          nationalIdFrontUrl: 'https://id-front-remote',
          nationalIdBackUrl: 'https://id-back-remote',
        ),
      );
      final c = AddAdCubit(
        addPropertyRepository: FakeAddPropertyRepository(),
        verificationStore: verification,
      );
      await c.loadEditListing(
        const PropertyListing(
          id: 'l1',
          ownerId: 'o1',
          propertyTypeKey: 'singleBed',
          genderPreferenceKey: 'male',
          studyFieldIds: [],
          amenityIds: [],
          imageUrls: ['https://img-1', 'https://img-2'],
        ),
      );
      expect(c.state.draft.contractImagePath, 'https://contract-remote');
      expect(c.state.draft.nationalIdFrontPath, 'https://id-front-remote');
      expect(c.state.draft.nationalIdBackPath, 'https://id-back-remote');
      c.close();
    });

    test('submit uses update path while editing', () async {
      final repo = FakeAddPropertyRepository();
      final c = _cubit(repo: repo);
      c.emit(
        AddAdState(
          isEditing: true,
          editingListingId: 'l1',
          draft: _publishableDraft(),
        ),
      );

      await c.submit();
      expect(repo.updateCalls, 1);
      expect(repo.publishCalls, 0);
      expect(repo.lastDraft?.ownerPhone, '01012345678');
      c.close();
    });

    test('canPublish requires valid owner phone, contract, and national ID', () {
      final c = _cubit();
      c.emit(AddAdState(draft: _publishableDraft(ownerPhone: '')));
      expect(c.state.canPublish, false);

      c.emit(AddAdState(draft: _publishableDraft(contractImagePath: '')));
      expect(c.state.canPublish, false);

      c.emit(AddAdState(draft: _publishableDraft(nationalIdFrontPath: '')));
      expect(c.state.canPublish, false);

      c.emit(AddAdState(draft: _publishableDraft(nationalIdBackPath: '')));
      expect(c.state.canPublish, false);

      c.emit(AddAdState(draft: _publishableDraft()));
      expect(c.state.canPublish, true);
      c.close();
    });
  });
}
