import 'package:dermalyze/core/network/api_service.dart';

class AuthPasswordRepository {
  final ApiService _api = ApiService();

  /// POST /api/user/forgot-password  →  sends OTP to email
  Future<void> sendResetCode(String email) async {
    await _api.post('user/forgot-password', {'email': email});
  }

  /// POST /api/user/verify-otp  →  verifies the 6-digit code
  Future<void> verifyOtp({required String email, required String code}) async {
    await _api.post('user/verify-otp', {'email': email, 'code': code});
  }

  /// POST /api/user/reset-password  →  sets new password after OTP confirmed
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _api.post('user/reset-password', {
      'email': email,
      'code': code,
      'newPassword': newPassword,
    });
  }
}
