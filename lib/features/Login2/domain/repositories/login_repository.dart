
import 'package:dermalyze/features/Login2/Data/models/login_response_model.dart';

abstract class LoginRepository {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  Future<LoginResponseModel> activateAccount({
    required String token,
    required String password,
  });
}
