import 'package:dermalyze/core/network/api_service.dart';

class MedicationRepository {
  final ApiService _api = ApiService();

  /// GET /api/patients/{patientId}/medications
  Future<List<dynamic>> getMedications(String patientId) async {
    final response = await _api.get('patients/$patientId/medications');
    return response is List ? response : (response['medications'] ?? []);
  }

  /// POST /api/patients/{patientId}/medications
  Future<Map<String, dynamic>> addMedication({
    required String patientId,
    required String name,
    required String dosage,
    required String frequency,
    String? notes,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    };
    final response = await _api.post('patients/$patientId/medications', body);
    return response is Map<String, dynamic> ? response : {};
  }

  /// PUT /api/medications/{id}
  Future<void> updateMedication(String medicationId, Map<String, dynamic> updates) async {
    await _api.put('medications/$medicationId', updates);
  }

  /// DELETE /api/medications/{id}
  Future<void> deleteMedication(String medicationId) async {
    await _api.delete('medications/$medicationId');
  }
}
