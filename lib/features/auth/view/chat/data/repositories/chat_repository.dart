import 'dart:convert';
import 'package:dermalyze/core/network/api_service.dart';
import 'package:dermalyze/features/auth/view/chat/model/message_model.dart';
import 'package:dermalyze/features/auth/view/chat/model/conversation_model.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRepository {
  final ApiService _apiService;
  final TokenStorage _tokenStorage = TokenStorage();

  ChatRepository(this._apiService);

  Future<List<MessageModel>> getMessages(String receiverId, String currentUserId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'chat_msgs_$receiverId';
      List<String> savedStr = prefs.getStringList(key) ?? [];
      
      if (savedStr.isNotEmpty) {
        return savedStr.map((e) {
          final json = jsonDecode(e);
          return MessageModel.fromJson(json, currentUserId);
        }).toList();
      }
      return [];
    } catch (e) {
      print("Error fetching messages: $e");
      return [];
    }
  }

  Future<MessageModel> sendMessage(MessageModel message) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final receiver = message.receiverId ?? '';
      final key = 'chat_msgs_$receiver';
      List<String> savedStr = prefs.getStringList(key) ?? [];
      
      final msgJson = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'senderId': message.senderId,
        'receiverId': message.receiverId,
        'content': message.content,
        'timestamp': DateTime.now().toIso8601String(),
        'type': message.type.name,
        'mediaUrl': message.mediaUrl,
        'status': 'read',
        'durationMs': message.durationMs,
      };
      
      savedStr.add(jsonEncode(msgJson));
      await prefs.setStringList(key, savedStr);

      return MessageModel.fromJson(msgJson, message.senderId);
    } catch (e) {
      return message;
    }
  }

  Future<List<ConversationModel>> getConversations(String currentUserId) async {
    try {
      final user = await _tokenStorage.getUser();
      final role = user?['role'];

      if (role == 'patient') {
        String docCode = user?['doctorCode'] ?? '';
        if (docCode.isEmpty) docCode = 'Ahmed Hassan';
        final prefs = await SharedPreferences.getInstance();
        final key = 'chat_msgs_$docCode';
        List<String> savedStr = prefs.getStringList(key) ?? [];
        
        String lastMsg = 'Start chatting now';
        String time = 'Just now';
        
        if (savedStr.isNotEmpty) {
          final lastJson = jsonDecode(savedStr.last);
          lastMsg = lastJson['content'] ?? 'Media';
          time = 'Recently';
        }

        return [
          ConversationModel(
            id: docCode,
            receiverId: docCode,
            name: 'Dr. $docCode',
            role: 'Dermatologist',
            lastMessage: lastMsg,
            time: time,
            isOnline: true,
            unreadCount: 0,
          )
        ];
      } else {
        // Mock list for Doctor
        return [
          ConversationModel(
            id: 'patient_1',
            receiverId: 'patient_1',
            name: 'Ahmed (Patient)',
            role: 'Patient',
            lastMessage: 'Tap to chat',
            time: '2 hours ago',
            isOnline: false,
            unreadCount: 1,
          ),
          ConversationModel(
            id: 'patient_2',
            receiverId: 'patient_2',
            name: 'Sara (Patient)',
            role: 'Patient',
            lastMessage: 'Thanks doctor',
            time: 'Yesterday',
            isOnline: true,
            unreadCount: 0,
          ),
        ];
      }
    } catch (e) {
      print("Error fetching conversations: $e");
      return [];
    }
  }
}
