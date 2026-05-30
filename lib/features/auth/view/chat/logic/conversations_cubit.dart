import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dermalyze/features/auth/view/chat/data/repositories/chat_repository.dart';
import 'package:dermalyze/features/auth/view/chat/model/conversation_model.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:dermalyze/core/services/socket_service.dart';

// ─────────────────────────────────── States ──────────────────────────────────

abstract class ConversationsState {}

class ConversationsInitial extends ConversationsState {}

class ConversationsLoading extends ConversationsState {}

class ConversationsLoaded extends ConversationsState {
  final List<ConversationModel> conversations;
  final int totalUnreadCount;

  ConversationsLoaded(this.conversations)
      : totalUnreadCount =
            conversations.fold(0, (sum, conv) => sum + conv.unreadCount);
}

class ConversationsError extends ConversationsState {
  final String message;
  ConversationsError(this.message);
}

// ─────────────────────────────────── Cubit ───────────────────────────────────

class ConversationsCubit extends Cubit<ConversationsState> {
  final ChatRepository _chatRepository;
  String? currentUserId;
  String? _userRole; // 'doctor' or 'patient'
  StreamSubscription? _socketSubscription;

  List<ConversationModel> _localConversations = [];

  ConversationsCubit(this._chatRepository) : super(ConversationsInitial()) {
    _init();
  }

  Future<void> _init() async {
    final user = await TokenStorage().getUser();
    currentUserId = user?['_id']?.toString() ?? '';
    _userRole = user?['role']?.toString().toLowerCase() ?? 'patient';

    await loadConversations();
    
    // Listen for real-time messages to refresh the conversation list dynamically
    _socketSubscription = SocketService().chatMessageStream.listen((data) {
      if (isClosed) return;
      try {
        final msgJson = (data['message'] ?? data['data'] ?? data) as Map<String, dynamic>;
        // Determine the conversation ID (the other user's ID)
        final senderId = msgJson['senderId'];
        final receiverId = msgJson['receiverId'];
        final content = msgJson['content'] ?? 'New message';
        
        // If we sent the message, the conversation is with the receiver
        // If we received it, the conversation is with the sender
        final conversationId = (senderId == currentUserId) ? receiverId : senderId;
        
        if (conversationId != null) {
          // Find conversation in local list
          final index = _localConversations.indexWhere((c) => c.receiverId == conversationId || c.id == conversationId);
          if (index != -1) {
            // Update last message
            var conv = _localConversations[index].copyWith(lastMessage: content, time: 'Just now');
            
            // If we are receiving the message (not an echo of our own), increment unread if not currently looking at it
            // (Note: ChatCubit marks it as read instantly if open, but here we just increment. 
            // In a perfectly robust system, we would check if ChatView for this user is active).
            if (senderId != currentUserId) {
               conv = conv.copyWith(unreadCount: conv.unreadCount + 1);
            }
            
            _localConversations[index] = conv;
            
            // Move to top
            _localConversations.removeAt(index);
            _localConversations.insert(0, conv);
            
            emit(ConversationsLoaded(List.from(_localConversations)));
          } else {
             // If conversation not found locally, we might need to load it from API
             loadConversations();
          }
        }
      } catch (_) {
         // Fallback
         loadConversations();
      }
    });
  }

  bool get isDoctor => _userRole == 'doctor';

  Future<void> loadConversations() async {
    if (state is ConversationsInitial) {
      emit(ConversationsLoading());
    }

    try {
      final conversations = isDoctor
          ? await _chatRepository.getDoctorPatients()
          : await _chatRepository.getConversations(currentUserId ?? '');

      if (conversations.isNotEmpty) {
        _localConversations = conversations;
      }
      emit(ConversationsLoaded(List.from(_localConversations)));
    } catch (e) {
      // Keep showing last known conversations on error
      emit(ConversationsLoaded(List.from(_localConversations)));
    }
  }

  /// Call this when user opens a conversation to clear its badge
  void markAsRead(String conversationId) {
    bool updated = false;
    for (int i = 0; i < _localConversations.length; i++) {
      if (_localConversations[i].id == conversationId &&
          _localConversations[i].unreadCount > 0) {
        _localConversations[i].unreadCount = 0;
        updated = true;
      }
    }
    if (updated) {
      emit(ConversationsLoaded(List.from(_localConversations)));
    }
  }

  /// Updates the last message preview in the list after sending
  void updateLastMessage(String conversationId, String content, String time) {
    for (int i = 0; i < _localConversations.length; i++) {
      if (_localConversations[i].id == conversationId) {
        _localConversations[i] = _localConversations[i]
            .copyWith(lastMessage: content, time: time);
      }
    }
    emit(ConversationsLoaded(List.from(_localConversations)));
  }

  void markConversationAsRead(String conversationId) {
    if (state is ConversationsLoaded) {
      final updated = (state as ConversationsLoaded).conversations.map((conv) {
        if (conv.receiverId == conversationId) {
          return conv.copyWith(unreadCount: 0);
        }
        return conv;
      }).toList();
      _localConversations = updated;
      emit(ConversationsLoaded(updated));
    }
  }

  Future<void> deleteConversation(String receiverId) async {
    // Optimistic delete
    final previousState = List<ConversationModel>.from(_localConversations);
    _localConversations.removeWhere((conv) => conv.receiverId == receiverId);
    emit(ConversationsLoaded(List.from(_localConversations)));

    try {
      await _chatRepository.deleteConversation(receiverId);
    } catch (e) {
      // Revert on failure
      _localConversations = previousState;
      emit(ConversationsLoaded(List.from(_localConversations)));
    }
  }

  @override
  Future<void> close() {
    _socketSubscription?.cancel();
    return super.close();
  }
}
