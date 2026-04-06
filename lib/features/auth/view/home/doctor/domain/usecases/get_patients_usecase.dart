import '../entities/patient_entity.dart';
import '../repositories/doctor_home_repository.dart';

class GetPatientsUseCase {
  final DoctorHomeRepository repository;

  GetPatientsUseCase(this.repository);

  Future<List<PatientEntity>> call() => repository.getPatients();
}