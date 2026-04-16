class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;        // "doctor" or "patient"
  final String? doctorCode; // موجود لو doctor بس

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.doctorCode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'patient',
      doctorCode: json['doctorCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      if (doctorCode != null) 'doctorCode': doctorCode,
    };
  }

  bool get isDoctor => role == 'doctor';
  bool get isPatient => role == 'patient';
}