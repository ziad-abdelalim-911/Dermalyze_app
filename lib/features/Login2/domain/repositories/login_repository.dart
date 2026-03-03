import 'package:dermalyze/features/login/data/models/login_response_model.dart';

abstract class LoginRepository {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });
}
