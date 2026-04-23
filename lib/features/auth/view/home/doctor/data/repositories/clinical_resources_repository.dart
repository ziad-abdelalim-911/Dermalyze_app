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

  /// جلب دليل الأدوية الكامل مع إمكانية البحث
  Future<List<Map<String, dynamic>>> getMedicationsGuide({String? query}) async {
    try {
      print('Fetching medications with query: $query');
      final queryParams = query != null && query.isNotEmpty ? {'search': query} : null;
      final response = await _api.get('resources/medications', queryParameters: queryParams);
      print('Response received: $response');
      if (response is Map && response.containsKey('data')) {
          return (response['data'] as List).cast<Map<String, dynamic>>();
      }
      return (response is List) ? response.cast<Map<String, dynamic>>() : [];
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
