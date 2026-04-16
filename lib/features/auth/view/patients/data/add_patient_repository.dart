import 'package:dermalyze/core/network/api_service.dart';

class AddPatientRepository {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> addPatient({
    required String name,
    required int age,
    required String gender,
    String? diagnosis,
    String? nationalId,
    String? phone,
    String? address,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'age': age,
      'gender': gender.toLowerCase(), // "male" or "female"
    };
    if (diagnosis != null && diagnosis.isNotEmpty) body['diagnosis'] = diagnosis;
    if (nationalId != null && nationalId.isNotEmpty) body['nationalId'] = nationalId;
    if (phone != null && phone.isNotEmpty) body['phone'] = phone;
    if (address != null && address.isNotEmpty) body['address'] = address;

    final response = await _api.post('patients', body);
    return response is Map<String, dynamic> ? response : {};
  }
}
