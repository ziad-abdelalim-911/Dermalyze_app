abstract class LoginRepository {
  Future<void> login({
    required String email,
    required String password,
  });
}