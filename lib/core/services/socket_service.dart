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

  Stream<Map<String, dynamic>> get profileStream => _profileUpdateController.stream;

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
