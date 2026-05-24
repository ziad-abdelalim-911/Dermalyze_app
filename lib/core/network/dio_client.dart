import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:dermalyze/main.dart';
import 'package:dermalyze/core/routes/app_routes.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;
  static bool _isSessionExpired = false;

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://dermalyze-backend-final-main-production.up.railway.app/api/",
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {"Content-Type": "application/json"},
      ),
    );

    final tokenStorage = TokenStorage();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final String? token = await tokenStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          final isAuthRoute = error.requestOptions.path.contains('/auth/login') || 
                              error.requestOptions.path.contains('/auth/register');

          if (error.response?.statusCode == 401 && !isAuthRoute) {
            final currentToken = await tokenStorage.getToken();
            
            // Only trigger if a token exists and we haven't already triggered the logout
            if (currentToken != null && !_isSessionExpired) {
              _isSessionExpired = true;
              await tokenStorage.clearToken();
              
              final context = navigatorKey.currentContext;
              if (context != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Session expired. Please log in again.')),
                );
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (route) => false,
                );
              }
              
              // Reset flag after 3 seconds to allow future logins
              Future.delayed(const Duration(seconds: 3), () {
                _isSessionExpired = false;
              });
            }
          }
          return handler.next(error);
        },
      ),
    );

    assert(() {
      dio.interceptors.add(
        PrettyDioLogger(requestBody: true, responseBody: true),
      );
      return true;
    }());
  }
}