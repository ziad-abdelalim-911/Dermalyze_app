import '../entities/doctor_stats_entity.dart';
import '../repositories/doctor_home_repository.dart';

class GetDoctorStatsUseCase {
  final DoctorHomeRepository repository;

  GetDoctorStatsUseCase(this.repository);

  Future<DoctorStatsEntity> call() => repository.getDoctorStats();
}