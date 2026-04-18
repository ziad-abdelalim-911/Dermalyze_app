import 'package:dermalyze/core/network/api_service.dart';
import 'package:dermalyze/features/auth/view/notifications/notification_model.dart';
import 'package:dermalyze/core/storage/token_storage.dart';

class NotificationsRepository {
  final ApiService _api = ApiService();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<NotificationModel>> getNotifications() async {
    final user = await _tokenStorage.getUser();
    final userId = user?['id'] ?? user?['_id'] ?? '';
    final role = user?['role'] ?? 'patient';

    if (userId.isEmpty) {
      throw Exception('User ID not found');
    }

    try {
      final endpoint = (role == 'doctor') ? 'doctor/notifications' : 'patient/notifications';
      final response = await _api.get(endpoint);

      if (response is List) {
        return response
            .map(
              (json) =>
                  NotificationModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to load notifications: $e');
    }
  }

  Future<void> markAllAsRead() async {
    final user = await _tokenStorage.getUser();
    final role = user?['role'] ?? 'patient';

    if (user != null) {
      final endpoint = (role == 'doctor') ? 'doctor/notifications/read' : 'patient/notifications/read';
      await _api.put(endpoint, {});
    }
  }

  Future<void> markAsRead(String id) async {
    final user = await _tokenStorage.getUser();
    final role = user?['role'] ?? 'patient';

    if (user != null) {
      final endpoint = (role == 'doctor') ? 'doctor/notifications/$id/read' : 'patient/notifications/$id/read';
      await _api.put(endpoint, {});
    }
  }
}
