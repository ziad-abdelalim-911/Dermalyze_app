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
    return data is List ? data : (data['analyses'] ?? []);
  }
}
