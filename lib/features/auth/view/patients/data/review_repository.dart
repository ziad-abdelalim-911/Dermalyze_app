import 'package:dermalyze/core/network/api_service.dart';

class ReviewRepository {
  final ApiService _api = ApiService();

  /// POST /api/doctor/review/{patientId}
  Future<void> saveReview({
    required String patientId,
    required String review,
  }) async {
    await _api.post('doctor/review/$patientId', {
      'review': review,
    });
  }

  /// PUT /api/doctor/patients/{patientId}/status
  Future<void> updatePatientStatus({
    required String patientId,
    required String status, // 'improving' | 'stable' | 'critical'
  }) async {
    await _api.put('doctor/patients/$patientId/status', {
      'status': status,
    });
  }

  /// POST /api/doctor/appointments
  Future<void> scheduleFollowup({
    required String patientId,
    required String patientName,
    required String diagnosis,
    required String date,
    required String time,
  }) async {
    await _api.post('doctor/appointments', {
      'patientId': patientId,
      'patientName': patientName,
      'diagnosis': diagnosis,
      'appointmentDate': date,
      'appointmentTime': time,
    });
  }
}
