import 'package:dermalyze/core/network/api_service.dart';

class ClinicalResourcesRepository {
  final ApiService _api = ApiService();

  /// جلب البيانات والإحصائيات الخاصة بالمرض للسجل الذكي
  Future<Map<String, dynamic>> getSmartHistoryInsights(String diseaseName) async {
    try {
      final response = await _api.get('resources/smart-history?disease=$diseaseName');
      return response is Map<String, dynamic> ? response : {};
    } catch (_) {
      return {};
    }
  }

  /// جلب دليل الأدوية الكامل
  Future<List<Map<String, dynamic>>> getMedicationsGuide() async {
    try {
      final response = await _api.get('resources/medications');
      return (response is List) ? response.cast<Map<String, dynamic>>() : [];
    } catch (_) {
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
