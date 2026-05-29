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

  final String improvement;

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
    this.improvement = '',
  });

  PatientEntity copyWith({
    String? id,
    String? name,
    String? diagnosis,
    String? qualityBadge,
    String? statusBadge,
    double? recoveryRate,
    String? lastVisit,
    int? age,
    bool? isCritical,
    String? phone,
    String? currentSymptoms,
    String? nextAppointment,
    String? improvement,
  }) {
    return PatientEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      diagnosis: diagnosis ?? this.diagnosis,
      qualityBadge: qualityBadge ?? this.qualityBadge,
      statusBadge: statusBadge ?? this.statusBadge,
      recoveryRate: recoveryRate ?? this.recoveryRate,
      lastVisit: lastVisit ?? this.lastVisit,
      age: age ?? this.age,
      isCritical: isCritical ?? this.isCritical,
      phone: phone ?? this.phone,
      currentSymptoms: currentSymptoms ?? this.currentSymptoms,
      nextAppointment: nextAppointment ?? this.nextAppointment,
      improvement: improvement ?? this.improvement,
    );
  }
}