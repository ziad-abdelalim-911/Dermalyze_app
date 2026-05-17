class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String role;        // "doctor" or "patient"
  final String? doctorCode; // موجود لو doctor بس
  final String? dateOfBirth;
  final String? nationalId;
  final String? diagnosis;
  final String? allergies;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.doctorCode,
    this.dateOfBirth,
    this.nationalId,
    this.diagnosis,
    this.allergies,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      role: json['role']?.toString() ?? 'patient',
      doctorCode: json['doctorCode']?.toString(),
      dateOfBirth: json['dateOfBirth']?.toString() ?? json['birthDate']?.toString(),
      nationalId: json['nationalId']?.toString(),
      diagnosis: json['diagnosis']?.toString(),
      allergies: json['allergies']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      if (phone != null) 'phone': phone,
      'role': role,
      if (doctorCode != null) 'doctorCode': doctorCode,
      if (dateOfBirth != null) 'dateOfBirth': dateOfBirth,
      if (nationalId != null) 'nationalId': nationalId,
      if (diagnosis != null) 'diagnosis': diagnosis,
      if (allergies != null) 'allergies': allergies,
    };
  }

  bool get isDoctor => role == 'doctor';
  bool get isPatient => role == 'patient';
}