import 'package:dermalyze/core/network/api_service.dart';
import '../../domain/entities/doctor_stats_entity.dart';
import '../../domain/entities/patient_entity.dart';
import '../../domain/repositories/doctor_home_repository.dart';
import '../models/doctor_stats_model.dart';
import '../models/patient_model.dart';

class DoctorHomeRepositoryImpl implements DoctorHomeRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<DoctorStatsEntity> getDoctorStats() async {
    final response = await _apiService.get('doctor/stats');
    return DoctorStatsModel.fromJson(response);
  }

  @override
  Future<List<PatientEntity>> getPatients() async {
    final response = await _apiService.get('patients');
    final List list = response is List ? response : (response['patients'] ?? []);
    return list.map((e) => PatientModel.fromJson(e)).toList();
  }

  @override
  Future<List<PatientEntity>> getCriticalPatients() async {
    // We already fetch patients, so doing it again here is redundant if called together.
    // However, to satisfy the interface, we keep the call but filter it.
    // A better approach is to filter it in the BLoC to avoid two network calls.
    final response = await _apiService.get('patients');
    final List list = response is List ? response : (response['patients'] ?? []);
    return list
        .map((e) => PatientModel.fromJson(e))
        .where((p) => p.isCritical)
        .toList();
  }
}