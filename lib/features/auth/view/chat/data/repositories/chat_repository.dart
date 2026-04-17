import 'package:dermalyze/core/network/api_service.dart';
import 'package:dermalyze/features/auth/view/chat/model/message_model.dart';
import 'package:dermalyze/features/auth/view/chat/model/conversation_model.dart';

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
      return message;
    }
  }

  Future<List<ConversationModel>> getConversations(String currentUserId) async {
    List<ConversationModel> _fallbackMocks = [
      ConversationModel(
        id: 'c1',
        receiverId: 'doctor_123',
        name: 'Dr. Ahmed Hassan',
        role: 'Dermatologist',
        lastMessage: 'Good progress! Continue...',
        time: '5 min ago',
        isOnline: true,
        unreadCount: 0,
      ),
      ConversationModel(
        id: 'c2',
        receiverId: 'doctor_456',
        name: 'Dr. Sarah Mitchell',
        role: 'Dermatologist',
        lastMessage: 'Your lab results are ready.',
        time: '2 hours ago',
        isOnline: false,
        unreadCount: 2,
      ),
    ];

    try {
      final response = await _apiService.get('chat/conversations');
      List<ConversationModel> parsedList = [];

      if (response != null && response is List) {
        parsedList = response.map((json) => ConversationModel.fromJson(json)).toList();
      } else if (response != null && response['data'] is List) {
        parsedList = (response['data'] as List).map((json) => ConversationModel.fromJson(json)).toList();
      }

      // If backend returns empty list (no real chats yet), force mocks for UI testing purposes
      if (parsedList.isEmpty) {
        return _fallbackMocks;
      }
      return parsedList;

    } catch (e) {
      print("Error fetching conversations: $e");
      return _fallbackMocks;
    }
  }
}
