import 'package:dermalyze/core/network/api_service.dart';

/// بيانات المريض الـ logged-in من الـ API
class PatientHomeRepository {
  final ApiService _api = ApiService();

  /// GET /api/patients/{id} — بيانات البروفايل الحالي
  Future<Map<String, dynamic>> getMyProfile(String patientId) async {
    if (patientId.isEmpty) return {};
    try {
      final response = await _api.get('patients/$patientId');
      return response is Map<String, dynamic> ? response : {};
    } catch (_) {
      return {};
    }
  }

  /// GET /api/patient/{id}/analyses — آخر تحاليل المريض
  Future<List<dynamic>> getMyAnalyses(String patientId) async {
    try {
      final response = await _api.get('patient/$patientId/analyses');
      return response is List ? response : (response['analyses'] ?? []);
    } catch (_) {
      return [];
    }
  }

  /// GET /api/patient/{id}/medications — أدوية المريض
  Future<List<dynamic>> getMyMedications(String patientId) async {
    try {
      final response = await _api.get('patient/$patientId/medications');
      return response is List ? response : (response['medications'] ?? []);
    } catch (_) {
      return [];
    }
  }
}
