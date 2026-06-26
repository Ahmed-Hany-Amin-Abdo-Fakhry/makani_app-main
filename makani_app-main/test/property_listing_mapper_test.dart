import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:makani_app/Features/Listings/Data/property_listing_mapper.dart';

void main() {
  test('maps bedsAvailable from Firestore document', () {
    final listing = PropertyListingMapper.fromFirestore(
      _FakeDoc(
        id: 'l1',
        fields: {
          'ownerId': 'u1',
          'propertyType': 'singleBed',
          'genderPreference': 'male',
          'studyFieldIds': <String>[],
          'amenityIds': <String>[],
          'imageUrls': <String>[],
          'totalBeds': 4,
          'bedsAvailable': 2,
          'bathrooms': 1,
        },
      ),
    );

    expect(listing.totalBeds, 4);
    expect(listing.bedsAvailable, 2);
  });
}

class _FakeDoc implements DocumentSnapshot<Map<String, dynamic>> {
  _FakeDoc({required this.id, required Map<String, dynamic> fields})
      : _fields = fields;

  @override
  final String id;

  final Map<String, dynamic> _fields;

  @override
  bool get exists => true;

  @override
  DocumentReference<Map<String, dynamic>> get reference =>
      throw UnimplementedError();

  @override
  SnapshotMetadata get metadata => throw UnimplementedError();

  @override
  Map<String, dynamic>? data() => _fields;

  @override
  dynamic get(Object field) => _fields[field];

  @override
  dynamic operator [](Object field) => _fields[field];
}
