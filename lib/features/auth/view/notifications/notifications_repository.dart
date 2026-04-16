import 'package:dermalyze/core/network/api_service.dart';
import 'package:dermalyze/features/auth/view/notifications/notification_model.dart';
import 'package:dermalyze/core/storage/token_storage.dart';

class NotificationsRepository {
  final ApiService _api = ApiService();
  final TokenStorage _tokenStorage = TokenStorage();

  Future<List<NotificationModel>> getNotifications() async {
    final user = await _tokenStorage.getUser();
    final userId = user?['id'] ?? user?['_id'] ?? '';
    
    if (userId.isEmpty) {
      throw Exception('User ID not found');
    }

    try {
      final response = await _api.get('user/$userId/notifications');
      
      if (response is List) {
         return response.map((json) => NotificationModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      return [];
    } catch (e) {
      // If the endpoint doesn't exist, throw to let the UI show an Empty or Error state actively.
      throw Exception('Failed to load notifications: $e');
    }
  }

  Future<void> markAllAsRead() async {
    final user = await _tokenStorage.getUser();
    final userId = user?['id'] ?? user?['_id'] ?? '';
    
    if (userId.isNotEmpty) {
      await _api.put('user/$userId/notifications/read', {});
    }
  }
}
