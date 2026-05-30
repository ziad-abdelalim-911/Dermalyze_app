import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dermalyze/features/auth/view/chat/data/repositories/chat_repository.dart';
import 'package:dermalyze/features/auth/view/chat/model/message_model.dart';
import 'package:dermalyze/features/auth/view/chat/model/message_type.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:dermalyze/core/services/socket_service.dart';

// ─────────────────────────────────── States ──────────────────────────────────

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<MessageModel> messages;
  final bool isRecording;
  final bool isTyping;
  final bool hasReachedMax;
  final int page;
  ChatLoaded(this.messages, {this.isRecording = false, this.isTyping = false, this.hasReachedMax = false, this.page = 1});
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

  final List<MessageModel> _localMessages = [];
  StreamSubscription? _chatMessageSub;
  StreamSubscription? _chatTypingSub;
  StreamSubscription? _chatDeliveredSub;
  StreamSubscription? _chatReadSub;

  int _currentPage = 1;
  bool _hasReachedMax = false;
  bool _isTyping = false;
  Timer? _typingIndicatorTimer;
  Timer? _emitTypingDebouncer;

  ChatCubit(this._chatRepository, {required this.receiverId})
      : super(ChatInitial()) {
    _init();
  }

  Future<void> _init() async {
    final user = await TokenStorage().getUser();
    currentUserId = user?['_id']?.toString() ?? '';
    await loadMessages();
    
    // Emit mark as read when we open the chat
    SocketService().markAsRead(receiverId, currentUserId ?? '');

    // Listen to messages read (Blue ticks)
    _chatReadSub = SocketService().chatReadStream.listen((data) {
      if (isClosed) return;
      final readReceiverId = data['receiverId'];
      if (readReceiverId == receiverId) {
        _markAllSentAsReadLocally();
      }
    });

    // Listen to messages delivered (Double grey ticks)
    _chatDeliveredSub = SocketService().chatDeliveredStream.listen((data) {
      if (isClosed) return;
      final deliveredReceiverId = data['receiverId'];
      final messageId = data['messageId'];
      
      if (deliveredReceiverId == receiverId) {
        if (messageId != null) {
          final idx = _localMessages.indexWhere((m) => m.id == messageId);
          if (idx != -1 && _localMessages[idx].status == MessageStatus.sent) {
            _localMessages[idx] = _localMessages[idx].copyWith(status: MessageStatus.delivered);
            _emitLoaded();
          }
        } else {
           // Fallback: mark all sent as delivered
           bool changed = false;
           for (int i = 0; i < _localMessages.length; i++) {
             if (_localMessages[i].isMe && _localMessages[i].status == MessageStatus.sent) {
               _localMessages[i] = _localMessages[i].copyWith(status: MessageStatus.delivered);
               changed = true;
             }
           }
           if (changed) _emitLoaded();
        }
      }
    });
    
    // Listen to real-time chat messages from SocketService
    _chatMessageSub = SocketService().chatMessageStream.listen((data) {
      if (isClosed) return;
      
      // We expect the backend to send the formatted Message JSON
      // Unwrap if backend sends { "message": { ... } } or { "data": { ... } }
      final msgJson = (data['message'] ?? data['data'] ?? data) as Map<String, dynamic>;
      final message = MessageModel.fromJson(msgJson, currentUserId ?? '');
      
      // Filter out messages that don't belong to this conversation
      final msgReceiver = message.receiverId ?? currentUserId;
      final isRelevant = (message.senderId == receiverId && msgReceiver == currentUserId) || 
                         (message.senderId == currentUserId && (msgReceiver == receiverId || message.receiverId == null));
                         
      if (isRelevant) {
        // If it's an echo of our own message (or confirmation)
        if (message.senderId == currentUserId || data['isConfirmation'] == true) {
           final idx = _localMessages.indexWhere((m) => 
               (m.status == MessageStatus.pending || m.id == null) && 
               m.content == message.content && 
               m.type == message.type
           );
           
           if (idx != -1) {
             // Replace pending message with the real one from socket
             _localMessages[idx] = message.copyWith(status: MessageStatus.sent);
             _emitLoaded();
           } else {
             // If not found as pending (maybe HTTP already replaced it), just append securely
             _appendMessage(message);
           }
        } else {
           // Incoming message from the other person
           _appendMessage(message);
           
           // Since we are currently in the chat, we immediately read it
           SocketService().markAsRead(receiverId, currentUserId ?? '');
           
           // If they replied, they definitely saw our previous messages!
           _markAllSentAsReadLocally();
        }
      }
    });

    // Listen to typing events to update read receipts instantly
    _chatTypingSub = SocketService().chatTypingStream.listen((data) {
      if (isClosed) return;
      final typingSenderId = data['senderId'] ?? data['userId'] ?? data['receiverId'];
      // If the other person is typing
      if (typingSenderId == receiverId) {
        _markAllSentAsReadLocally();
        final isTypingAction = data['action'] == 'typing' || data['action'] == null; // default to typing
        
        _isTyping = isTypingAction;
        _emitLoaded();
        
        _typingIndicatorTimer?.cancel();
        if (_isTyping) {
          _typingIndicatorTimer = Timer(const Duration(seconds: 4), () {
            if (!isClosed) {
              _isTyping = false;
              _emitLoaded();
            }
          });
        }
      }
    });
  }

  void _markAllSentAsReadLocally() {
    bool statusChanged = false;
    for (int i = 0; i < _localMessages.length; i++) {
      if (_localMessages[i].isMe && _localMessages[i].status != MessageStatus.read) {
        _localMessages[i] = _localMessages[i].copyWith(status: MessageStatus.read);
        statusChanged = true;
      }
    }
    if (statusChanged) _emitLoaded();
  }

  void _appendMessage(MessageModel message) {
    // Check if it already exists to avoid duplicates
    final exists = _localMessages.any((m) => m.id == message.id && m.id != null);
    if (!exists) {
      _localMessages.add(message);
      // Re-sort DESCENDING (newest first for reversed ListView)
      _localMessages.sort((a, b) {
        final ta = DateTime.tryParse(a.timestamp ?? '') ?? DateTime(0);
        final tb = DateTime.tryParse(b.timestamp ?? '') ?? DateTime(0);
        return tb.compareTo(ta);
      });
      _emitLoaded();
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // Load messages from backend
  // ─────────────────────────────────────────────────────────────────
  Future<void> loadMessages({bool loadMore = false}) async {
    if (isClosed) return;
    if (_hasReachedMax && loadMore) return;
    
    if (state is ChatInitial && !loadMore) emit(ChatLoading());

    try {
      if (loadMore) _currentPage++;
      final messages =
          await _chatRepository.getMessages(receiverId, currentUserId ?? '', page: _currentPage, limit: 30);

      if (messages.isEmpty) {
        _hasReachedMax = true;
      }

      // Merge backend messages with local optimistic messages
      _mergeMessages(messages);
      _emitLoaded();
    } catch (e) {
      if (loadMore) _currentPage--; // revert page on fail
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

    // Sort by timestamp DESCENDING (newest first for reversed ListView)
    _localMessages.sort((a, b) {
      final ta = DateTime.tryParse(a.timestamp ?? '') ?? DateTime(0);
      final tb = DateTime.tryParse(b.timestamp ?? '') ?? DateTime(0);
      return tb.compareTo(ta);
    });
  }

  void _emitLoaded({bool isRecording = false}) {
    if (isClosed) return;
    emit(ChatLoaded(List.from(_localMessages), isRecording: isRecording, isTyping: _isTyping, hasReachedMax: _hasReachedMax, page: _currentPage));
  }

  // ─────────────────────────────────────────────────────────────────
  // Send Typing Indicator
  // ─────────────────────────────────────────────────────────────────
  void sendTyping() {
    if (_emitTypingDebouncer?.isActive ?? false) return;
    
    SocketService().emitTyping(receiverId);
    
    _emitTypingDebouncer = Timer(const Duration(seconds: 3), () {
      SocketService().emitStopTyping(receiverId);
    });
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

  // ─────────────────────────────────────────────────────────────────
  // Retry failed message
  // ─────────────────────────────────────────────────────────────────
  Future<void> retryMessage(MessageModel failedMsg) async {
    // 1. Remove the failed message
    final idx = _localMessages.indexWhere((m) => 
      m.status == MessageStatus.failed && 
      m.content == failedMsg.content && 
      m.timestamp == failedMsg.timestamp
    );
    
    if (idx != -1) {
      _localMessages.removeAt(idx);
    }
    
    // 2. Resend based on type
    if (failedMsg.type == MessageType.text) {
      await sendMessage(failedMsg.content, type: failedMsg.type);
    } else if (failedMsg.type == MessageType.audio) {
      await sendVoice(failedMsg.mediaUrl ?? '', failedMsg.durationMs);
    } else {
      await sendMedia(failedMsg.mediaUrl ?? '', failedMsg.type);
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

  // ─────────────────────────────────────────────────────────────────
  // Delete conversation
  // ─────────────────────────────────────────────────────────────────
  Future<void> deleteConversation() async {
    // Optimistic UI update
    final previousMessages = List<MessageModel>.from(_localMessages);
    _localMessages.clear();
    _emitLoaded();

    try {
      await _chatRepository.deleteConversation(receiverId);
    } catch (e) {
      if (isClosed) return;
      // Revert if failed
      _localMessages.addAll(previousMessages);
      _emitLoaded();
      emit(ChatError('Failed to delete conversation.'));
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // React to message
  // ─────────────────────────────────────────────────────────────────
  void reactToMessage(String messageId, String emoji) {
    final index = _localMessages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    _localMessages[index] = _localMessages[index].copyWith(reaction: emoji);
    _emitLoaded();
    
    // Note: Backend integration for reactions can be added here in the future
    // await _chatRepository.reactToMessage(messageId, emoji);
  }

  void setRecording(bool recording) {
    if (state is ChatLoaded) _emitLoaded(isRecording: recording);
  }

  @override
  Future<void> close() {
    _chatMessageSub?.cancel();
    _chatTypingSub?.cancel();
    _chatDeliveredSub?.cancel();
    _chatReadSub?.cancel();
    _typingIndicatorTimer?.cancel();
    _emitTypingDebouncer?.cancel();
    return super.close();
  }
}
