abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  LoginButtonPressed({
    required this.email,
    required this.password,
  });
}

class ActivateAccountPressed extends LoginEvent {
  final String token;
  final String password;

  ActivateAccountPressed({
    required this.token,
    required this.password,
  });
}