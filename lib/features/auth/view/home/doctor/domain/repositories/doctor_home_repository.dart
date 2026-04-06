import '../entities/doctor_stats_entity.dart';
import '../entities/patient_entity.dart';

abstract class DoctorHomeRepository {
  Future<DoctorStatsEntity> getDoctorStats();
  Future<List<PatientEntity>> getPatients();
  Future<List<PatientEntity>> getCriticalPatients();
}