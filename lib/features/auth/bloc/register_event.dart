// register_event.dart
import 'dart:io';

abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String name;
  final String email;
  final String password;
  final String role; // "doctor" or "patient"
  final String? doctorCode;
  final String? phone;
  final String? nationalId;
  final String? birthDate;
  final File? idCardFront;
  final File? idCardBack;
  final File? selfie;

  RegisterSubmitted({
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
}
