import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:makani_app/Features/AddAd/Model/add_ad_enums.dart';
import 'package:makani_app/Features/Home/Model/home_recommendation.dart';
import 'package:makani_app/Features/Home/Repositories/recommendation_repository.dart';
import 'package:makani_app/Features/Home/Services/recommendation_location_parser.dart';
import 'package:makani_app/Features/Listings/Model/listing_query.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class RecommendationRepositoryImpl implements RecommendationRepository {
  RecommendationRepositoryImpl({Dio? dio, String? recommendationsUrl})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 6),
                receiveTimeout: const Duration(seconds: 8),
              ),
            ),
        _recommendationsUrl = recommendationsUrl ?? _defaultRecommendationsUrl {
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 120,
        ),
      );
    }
  }

  static const String _defaultRecommendationsUrl = String.fromEnvironment(
    'RECOMMENDER_RECOMMENDATIONS_URL',
    defaultValue:
        'https://makani-recommendation-system.vercel.app/v1/recommendations',
  );

  final Dio _dio;
  final String _recommendationsUrl;

  @override
  Future<List<HomeRecommendation>> fetchRecommendations({
    required ListingQuery query,
    String? searchText,
    String? section,
    int limit = 10,
  }) async {
    final loc = parseRecommendationLocationSearch(searchText);
    final gender = query.genderFilter;
    final queryParameters = <String, dynamic>{
      'limit': limit,
      'section': section ?? 'home',
      if (query.minMonthlyRent != null) 'budget_min': query.minMonthlyRent,
      if (query.maxMonthlyRent != null) 'budget_max': query.maxMonthlyRent,
      if (query.studyFieldIds.isNotEmpty)
        'study_fields': query.studyFieldIds.join(','),
      if (loc.governorate != null && loc.governorate!.isNotEmpty)
        'governorate': loc.governorate,
      if (loc.district != null && loc.district!.isNotEmpty)
        'district': loc.district,
      if (gender != null && gender != AddAdGenderPreference.any)
        'gender_preference': gender.name,
      if (query.propertyTypeFilter != null)
        'preferred_property_type': query.propertyTypeFilter!.name,
      if (query.userLatitude != null) 'latitude': query.userLatitude,
      if (query.userLongitude != null) 'longitude': query.userLongitude,
    };

    if (kDebugMode) {
      developer.log(
        '$queryParameters',
        name: 'recommendations.request',
      );
    }

    final response = await _dio.get<Map<String, dynamic>>(
      _recommendationsUrl,
      queryParameters: queryParameters,
    );

    final data = response.data;
    if (data == null) return const [];
    final rawItems = data['items'];
    if (rawItems is! List) return const [];

    return rawItems
        .whereType<Map>()
        .map(
          (raw) => HomeRecommendation.fromJson(
            raw.map((key, value) => MapEntry(key.toString(), value)),
          ),
        )
        .where((item) => item.id.isNotEmpty)
        .toList(growable: false);
  }
}
