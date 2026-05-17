import 'dart:io';

class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String role; // "doctor" or "patient"
  final String? doctorCode; // مطلوب للـ patient بس
  final String? phone;
  final String? nationalId;
  final String? birthDate;
  final File? idCardFront;
  final File? idCardBack;
  final File? selfie;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.doctorCode,
    this.phone,
    this.nationalId,
    this.birthDate,
    this.idCardFront,
    this.idCardBack,
    this.selfie,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
    if (doctorCode != null && doctorCode!.isNotEmpty) {
      map['doctorCode'] = doctorCode;
    }
    if (phone != null && phone!.isNotEmpty) {
      map['phone'] = phone;
    }
    if (nationalId != null && nationalId!.isNotEmpty) {
      map['nationalId'] = nationalId;
    }
    if (birthDate != null && birthDate!.isNotEmpty) {
      map['birthDate'] = birthDate;
    }
    return map;
  }
}


