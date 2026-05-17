import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dermalyze/features/auth/view/chat/data/repositories/chat_repository.dart';
import 'package:dermalyze/features/auth/view/chat/model/conversation_model.dart';
import 'package:dermalyze/core/storage/token_storage.dart';

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
  Timer? _pollingTimer;

  List<ConversationModel> _localConversations = [];

  ConversationsCubit(this._chatRepository) : super(ConversationsInitial()) {
    _init();
  }

  Future<void> _init() async {
    final user = await TokenStorage().getUser();
    currentUserId = user?['_id']?.toString() ?? '';
    _userRole = user?['role']?.toString().toLowerCase() ?? 'patient';

    await loadConversations();
    _startPolling();
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

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      loadConversations();
    });
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
