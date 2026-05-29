import 'dart:async';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:dermalyze/core/constants/api_endpoints.dart';
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

  Stream<Map<String, dynamic>> get profileStream => _profileUpdateController.stream;
  Stream<Map<String, dynamic>> get patientUpdateStream => _patientUpdateController.stream;
  Stream<Map<String, dynamic>> get chatMessageStream => _chatMessageController.stream;
  Stream<Map<String, dynamic>> get chatTypingStream => _chatTypingController.stream;

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
      if (data is Map<String, dynamic>) {
        _profileUpdateController.add(data);
      }
    });

    _socket?.on('patient_updated', (data) {
      print('🔄 Real-time Patient Update Received: $data');
      if (data is Map<String, dynamic>) {
        _patientUpdateController.add(data);
      }
    });

    // Chat Events
    _socket?.on('receive_message', (data) {
      print('💬 Real-time Message Received: $data');
      if (data is Map<String, dynamic>) {
        _chatMessageController.add(data);
      }
    });

    _socket?.on('message_sent', (data) {
      print('📤 Real-time Message Sent Confirmed: $data');
      if (data is Map<String, dynamic>) {
        // You can use a specific key to differentiate or just pass it through
        final eventData = Map<String, dynamic>.from(data);
        eventData['isConfirmation'] = true;
        _chatMessageController.add(eventData);
      }
    });

    _socket?.on('user_typing', (data) {
      print('⌨️ User Typing Event: $data');
      if (data is Map<String, dynamic>) {
        _chatTypingController.add(data);
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
}
