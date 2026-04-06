import '../entities/patient_entity.dart';
import '../repositories/doctor_home_repository.dart';

class GetCriticalPatientsUseCase {
  final DoctorHomeRepository repository;

  GetCriticalPatientsUseCase(this.repository);

  Future<List<PatientEntity>> call() => repository.getCriticalPatients();
}