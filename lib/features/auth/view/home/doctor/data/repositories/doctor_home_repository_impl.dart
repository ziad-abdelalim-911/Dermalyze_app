import 'package:dermalyze/core/network/api_service.dart';
import '../../domain/entities/doctor_stats_entity.dart';
import '../../domain/entities/patient_entity.dart';
import '../../domain/repositories/doctor_home_repository.dart';
import '../models/doctor_stats_model.dart';
import '../models/patient_model.dart';
import 'package:hive/hive.dart';

class DoctorHomeRepositoryImpl implements DoctorHomeRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<DoctorStatsEntity> getDoctorStats() async {
    final response = await _apiService.get('doctor/stats');
    return DoctorStatsModel.fromJson(response);
  }

  @override
  Future<List<PatientEntity>> getPatients() async {
    final box = Hive.box('offline_patients');
    try {
      final response = await _apiService.get('doctor/patients');
      final List list = response is List ? response : (response['patients'] ?? []);
      
      // Cache for offline
      await box.put('doctor_patients_list', list);
      
      return list.map((e) => PatientModel.fromJson(e)).toList();
    } catch (e) {
      // Fallback to cache
      final cachedList = box.get('doctor_patients_list');
      if (cachedList != null && cachedList is List) {
        return cachedList.map((e) => PatientModel.fromJson(Map<String, dynamic>.from(e))).toList();
      }
      return [];
    }
  }

  @override
  Future<List<PatientEntity>> getCriticalPatients() async {
    // We already fetch patients, so doing it again here is redundant if called together.
    // However, to satisfy the interface, we keep the call but filter it.
    // A better approach is to filter it in the BLoC to avoid two network calls.
    final response = await _apiService.get('doctor/patients');
    final List list = response is List ? response : (response['patients'] ?? []);
    return list
        .map((e) => PatientModel.fromJson(e))
        .where((p) => p.isCritical)
        .toList();
  }
}