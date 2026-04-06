import '../../domain/entities/doctor_stats_entity.dart';

class DoctorStatsModel extends DoctorStatsEntity {
  const DoctorStatsModel({
    required super.totalPatients,
    required super.infectedPeople,
    required super.activeToday,
    required super.criticalCases,
  });

  factory DoctorStatsModel.fromJson(Map<String, dynamic> json) {
    return DoctorStatsModel(
      totalPatients: json['total_patients'] ?? 0,
      infectedPeople: json['infected_people'] ?? 0,
      activeToday: json['active_today'] ?? 0,
      criticalCases: json['critical_cases'] ?? 0,
    );
  }

  // Mock Data
  factory DoctorStatsModel.mock() {
    return const DoctorStatsModel(
      totalPatients: 247,
      infectedPeople: 84,
      activeToday: 23,
      criticalCases: 5,
    );
  }
}