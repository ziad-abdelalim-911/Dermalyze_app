import 'package:dermalyze/core/network/api_service.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:dermalyze/features/Login2/Data/models/login_response_model.dart';
import 'package:dermalyze/features/auth/data/models/register_request_model.dart';

class RegisterRepository {
  final ApiService _apiService = ApiService();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<LoginResponseModel> register(RegisterRequestModel request) async {
    final response = await _apiService.post(
      'auth/register',
      request.toJson(),
    );

    final model = LoginResponseModel.fromJson(response);

    // حفظ التوكن + بيانات المستخدم بعد التسجيل ✅
    await _tokenStorage.saveToken(model.token);
    await _tokenStorage.saveUser(model.user.toJson());

    return model;
  }
}
