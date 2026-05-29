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
    super.phone,
    super.currentSymptoms,
    super.nextAppointment,
    super.improvement,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    final status = (json['status'] ?? 'Stable').toString();
    final recoveryVal = json['recoveryProgress'] ?? json['recovery'] ?? 0;
    double recovery = 0.0;
    if (recoveryVal is num) {
      recovery = recoveryVal.toDouble();
    } else if (recoveryVal is String) {
      recovery = double.tryParse(recoveryVal) ?? 0.0;
    }

    // الباك أند بيرجع updatedAt كـ ISO date - نحولها لـ "X days ago"
    final updatedAt = json['updatedAt'] ?? '';
    final lastVisitStr = _formatDate(updatedAt) ?? (json['lastVisit'] ?? '—');

    // nextAppointment - لو الباك أند بيرجعها
    final nextAppt = json['nextAppointment'] ?? json['next_appointment'] ?? '';

    // currentSymptoms من آخر تحليل لو موجود
    final symptoms = json['currentSymptoms'] ??
        json['current_symptoms'] ??
        json['symptoms'] ??
        '';

    return PatientModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      diagnosis: json['diagnosis'] ?? 'Unknown',
      qualityBadge: _recoveryToQuality(recovery),
      statusBadge: status.toLowerCase(),
      recoveryRate: recovery > 1 ? recovery / 100 : recovery,
      lastVisit: lastVisitStr,
      age: (json['age'] ?? 0) as int,
      isCritical: status.toLowerCase() == 'critical',
      phone: json['phone'] ?? '',
      currentSymptoms: symptoms,
      nextAppointment: nextAppt,
      improvement: (json['improvement'] ?? '').toString(),
    );
  }

  static String? _formatDate(String isoDate) {
    if (isoDate.isEmpty) return null;
    try {
      final date = DateTime.parse(isoDate);
      final diff = DateTime.now().difference(date);
      if (diff.inHours < 24) return '${diff.inHours} hours ago';
      if (diff.inDays == 1) return '1 day ago';
      if (diff.inDays < 7) return '${diff.inDays} days ago';
      return '${(diff.inDays / 7).floor()} weeks ago';
    } catch (_) {
      return null;
    }
  }

  static String _recoveryToQuality(double progress) {
    final val = progress > 1 ? progress : progress * 100;
    if (val >= 70) return 'High';
    if (val >= 40) return 'Medium';
    return 'Low';
  }

  // Mock Data (fallback لو API فشل)
  static List<PatientModel> mockList() {
    return const [
      PatientModel(
        id: '1', name: 'Sarah Johnson', diagnosis: 'Atopic Dermatitis',
        qualityBadge: 'Medium', statusBadge: 'improving',
        recoveryRate: 0.68, lastVisit: '2 days ago', age: 28,
        isCritical: false, phone: '+201001234567',
        currentSymptoms: 'Mild itching, redness', nextAppointment: 'Jan 15, 2025',
      ),
      PatientModel(
        id: '2', name: 'Michael Chen', diagnosis: 'Psoriasis',
        qualityBadge: 'Low', statusBadge: 'stable',
        recoveryRate: 0.45, lastVisit: '5 days ago', age: 42,
        isCritical: false, phone: '+201009876543',
        currentSymptoms: 'Scaling, dry patches', nextAppointment: 'Jan 18, 2025',
      ),
      PatientModel(
        id: '3', name: 'Emma Williams', diagnosis: 'Eczema',
        qualityBadge: 'High', statusBadge: 'improving',
        recoveryRate: 0.82, lastVisit: '1 day ago', age: 29,
        isCritical: false, phone: '',
        currentSymptoms: 'Reduced inflammation', nextAppointment: 'Jan 20, 2025',
      ),
    ];
  }

  static List<PatientModel> mockCriticalList() {
    return const [
      PatientModel(
        id: '7', name: 'William Martinez', diagnosis: 'Dermatitis Herpetiformis',
        qualityBadge: 'Low', statusBadge: 'critical',
        recoveryRate: 0.38, lastVisit: '12 hours ago', age: 51,
        isCritical: true, phone: '+201011112222',
        currentSymptoms: 'Severe blistering, intense itching',
        nextAppointment: 'Jan 8, 2025',
      ),
      PatientModel(
        id: '8', name: 'Ethan Thomas', diagnosis: 'Allergic Contact Dermatitis',
        qualityBadge: 'Low', statusBadge: 'critical',
        recoveryRate: 0.29, lastVisit: '1 day ago', age: 36,
        isCritical: true, phone: '+201033334444',
        currentSymptoms: 'Spreading rash, swelling',
        nextAppointment: 'Jan 9, 2025',
      ),
      PatientModel(
        id: '9', name: 'Daniel Wilson', diagnosis: 'Stevens-Johnson Syndrome',
        qualityBadge: 'Low', statusBadge: 'critical',
        recoveryRate: 0.22, lastVisit: '6 hours ago', age: 45,
        isCritical: true, phone: '+201055556666',
        currentSymptoms: 'Skin detachment, mucosal involvement',
        nextAppointment: 'Jan 7, 2025',
      ),
      PatientModel(
        id: '10', name: 'Grace Lee', diagnosis: 'Pemphigus Vulgaris',
        qualityBadge: 'Low', statusBadge: 'critical',
        recoveryRate: 0.35, lastVisit: '8 hours ago', age: 58,
        isCritical: true, phone: '+201077778888',
        currentSymptoms: 'Oral blisters, skin erosions',
        nextAppointment: 'Jan 10, 2025',
      ),
    ];
  }
}