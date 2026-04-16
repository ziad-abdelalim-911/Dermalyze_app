// register_event.dart
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

  RegisterSubmitted({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.doctorCode,
    this.phone,
    this.nationalId,
    this.birthDate,
  });
}
