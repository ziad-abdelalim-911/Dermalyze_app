import '../../domain/entities/patient_entity.dart';

class PatientModel extends PatientEntity {
  const PatientModel({
    required super.id,
    required super.name,
    required super.diagnosis,
    required super.qualityBadge,
    required super.statusBadge,
    required super.recoveryRate,
    required super.lastVisit,
    required super.age,
    required super.isCritical,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      qualityBadge: json['quality_badge'] ?? '',
      statusBadge: json['status_badge'] ?? '',
      recoveryRate: (json['recovery_rate'] ?? 0).toDouble(),
      lastVisit: json['last_visit'] ?? '',
      age: json['age'] ?? 0,
      isCritical: json['is_critical'] ?? false,
    );
  }

  // Mock Data
  static List<PatientModel> mockList() {
    return const [
      PatientModel(id: '1', name: 'Sarah Johnson', diagnosis: 'Atopic Dermatitis', qualityBadge: 'Medium', statusBadge: 'improving', recoveryRate: 0.68, lastVisit: '2 days ago', age: 28, isCritical: false),
      PatientModel(id: '2', name: 'Michael Chen', diagnosis: 'Psoriasis', qualityBadge: 'Low', statusBadge: 'stable', recoveryRate: 0.45, lastVisit: '5 days ago', age: 42, isCritical: false),
      PatientModel(id: '3', name: 'Emma Williams', diagnosis: 'Eczema', qualityBadge: 'High', statusBadge: 'improving', recoveryRate: 0.82, lastVisit: '1 day ago', age: 29, isCritical: false),
      PatientModel(id: '4', name: 'James Brown', diagnosis: 'Contact Dermatitis', qualityBadge: 'High', statusBadge: 'recovering', recoveryRate: 0.91, lastVisit: '3 days ago', age: 35, isCritical: false),
      PatientModel(id: '5', name: 'Olivia Davis', diagnosis: 'Rosacea', qualityBadge: 'Medium', statusBadge: 'stable', recoveryRate: 0.56, lastVisit: '4 days ago', age: 31, isCritical: false),
      PatientModel(id: '6', name: 'Robert Miller', diagnosis: 'Seborrheic Dermatitis', qualityBadge: 'Medium', statusBadge: 'improving', recoveryRate: 0.73, lastVisit: '1 day ago', age: 41, isCritical: false),
    ];
  }

  static List<PatientModel> mockCriticalList() {
    return const [
      PatientModel(id: '7', name: 'William Martinez', diagnosis: 'Dermatitis Herpetiformis', qualityBadge: 'Low', statusBadge: 'critical', recoveryRate: 0.38, lastVisit: '12 hours ago', age: 51, isCritical: true),
      PatientModel(id: '8', name: 'Ethan Thomas', diagnosis: 'Allergic Contact Dermatitis', qualityBadge: 'Low', statusBadge: 'critical', recoveryRate: 0.29, lastVisit: '1 day ago', age: 36, isCritical: true),
      PatientModel(id: '9', name: 'Daniel Wilson', diagnosis: 'Stevens-Johnson Syndrome', qualityBadge: 'Low', statusBadge: 'critical', recoveryRate: 0.22, lastVisit: '6 hours ago', age: 45, isCritical: true),
      PatientModel(id: '10', name: 'Grace Lee', diagnosis: 'Pemphigus Vulgaris', qualityBadge: 'Low', statusBadge: 'critical', recoveryRate: 0.35, lastVisit: '8 hours ago', age: 58, isCritical: true),
      PatientModel(id: '11', name: 'Lucas Moore', diagnosis: 'Toxic Epidermal Necrolysis', qualityBadge: 'Low', statusBadge: 'critical', recoveryRate: 0.18, lastVisit: '4 hours ago', age: 52, isCritical: true),
    ];
  }
}