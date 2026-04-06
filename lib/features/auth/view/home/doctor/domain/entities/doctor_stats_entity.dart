class DoctorStatsEntity {
  final int totalPatients;
  final int infectedPeople;
  final int activeToday;
  final int criticalCases;

  const DoctorStatsEntity({
    required this.totalPatients,
    required this.infectedPeople,
    required this.activeToday,
    required this.criticalCases,
  });
}