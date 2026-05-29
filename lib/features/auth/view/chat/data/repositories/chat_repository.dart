import 'package:dermalyze/core/constants/api_endpoints.dart';
import 'package:dermalyze/core/network/api_service.dart';
import 'package:dermalyze/features/auth/view/chat/model/message_model.dart';
import 'package:dermalyze/features/auth/view/chat/model/conversation_model.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';

class ChatRepository {
  final ApiService _apiService;
  final TokenStorage _tokenStorage = TokenStorage();

  ChatRepository(this._apiService);

  // ─────────────────────────────────────────────────────────────────
  // GET chat/conversations  (Patient → sees their doctor)
  // ─────────────────────────────────────────────────────────────────
  Future<List<ConversationModel>> getConversations(String currentUserId) async {
    try {
      final response = await _apiService.get(ApiEndpoints.conversations);
      final rawList = _extractList(response, ['conversations', 'data', 'chats']);

      if (rawList.isNotEmpty) {
        return rawList
            .whereType<Map<String, dynamic>>()
            .map((json) => ConversationModel.fromJson(json))
            .toList();
      }

      // ── Fallback: build conversation from saved user data ─────────
      return await _buildPatientFallbackConversations();
    } catch (e) {
      debugLog('[ChatRepo] getConversations error: $e');
      return await _buildPatientFallbackConversations();
    }
  }

  /// When GET /chat/conversations returns empty, build the doctor
  /// conversation from the stored user profile (doctorCode / doctorId).
  Future<List<ConversationModel>> _buildPatientFallbackConversations() async {
    try {
      final user = await _tokenStorage.getUser();
      if (user == null) return [];

      final doctorId = user['doctorId']?.toString()
          ?? user['doctorCode']?.toString()
          ?? '';
      final doctorName = user['doctorName']?.toString() ?? '';

      if (doctorId.isEmpty) return [];

      return [
        ConversationModel(
          id: doctorId,
          receiverId: doctorId,
          name: doctorName.isNotEmpty ? 'Dr. $doctorName' : 'Your Doctor',
          role: 'Dermatologist',
          lastMessage: 'Tap to start chatting',
          time: '',
          isOnline: false,
          unreadCount: 0,
        )
      ];
    } catch (_) {
      return [];
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // GET doctor/patients  (Doctor → sees their patients as conversations)
  // ─────────────────────────────────────────────────────────────────
  Future<List<ConversationModel>> getDoctorPatients() async {
    try {
      final response = await _apiService.get(ApiEndpoints.doctorPatients);
      debugLog('!!! DOCTOR PATIENTS RESPONSE: $response');
      final rawList = _extractList(response, ['patients', 'data']);

      return rawList
          .whereType<Map<String, dynamic>>()
          .map((json) {
            debugLog('!!! PATIENT JSON: $json');
            return ConversationModel.fromPatient(json);
          })
          .toList();
    } catch (e) {
      debugLog('[ChatRepo] getDoctorPatients error: $e');
      return [];
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // GET chat/messages/{receiverId}
  // ─────────────────────────────────────────────────────────────────
  Future<List<MessageModel>> getMessages(
      String receiverId, String currentUserId) async {
    final box = Hive.box('offline_chats');
    final cacheKey = 'chat_${currentUserId}_$receiverId';

    try {
      final response =
          await _apiService.get(ApiEndpoints.chatMessages(receiverId));
      final rawList = _extractList(response, ['messages', 'data']);

      final messages = rawList
          .whereType<Map<String, dynamic>>()
          .map((json) => MessageModel.fromJson(json, currentUserId))
          .toList();

      // Save to Hive
      final List<Map<String, dynamic>> jsonList = messages.map((m) => {
        'id': m.id,
        'senderId': m.senderId,
        'receiverId': m.receiverId,
        'content': m.content,
        'timestamp': m.timestamp,
        'status': m.status.name,
        'type': m.type.name,
        'mediaUrl': m.mediaUrl,
        'durationMs': m.durationMs,
        'isMe': m.isMe,
      }).toList();
      await box.put(cacheKey, jsonList);

      return messages;
    } catch (e) {
      debugLog('[ChatRepo] getMessages error: $e');
      
      // Fallback to Hive cache
      final cachedData = box.get(cacheKey);
      if (cachedData != null && cachedData is List) {
        return cachedData.map((e) {
          final map = Map<String, dynamic>.from(e as Map);
          // Simple reconstruction from cache
          return MessageModel(
            id: map['id'],
            senderId: map['senderId'] ?? '',
            receiverId: map['receiverId'] ?? '',
            content: map['content'] ?? '',
            timestamp: map['timestamp'],
            isMe: map['isMe'] ?? false,
          );
        }).toList();
      }
      return [];
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // POST chat/send  { receiverId, content }
  // ─────────────────────────────────────────────────────────────────
  Future<MessageModel> sendMessage(MessageModel message) async {
    try {
      final user = await _tokenStorage.getUser();
      final currentUserId = user?['_id']?.toString() ?? '';

      dynamic body;
      if (message.mediaUrl != null && !message.mediaUrl!.startsWith('http')) {
        body = FormData.fromMap({
          'receiverId': message.receiverId,
          'content': message.content,
          'type': message.type.name,
          if (message.durationMs > 0) 'durationMs': message.durationMs,
          'file': await MultipartFile.fromFile(message.mediaUrl!),
        });
      } else {
        body = <String, dynamic>{
          'receiverId': message.receiverId,
          'content': message.content,
          if (message.type.name != 'text') 'type': message.type.name,
          if (message.mediaUrl != null) 'mediaUrl': message.mediaUrl,
          if (message.durationMs > 0) 'durationMs': message.durationMs,
        };
      }

      final response =
          await _apiService.post(ApiEndpoints.sendMessage, body);

      if (response is Map<String, dynamic>) {
        final msgJson = (response['message'] ??
            response['data'] ??
            response) as Map<String, dynamic>;
        if (msgJson.isNotEmpty) {
          return MessageModel.fromJson(msgJson, currentUserId);
        }
      }
      return message;
    } catch (e) {
      debugLog('[ChatRepo] sendMessage error: $e');
      throw Exception('Failed to send message');
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // DELETE chat/messages/{messageId}
  // ─────────────────────────────────────────────────────────────────
  Future<void> deleteMessage(String messageId) async {
    try {
      await _apiService.delete(ApiEndpoints.deleteMessage(messageId));
    } catch (e) {
      debugLog('[ChatRepo] deleteMessage error: $e');
      throw Exception('Failed to delete message');
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // DELETE chat/conversations/{receiverId}
  // ─────────────────────────────────────────────────────────────────
  Future<void> deleteConversation(String receiverId) async {
    try {
      await _apiService.delete(ApiEndpoints.deleteConversation(receiverId));
    } catch (e) {
      debugLog('[ChatRepo] deleteConversation error: $e');
      throw Exception('Failed to delete conversation');
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────
  List<dynamic> _extractList(dynamic response, List<String> keys) {
    if (response is List) return response;
    if (response is Map<String, dynamic>) {
      for (final key in keys) {
        if (response[key] is List) return response[key] as List;
      }
    }
    return [];
  }

  void debugLog(String msg) {
    assert(() {
      // ignore: avoid_print
      print(msg);
      return true;
    }());
  }
}
