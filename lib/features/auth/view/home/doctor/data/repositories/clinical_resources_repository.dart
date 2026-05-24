import 'package:dermalyze/core/network/api_service.dart';

class ClinicalResourcesRepository {
  final ApiService _api = ApiService();

  /// جلب البيانات والإحصائيات الخاصة بالمرض للسجل الذكي
  Future<Map<String, dynamic>> getSmartHistoryInsights(String diseaseName) async {
    try {
      final response = await _api.get('doctor/history?disease=$diseaseName');
      return response is Map<String, dynamic> ? response : {};
    } catch (_) {
      return {};
    }
  }

  /// جلب دليل الأدوية الكامل مع إمكانية البحث (مع Pagination)
  Future<List<Map<String, dynamic>>> getMedicationsGuide({
    String? query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      String endpoint;
      Map<String, dynamic> queryParams = {};

      if (query != null && query.trim().isNotEmpty) {
        endpoint = 'medicines/search';
        queryParams['q'] = query.trim();
      } else {
        endpoint = 'medicines/all';
        queryParams['page'] = page;
        queryParams['limit'] = limit;
      }

      print('Fetching medications from $endpoint with params: $queryParams');
      final response = await _api.get(endpoint, queryParameters: queryParams);
      
      // Parse the response based on the expected backend structure
      if (response is Map) {
        if (response.containsKey('results') && response['results'] is List) {
          return List<Map<String, dynamic>>.from(response['results']);
        } else if (response.containsKey('data') && response['data'] is List) {
          return List<Map<String, dynamic>>.from(response['data']);
        }
      }
      return (response is List) ? List<Map<String, dynamic>>.from(response) : [];
    } catch (e) {
      print('Error in getMedicationsGuide: $e');
      return [];
    }
  }

  /// جلب مكتبة الأمراض الجلدية
  Future<List<Map<String, dynamic>>> getDiseasesLibrary() async {
    try {
      final response = await _api.get('resources/diseases');
      return (response is List) ? response.cast<Map<String, dynamic>>() : [];
    } catch (_) {
      return [];
    }
  }
}
