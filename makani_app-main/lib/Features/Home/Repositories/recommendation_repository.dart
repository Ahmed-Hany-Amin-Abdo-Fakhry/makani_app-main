import 'package:makani_app/Features/Home/Model/home_recommendation.dart';
import 'package:makani_app/Features/Listings/Model/listing_query.dart';

abstract class RecommendationRepository {
  Future<List<HomeRecommendation>> fetchRecommendations({
    required ListingQuery query,
    String? searchText,
    String? section,
    int limit = 5,
  });
}
