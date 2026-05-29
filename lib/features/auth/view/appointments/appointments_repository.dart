import 'package:dermalyze/core/network/api_service.dart';

class AppointmentsRepository {
  final ApiService _api = ApiService();

  /// GET /api/standard/appointments
  /// Fetch the list of all appointments for the current patient
  Future<List<Map<String, dynamic>>> getPatientAppointments() async {
    final response = await _api.get('standard/appointments');
    
    if (response is Map<String, dynamic>) {
      if (response['success'] == true && response['data'] is List) {
        return List<Map<String, dynamic>>.from(response['data']);
      } else if (response['data'] is List) {
        return List<Map<String, dynamic>>.from(response['data']);
      }
    } else if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    }
    
    return [];
  }
}
