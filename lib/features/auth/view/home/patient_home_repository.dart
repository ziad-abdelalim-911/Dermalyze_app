import 'package:dermalyze/core/network/api_service.dart';

/// بيانات المريض الـ logged-in من الـ API
class PatientHomeRepository {
  final ApiService _api = ApiService();

  /// GET /api/user/profile — بيانات البروفايل الحالي
  Future<Map<String, dynamic>> getMyProfile(String patientId) async {
      Map<String, dynamic>? rawResponse;
      try {
        final res = await _api.get('user/profile');
        rawResponse = res is Map<String, dynamic> ? res : <String, dynamic>{};
      } catch (e) {
        print("user/profile failed, trying patient/$patientId. Error: $e");
        try {
          final res2 = await _api.get('patient/$patientId');
          rawResponse = res2 is Map<String, dynamic> ? res2 : <String, dynamic>{};
        } catch (e2) {
          print("patient/$patientId failed, trying patients/$patientId. Error: $e2");
          final res3 = await _api.get('patients/$patientId');
          rawResponse = res3 is Map<String, dynamic> ? res3 : <String, dynamic>{};
        }
      }
      
      final Map<String, dynamic> data = rawResponse ?? <String, dynamic>{};
      print("Profile API Response: $data");
      
      if (data.containsKey('data')) {
        final nestedData = data['data'];
        if (nestedData is Map<String, dynamic>) {
           if (nestedData.containsKey('patient')) return nestedData['patient'] as Map<String, dynamic>;
           if (nestedData.containsKey('user')) return nestedData['user'] as Map<String, dynamic>;
           return nestedData;
        } else if (nestedData is List && nestedData.isNotEmpty) {
           final first = nestedData.first;
           if (first is Map<String, dynamic>) return first;
        }
      }

      if (data.containsKey('patient')) {
        final p = data['patient'];
        if (p is Map<String, dynamic>) return p;
      }
      if (data.containsKey('user')) {
        final u = data['user'];
        if (u is Map<String, dynamic>) return u;
      }
      
      return data;
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
