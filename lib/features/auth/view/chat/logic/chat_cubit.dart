import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dermalyze/features/auth/view/chat/data/repositories/chat_repository.dart';
import 'package:dermalyze/features/auth/view/chat/model/message_model.dart';
import 'package:dermalyze/features/auth/view/chat/model/message_type.dart';
import 'package:dermalyze/core/storage/token_storage.dart';

// ─────────────────────────────────── States ──────────────────────────────────

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

// ─────────────────────────────────── Cubit ───────────────────────────────────

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  final String receiverId;
  String? currentUserId;
  Timer? _pollingTimer;

  final List<MessageModel> _localMessages = [];

  ChatCubit(this._chatRepository, {required this.receiverId})
      : super(ChatInitial()) {
    _init();
  }

  Future<void> _init() async {
    final user = await TokenStorage().getUser();
    currentUserId = user?['_id']?.toString() ?? '';
    await loadMessages();
    _startPolling();
  }

  // ─────────────────────────────────────────────────────────────────
  // Load messages from backend
  // ─────────────────────────────────────────────────────────────────
  Future<void> loadMessages() async {
    if (isClosed) return;
    if (state is ChatInitial) emit(ChatLoading());

    try {
      final messages =
          await _chatRepository.getMessages(receiverId, currentUserId ?? '');

      // Merge backend messages with local optimistic messages
      _mergeMessages(messages);
      _emitLoaded();
    } catch (e) {
      // Keep showing local messages on error, don't flash error screen
      if (_localMessages.isEmpty) {
        if (!isClosed) emit(ChatError('Failed to load messages. Please try again.'));
      } else {
        _emitLoaded();
      }
    }
  }

  /// Merges freshly fetched messages with local ones, keeping optimistic
  /// messages that haven't been confirmed yet.
  void _mergeMessages(List<MessageModel> fetched) {
    final fetchedIds = fetched.map((m) => m.id).toSet();

    // Keep any local optimistic messages (no id yet) not in fetched list
    final optimistic = _localMessages
        .where((m) => m.id == null || !fetchedIds.contains(m.id))
        .where((m) =>
            m.isMe &&
            (m.status == MessageStatus.pending ||
                m.status == MessageStatus.failed ||
                m.status == MessageStatus.sent ||
                m.status == MessageStatus.delivered))
        .toList();

    _localMessages
      ..clear()
      ..addAll(fetched)
      ..addAll(optimistic);

    // Sort by timestamp
    _localMessages.sort((a, b) {
      final ta = DateTime.tryParse(a.timestamp ?? '') ?? DateTime(0);
      final tb = DateTime.tryParse(b.timestamp ?? '') ?? DateTime(0);
      return ta.compareTo(tb);
    });
  }

  void _emitLoaded({bool isRecording = false}) {
    if (isClosed) return;
    emit(ChatLoaded(List.from(_localMessages), isRecording: isRecording));
  }

  // ─────────────────────────────────────────────────────────────────
  // Send text message
  // ─────────────────────────────────────────────────────────────────
  Future<void> sendMessage(String content,
      {MessageType type = MessageType.text, String? mediaUrl}) async {
    if (content.trim().isEmpty && type == MessageType.text) return;

    final optimistic = MessageModel(
      senderId: currentUserId ?? '',
      receiverId: receiverId,
      content: content.trim(),
      timestamp: DateTime.now().toIso8601String(),
      isMe: true,
      type: type,
      mediaUrl: mediaUrl,
      status: MessageStatus.pending,
    );

    _localMessages.add(optimistic);
    _emitLoaded();

    try {
      final sent = await _chatRepository.sendMessage(optimistic);
      final idx = _localMessages.indexOf(optimistic);
      if (idx != -1) {
        _localMessages[idx] = sent.copyWith(status: MessageStatus.sent);
        _emitLoaded();
      }
    } catch (_) {
      final idx = _localMessages.indexOf(optimistic);
      if (idx != -1) {
        _localMessages[idx] = optimistic.copyWith(status: MessageStatus.failed);
        _emitLoaded();
      }
    }
  }

  void _simulateDelivered(int index) {
    Future.delayed(const Duration(seconds: 2), () {
      if (index < _localMessages.length && !isClosed) {
        _localMessages[index] =
            _localMessages[index].copyWith(status: MessageStatus.delivered);
        _emitLoaded();
      }
    });
  }

  // ─────────────────────────────────────────────────────────────────
  // Send media (image / file)
  // ─────────────────────────────────────────────────────────────────
  Future<void> sendMedia(String path, MessageType type) async {
    await sendMessage(
      type == MessageType.image ? 'Photo' : 'Document',
      type: type,
      mediaUrl: path,
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Send voice
  // ─────────────────────────────────────────────────────────────────
  Future<void> sendVoice(String path, int durationMs) async {
    final optimistic = MessageModel(
      senderId: currentUserId ?? '',
      receiverId: receiverId,
      content: '',
      timestamp: DateTime.now().toIso8601String(),
      isMe: true,
      type: MessageType.audio,
      mediaUrl: path,
      status: MessageStatus.pending,
      durationMs: durationMs,
    );

    _localMessages.add(optimistic);
    _emitLoaded();

    try {
      final sent = await _chatRepository.sendMessage(optimistic);
      final idx = _localMessages.indexOf(optimistic);
      if (idx != -1) {
        _localMessages[idx] = sent.copyWith(status: MessageStatus.sent);
        _emitLoaded();
      }
    } catch (_) {
      final idx = _localMessages.indexOf(optimistic);
      if (idx != -1) {
        _localMessages[idx] = optimistic.copyWith(status: MessageStatus.failed);
        _emitLoaded();
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Delete message
  // ─────────────────────────────────────────────────────────────────
  Future<void> deleteMessage(String messageId) async {
    // Optimistic UI update
    final index = _localMessages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final deletedMessage = _localMessages[index];
    _localMessages.removeAt(index);
    _emitLoaded();

    try {
      await _chatRepository.deleteMessage(messageId);
    } catch (e) {
      if (isClosed) return;
      // Revert if failed
      _localMessages.insert(index, deletedMessage);
      _emitLoaded();
      emit(ChatError('Failed to delete message.'));
    }
  }

  void setRecording(bool recording) {
    if (state is ChatLoaded) _emitLoaded(isRecording: recording);
  }

  void _startPolling() {
    _pollingTimer =
        Timer.periodic(const Duration(seconds: 5), (_) => loadMessages());
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
