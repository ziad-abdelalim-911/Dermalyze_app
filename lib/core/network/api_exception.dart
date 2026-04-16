import 'package:dio/dio.dart';
import 'package:dermalyze/core/network/api_error.dart';

class ApiExceptions {
  static ApiError handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiError(message: "Bad Connection");
      case DioExceptionType.receiveTimeout:
        return ApiError(message: "Server is taking too long to respond");
      case DioExceptionType.sendTimeout:
        return ApiError(message: "Request timed out while sending");
      case DioExceptionType.cancel:
        return ApiError(message: "Request was cancelled");
      case DioExceptionType.connectionError:
        return ApiError(message: "No internet connection");
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        if (responseData != null) {
          if (responseData is Map<String, dynamic>) {
            // Check structured error responses
            if (responseData['errors'] != null) {
               final errors = responseData['errors'];
               if(errors is List && errors.isNotEmpty){
                 return ApiError(message: errors.first.toString(), statusCode: statusCode);
               }
               return ApiError(message: errors.toString(), statusCode: statusCode);
            }
            if (responseData['message'] != null) {
               if (statusCode == 401 && responseData['message'] == 'Not authenticated.') {
                 return ApiError(message: 'Session expired. Please log in again.', statusCode: statusCode);
               }
              return ApiError(message: responseData['message'], statusCode: statusCode);
            }
            if (responseData['error'] != null) {
              return ApiError(message: responseData['error'], statusCode: statusCode);
            }
          } else if (responseData is String) {
              return ApiError(message: responseData, statusCode: statusCode);
          }
        }
        
        if (statusCode == 401) return ApiError(message: "Unauthorized", statusCode: 401);
        if (statusCode == 404) return ApiError(message: "Not Found", statusCode: 404);
        if (statusCode == 500) return ApiError(message: "Server Error", statusCode: 500);
        return ApiError(
          message: 'Invalid response from server.',
          statusCode: statusCode,
        );
      default:
        return ApiError(message: 'Something went wrong');
    }
  }
}
