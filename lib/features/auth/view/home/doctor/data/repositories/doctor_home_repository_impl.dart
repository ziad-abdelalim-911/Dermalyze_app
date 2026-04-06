import '../../domain/entities/doctor_stats_entity.dart';
import '../../domain/entities/patient_entity.dart';
import '../../domain/repositories/doctor_home_repository.dart';
import '../models/doctor_stats_model.dart';
import '../models/patient_model.dart';

class DoctorHomeRepositoryImpl implements DoctorHomeRepository {
  @override
  Future<DoctorStatsEntity> getDoctorStats() async {
    // TODO: استبدل بـ API call لما يجي الـ backend
    await Future.delayed(const Duration(milliseconds: 800));
    return DoctorStatsModel.mock();
  }

  @override
  Future<List<PatientEntity>> getPatients() async {
    // TODO: استبدل بـ API call لما يجي الـ backend
    await Future.delayed(const Duration(milliseconds: 800));
    return PatientModel.mockList();
  }

  @override
  Future<List<PatientEntity>> getCriticalPatients() async {
    // TODO: استبدل بـ API call لما يجي الـ backend
    await Future.delayed(const Duration(milliseconds: 800));
    return PatientModel.mockCriticalList();
  }
}