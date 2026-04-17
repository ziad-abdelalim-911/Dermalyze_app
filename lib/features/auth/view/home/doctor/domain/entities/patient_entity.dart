class PatientEntity {
  final String id;
  final String name;
  final String diagnosis;
  final String qualityBadge;
  final String statusBadge;
  final double recoveryRate;
  final String lastVisit;
  final int age;
  final bool isCritical;
  final String phone;
  final String currentSymptoms;
  final String nextAppointment;

  const PatientEntity({
    required this.id,
    required this.name,
    required this.diagnosis,
    required this.qualityBadge,
    required this.statusBadge,
    required this.recoveryRate,
    required this.lastVisit,
    required this.age,
    required this.isCritical,
    this.phone = '',
    this.currentSymptoms = '',
    this.nextAppointment = '',
  });
}