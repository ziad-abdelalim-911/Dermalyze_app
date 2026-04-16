import 'package:dermalyze/core/network/api_service.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:dermalyze/features/Login2/Data/models/login_response_model.dart';
import 'package:dermalyze/features/Login2/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final ApiService _apiService = ApiService();
  final TokenStorage _tokenStorage = TokenStorage();

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      'auth/login', // baseUrl already ends with /api/
      {'email': email, 'password': password},
    );

    final model = LoginResponseModel.fromJson(response);

    // حفظ التوكن وبيانات المستخدم ✅
    await _tokenStorage.saveToken(model.token);
    final userMap = model.user.toJson();
    await _tokenStorage.saveUser(userMap);

    return model;
  }
}
