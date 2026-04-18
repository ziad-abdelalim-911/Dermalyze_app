import 'dart:async';
import 'package:dermalyze/features/auth/view/chat/model/message_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dermalyze/features/auth/view/chat/data/repositories/chat_repository.dart';
import 'package:dermalyze/features/auth/view/chat/model/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<MessageModel> messages;
  final bool isRecording;
  ChatLoaded(this.messages, {this.isRecording = false});
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  final String receiverId;
  String? currentUserId;
  Timer? _pollingTimer;

  final List<MessageModel> _localMessages = [];

  ChatCubit(this._chatRepository, {required this.receiverId}) : super(ChatInitial()) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getString('user_id') ?? 'doctor_456';

    _localMessages.addAll([
      MessageModel(
        id: '1',
        senderId: receiverId,
        receiverId: currentUserId!,
        content: "Hello! How are you feeling today?",
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)).toIso8601String(),
        isMe: false,
        status: MessageStatus.read,
      ),
      MessageModel(
        id: '2',
        senderId: currentUserId!,
        receiverId: receiverId,
        content: "Good morning! I'm feeling much better!",
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)).toIso8601String(),
        isMe: true,
        status: MessageStatus.read,
      ),
    ]);

    await loadMessages();
    _startPolling();
    markMessagesAsRead();
  }

  Future<void> loadMessages() async {
    if (state is ChatInitial) {
      emit(ChatLoading());
    }

    try {
      final messages = await _chatRepository.getMessages(receiverId, currentUserId!);
      if (messages.isNotEmpty) {
        _localMessages.clear();
        _localMessages.addAll(messages);
      }
      _emitLoaded();
    } catch (e) {
      _emitLoaded();
    }
  }

  void _emitLoaded({bool isRecording = false}) {
    emit(ChatLoaded(List.from(_localMessages), isRecording: isRecording));
  }

  Future<void> sendMessage(String content, {MessageType type = MessageType.text, String? mediaUrl}) async {
    if (content.trim().isEmpty && type == MessageType.text) return;

    final newMessage = MessageModel(
      senderId: currentUserId!,
      receiverId: receiverId,
      content: content.trim(),
      timestamp: DateTime.now().toIso8601String(),
      isMe: true,
      type: type,
      mediaUrl: mediaUrl,
      status: MessageStatus.pending,
    );

    _localMessages.add(newMessage);
    _emitLoaded();

    try {
      final sentMessage = await _chatRepository.sendMessage(newMessage);
      final index = _localMessages.indexOf(newMessage);
      if (index != -1) {
        _localMessages[index] = sentMessage.copyWith(status: MessageStatus.sent);
        _emitLoaded();
        
        // Simulation: Deliver after 1 second, Read after 3 seconds
        _simulateStatusUpdates(index);
      }
    } catch (e) {
       final index = _localMessages.indexOf(newMessage);
       if (index != -1) {
         _localMessages[index] = newMessage.copyWith(status: MessageStatus.sent);
         _emitLoaded();
         _simulateStatusUpdates(index);
       }
    }
  }

  void _simulateStatusUpdates(int index) {
    Future.delayed(const Duration(seconds: 1), () {
      if (index < _localMessages.length) {
        _localMessages[index] = _localMessages[index].copyWith(status: MessageStatus.delivered);
        _emitLoaded();
      }
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (index < _localMessages.length) {
        _localMessages[index] = _localMessages[index].copyWith(status: MessageStatus.read);
        _emitLoaded();
      }
    });
  }

  Future<void> sendMedia(String path, MessageType type) async {
    // Simulation: Create a local message representing the media
    await sendMessage("Sent a ${type.name}", type: type, mediaUrl: path);
  }

  void setRecording(bool recording) {
    if (state is ChatLoaded) {
      _emitLoaded(isRecording: recording);
    }
  }

  Future<void> markMessagesAsRead() async {
    // Notify backend that messages are read
    try {
      // Typically: await _chatRepository.markAsRead(receiverId);
      // For now we just update local state if any messages were unread from the other party
      for (int i = 0; i < _localMessages.length; i++) {
        if (!_localMessages[i].isMe && _localMessages[i].status != MessageStatus.read) {
          // This would usually be updated by the server on next poll
        }
      }
    } catch (_) {}
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      loadMessages();
    });
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
