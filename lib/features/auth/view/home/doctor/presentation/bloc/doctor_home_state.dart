import '../../domain/entities/doctor_stats_entity.dart';
import '../../domain/entities/patient_entity.dart';

abstract class DoctorHomeState {}

class DoctorHomeInitial extends DoctorHomeState {}

class DoctorHomeLoading extends DoctorHomeState {}

class DoctorHomeLoaded extends DoctorHomeState {
  final DoctorStatsEntity stats;
  final List<PatientEntity> patients;
  final List<PatientEntity> filteredPatients;
  final List<PatientEntity> criticalPatients;
  final String searchQuery;
  final String selectedFilter;

  DoctorHomeLoaded({
    required this.stats,
    required this.patients,
    required this.filteredPatients,
    required this.criticalPatients,
    this.searchQuery = '',
    this.selectedFilter = 'All',
  });

  DoctorHomeLoaded copyWith({
    DoctorStatsEntity? stats,
    List<PatientEntity>? patients,
    List<PatientEntity>? filteredPatients,
    List<PatientEntity>? criticalPatients,
    String? searchQuery,
    String? selectedFilter,
  }) {
    return DoctorHomeLoaded(
      stats: stats ?? this.stats,
      patients: patients ?? this.patients,
      filteredPatients: filteredPatients ?? this.filteredPatients,
      criticalPatients: criticalPatients ?? this.criticalPatients,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

class DoctorHomeError extends DoctorHomeState {
  final String message;
  DoctorHomeError(this.message);
}