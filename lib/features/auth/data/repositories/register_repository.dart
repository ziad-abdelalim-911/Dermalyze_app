import 'package:dermalyze/core/network/api_service.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:dermalyze/features/Login2/Data/models/login_response_model.dart';
import 'package:dermalyze/features/auth/data/models/register_request_model.dart';
import 'package:dio/dio.dart';

class RegisterRepository {
  final ApiService _apiService = ApiService();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<LoginResponseModel> register(RegisterRequestModel request) async {
    dynamic body;

    if (request.role == 'doctor' &&
        (request.idCardFront != null ||
            request.idCardBack != null ||
            request.selfie != null)) {
      final map = request.toJson();
      if (request.idCardFront != null) {
        map['idCardFront'] =
            await MultipartFile.fromFile(request.idCardFront!.path);
      }
      if (request.idCardBack != null) {
        map['idCardBack'] =
            await MultipartFile.fromFile(request.idCardBack!.path);
      }
      if (request.selfie != null) {
        map['selfie'] = await MultipartFile.fromFile(request.selfie!.path);
      }
      body = FormData.fromMap(map);
    } else {
      body = request.toJson();
    }

    final response = await _apiService.post(
      'auth/register',
      body,
      Options(
        sendTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
      ),
    );

    final model = LoginResponseModel.fromJson(response);

    // حفظ التوكن + بيانات المستخدم بعد التسجيل ✅
    await _tokenStorage.saveToken(model.token);
    await _tokenStorage.saveUser(model.user.toJson());

    return model;
  }
}
