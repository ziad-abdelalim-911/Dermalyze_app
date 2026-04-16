import 'package:dio/dio.dart';
import 'package:dermalyze/core/network/dio_client.dart';
import 'package:dermalyze/core/network/api_exception.dart';

class ApiService {
  final DioClient _dioClient = DioClient();

  /// GET
  Future<dynamic> get(String endPoint, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dioClient.dio.get(
        endPoint,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  /// POST
  Future<dynamic> post(String endPoint, [dynamic body]) async {
    try {
      final response = await _dioClient.dio.post(endPoint, data: body);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  /// PUT / UPDATE
  Future<dynamic> put(String endPoint, Map<String, dynamic> body) async {
    try {
      final response = await _dioClient.dio.put(endPoint, data: body);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }

  /// DELETE
  Future<dynamic> delete(String endPoint, {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dioClient.dio.delete(endPoint, data: body, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      throw ApiExceptions.handleError(e);
    }
  }
}

// ignore: unused_element
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => message;
}
