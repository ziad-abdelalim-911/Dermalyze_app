import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://your-api-base-url.com",
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {"Content-Type": "application/json"},
      ),
    );

    // ① Auth interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final String? token = _getToken(); // nullable String
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          // يمكنك تضيف هنا refresh token logic
          return handler.next(error);
        },
      ),
    );

    // ② Logger (في debug mode بس)
    assert(() {
      dio.interceptors.add(
        PrettyDioLogger(requestBody: true, responseBody: true),
      );
      return true;
    }());
  }

  /// استبدل ده بـ SharedPreferences أو SecureStorage
  String? _getToken() {
    return "your-auth-token";
  }
}