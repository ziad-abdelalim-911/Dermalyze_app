import 'package:dermalyze/core/network/api_service.dart';
import 'package:dermalyze/features/auth/view/chat/model/message_model.dart';

class ChatRepository {
  final ApiService _apiService;

  ChatRepository(this._apiService);

  Future<List<MessageModel>> getMessages(String receiverId, String currentUserId) async {
    try {
      // Typically: /api/chat/messages/{receiverId}
      final response = await _apiService.get('chat/messages/$receiverId');
      
      if (response != null && response is List) {
        return response.map((json) => MessageModel.fromJson(json, currentUserId)).toList();
      } else if (response != null && response['data'] is List) {
        return (response['data'] as List).map((json) => MessageModel.fromJson(json, currentUserId)).toList();
      }
      return [];
    } catch (e) {
      // Return empty list if endpoint fails (graceful degradation since endpoint might not exist yet)
      print("Error fetching messages: $e");
      throw Exception('Failed to fetch messages');
    }
  }

  Future<MessageModel> sendMessage(MessageModel message) async {
    try {
      // Typically: /api/chat/send
      final response = await _apiService.post('chat/send', message.toJson());
      
      if (response != null) {
         Map<String, dynamic> data = response is Map<String, dynamic> ? response : (response['data'] ?? {});
         return MessageModel.fromJson(data, message.senderId);
      }
      return message;
    } catch (e) {
      print("Error sending message: $e");
      // Fallback optimistic return if endpoint isn't ready
      return message;
    }
  }
}
