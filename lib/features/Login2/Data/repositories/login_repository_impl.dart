import 'package:dermalyze/core/network/api_exception.dart';
import 'package:dermalyze/core/network/api_service.dart';
import 'package:dermalyze/features/Login2/Data/models/login_response_model.dart';
import 'package:dermalyze/features/Login2/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final ApiService _apiService = ApiService();

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        "/login",
        data: {"email": email, "password": password},
      );

      final data = response.data;

      return LoginResponseModel.fromJson(data);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw ApiException(message: "Unexpected error occurred");
    }
  }
}
