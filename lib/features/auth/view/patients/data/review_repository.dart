import 'package:dermalyze/core/network/api_service.dart';

class ReviewRepository {
  final ApiService _api = ApiService();

  /// POST /api/patients/{patientId}/review
  Future<void> saveReview({
    required String patientId,
    required String review,
  }) async {
    await _api.post('doctor/patients/$patientId/review', {
      'review': review,
    });
  }

  /// PUT /api/doctor/patients/{patientId}/status
  Future<void> updatePatientStatus({
    required String patientId,
    required String status, // 'improving' | 'stable' | 'critical'
  }) async {
    // Capitalize first letter (e.g., 'stable' -> 'Stable')
    final capitalizedStatus = status[0].toUpperCase() + status.substring(1);
    
    await _api.put('patients/$patientId/status', {
      'status': capitalizedStatus,
    });
  }

  /// POST /api/patient/{patientId}/appointments
  Future<Map<String, dynamic>> scheduleFollowup({
    required String patientId,
    required String patientName,
    required String diagnosis,
    required String date,
    required String time,
  }) async {
    final response = await _api.post('doctor/patients/$patientId/appointments', {
      'patientName': patientName,
      'diagnosis': diagnosis,
      'appointmentDate': date,
      'appointmentTime': time,
    });
    
    // According to backend update, response returns a 'patient' object
    if (response is Map<String, dynamic>) {
      return response;
    }
    return {'patient': response};
  }
}
