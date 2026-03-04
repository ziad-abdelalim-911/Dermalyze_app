import 'package:dio/dio.dart';
import 'dio_client.dart';
import 'api_exception.dart';

class ApiService {
  final Dio _dio = DioClient().dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return ApiException(message: "Connection timeout");
    }

    if (e.type == DioExceptionType.receiveTimeout) {
      return ApiException(message: "Receive timeout");
    }

    if (e.type == DioExceptionType.badResponse) {
      return ApiException(
        message: e.response?.data["message"] ?? "Server error",
        statusCode: e.response?.statusCode,
      );
    }

    if (e.type == DioExceptionType.connectionError) {
      return ApiException(message: "No internet connection");
    }

    return ApiException(message: "Unexpected error occurred");
  }
}