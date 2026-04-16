class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String role; // "doctor" or "patient"
  final String? doctorCode; // مطلوب للـ patient بس
  final String? phone;
  final String? nationalId;
  final String? birthDate;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.doctorCode,
    this.phone,
    this.nationalId,
    this.birthDate,
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

