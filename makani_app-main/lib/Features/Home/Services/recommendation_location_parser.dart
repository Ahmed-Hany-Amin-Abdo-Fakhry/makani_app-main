/// Parsed location for recommendation API query params.
class RecommendationLocationParams {
  const RecommendationLocationParams({this.governorate, this.district});

  final String? governorate;
  final String? district;
}

/// Maps home search text to [governorate] / [district] query params.
///
/// - Comma present: first segment → [district], second → [governorate].
/// - No comma: entire string → [governorate] only.
RecommendationLocationParams parseRecommendationLocationSearch(String? raw) {
  if (raw == null) {
    return const RecommendationLocationParams();
  }
  var collapsed = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
  if (collapsed.isEmpty) {
    return const RecommendationLocationParams();
  }
  final comma = collapsed.indexOf(',');
  if (comma == -1) {
    return RecommendationLocationParams(governorate: collapsed);
  }
  final district = collapsed.substring(0, comma).trim();
  final governorate = collapsed.substring(comma + 1).trim();
  if (district.isEmpty && governorate.isEmpty) {
    return const RecommendationLocationParams();
  }
  if (governorate.isEmpty) {
    return RecommendationLocationParams(governorate: district);
  }
  if (district.isEmpty) {
    return RecommendationLocationParams(governorate: governorate);
  }
  return RecommendationLocationParams(
    governorate: governorate,
    district: district,
  );
}
