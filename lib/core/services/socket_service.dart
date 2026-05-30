import 'dart:async';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:dermalyze/core/network/dio_client.dart' as dermalyze_dio;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  final _profileUpdateController = StreamController<Map<String, dynamic>>.broadcast();
  final _patientUpdateController = StreamController<Map<String, dynamic>>.broadcast();
  final _chatMessageController = StreamController<Map<String, dynamic>>.broadcast();
  final _chatTypingController = StreamController<Map<String, dynamic>>.broadcast();
  final _chatDeliveredController = StreamController<Map<String, dynamic>>.broadcast();
  final _chatReadController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get profileStream => _profileUpdateController.stream;
  Stream<Map<String, dynamic>> get patientUpdateStream => _patientUpdateController.stream;
  Stream<Map<String, dynamic>> get chatMessageStream => _chatMessageController.stream;
  Stream<Map<String, dynamic>> get chatTypingStream => _chatTypingController.stream;
  Stream<Map<String, dynamic>> get chatDeliveredStream => _chatDeliveredController.stream;
  Stream<Map<String, dynamic>> get chatReadStream => _chatReadController.stream;

  Future<void> connect() async {
    if (_socket != null && _socket!.connected) return;

    final tokenStorage = TokenStorage();
    final token = await tokenStorage.getToken();
    if (token == null || token.isEmpty) return;

    // Use the base URL from ApiEndpoints without the /api/ suffix
    // Extract base URL correctly using DioClient
    final dioClient = dermalyze_dio.DioClient();
    String baseUrl = dioClient.dio.options.baseUrl.replaceAll('/api/', '');

    _socket = IO.io(baseUrl, IO.OptionBuilder()
        .setTransports(['websocket'])
        .setAuth({'token': token})
        .enableForceNew()
        .build());

    _socket?.onConnect((_) {
      print('✅ Socket.IO Connected');
    });

    _socket?.on('profile_updated', (data) {
      print('🔄 Real-time Profile Update Received: $data');
      if (data is Map) {
        _profileUpdateController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket?.on('patient_updated', (data) {
      print('🔄 Real-time Patient Update Received: $data');
      if (data is Map) {
        _patientUpdateController.add(Map<String, dynamic>.from(data));
      }
    });

    // Chat Events
    _socket?.on('receive_message', (data) {
      print('💬 Real-time Message Received: $data');
      if (data is Map) {
        _chatMessageController.add(Map<String, dynamic>.from(data));

        // Auto-acknowledge message receipt to the server (Double grey ticks)
        try {
          final msgData = data['message'] ?? data['data'] ?? data;
          final messageId = msgData['_id'] ?? msgData['id'];
          final senderId = msgData['senderId'];
          if (messageId != null && senderId != null) {
             messageReceived(messageId.toString(), senderId.toString());
          }
        } catch (e) {
           print('Error acknowledging message: $e');
        }
      }
    });

    _socket?.on('message_sent', (data) {
      print('📤 Real-time Message Sent Confirmed: $data');
      if (data is Map) {
        // You can use a specific key to differentiate or just pass it through
        final eventData = Map<String, dynamic>.from(data);
        eventData['isConfirmation'] = true;
        _chatMessageController.add(eventData);
      }
    });

    _socket?.on('user_typing', (data) {
      print('⌨️ User Typing Event: $data');
      if (data is Map) {
        _chatTypingController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket?.on('message_delivered', (data) {
      print('📥 Real-time Message Delivered: $data');
      if (data is Map) {
        _chatDeliveredController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket?.on('messages_read', (data) {
      print('👀 Real-time Messages Read: $data');
      if (data is Map) {
        _chatReadController.add(Map<String, dynamic>.from(data));
      }
    });

    _socket?.onDisconnect((_) {
      print('❌ Socket.IO Disconnected');
    });

    _socket?.connect();
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void markAsRead(String senderId, String receiverId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('mark_as_read', {
        'senderId': senderId,
        'receiverId': receiverId,
      });
    }
  }

  void messageReceived(String messageId, String senderId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('message_received', {
        'messageId': messageId,
        'senderId': senderId,
      });
    }
  }

  void emitTyping(String receiverId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('typing', {
        'receiverId': receiverId,
      });
    }
  }

  void emitStopTyping(String receiverId) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('stop_typing', {
        'receiverId': receiverId,
      });
    }
  }
}
