import 'package:dermalyze/core/network/api_service.dart';

class ReportsRepository {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> getPatientReport(String patientId) async {
    try {
      final response = await _api.get('reports/patient/$patientId');
      if (response is Map<String, dynamic>) {
        // According to the JSON structure provided:
        // { "success": true, "data": { ... } }
        return response;
      }
      return {};
    } catch (e) {
      print('Error in getPatientReport: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getMyReport() async {
    try {
      final response = await _api.get('reports/my-report');
      if (response is Map<String, dynamic>) {
        return response;
      }
      return {};
    } catch (e) {
      print('Error in getMyReport: $e');
      return {};
    }
  }

  Future<bool> sendReportWhatsApp(String patientId) async {
    try {
      final response = await _api.post('reports/send/$patientId', {});
      if (response is Map<String, dynamic>) {
        return response['success'] == true;
      }
      return false;
    } catch (e) {
      print('Error in sendReportWhatsApp: $e');
      return false;
    }
  }
}
