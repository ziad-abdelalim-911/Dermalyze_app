import '../../domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {

  @override
  Future<void> login({
    required String email,
    required String password,
  }) async {

    await Future.delayed(const Duration(seconds: 2));

    if (email == "test@test.com" && password == "123456") {
      return;
    } else {
      throw Exception("Invalid email or password");
    }

  }
}