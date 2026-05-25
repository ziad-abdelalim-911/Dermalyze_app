import 'dart:io';
import 'package:dermalyze/core/network/dio_client.dart';
import 'package:dio/dio.dart';

class AnalysisRepository {
  final Dio _dio = DioClient().dio;

  /// POST /api/analysis/{patientId}
  /// يرسل صورة الجلد ويرجع نتيجة الـ AI analysis
  Future<Map<String, dynamic>> analyzeImage({
    required String patientId,
    required File imageFile,
    void Function(int sent, int total)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        imageFile.path,
        filename: 'skin_image.jpg',
      ),
    });

    final response = await _dio.post(
      'analysis/$patientId',
      data: formData,
      onSendProgress: onProgress,
      options: Options(
        sendTimeout: const Duration(seconds: 90),
        receiveTimeout: const Duration(seconds: 90),
      ),
    );

    return response.data is Map<String, dynamic>
        ? response.data
        : {'result': response.data};
  }

  /// GET /api/patient/{patientId}/analyses
  /// جيب كل التحاليل السابقة للمريض
  Future<List<dynamic>> getPatientAnalyses(String patientId) async {
    final response = await _dio.get('patient/$patientId/analyses');
    final data = response.data;
    if (data is List) return data;
    // الباك إند الجديد بيرجع { data: [...] }
    if (data is Map && data['data'] is List) return data['data'] as List;
    // fallback للـ format القديم
    if (data is Map && data['analyses'] is List) return data['analyses'] as List;
    return [];
  }
}
