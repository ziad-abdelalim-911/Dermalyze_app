import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dermalyze/features/auth/view/chat/data/repositories/chat_repository.dart';
import 'package:dermalyze/features/auth/view/chat/model/conversation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ConversationsState {}

class ConversationsInitial extends ConversationsState {}

class ConversationsLoading extends ConversationsState {}

class ConversationsLoaded extends ConversationsState {
  final List<ConversationModel> conversations;
  ConversationsLoaded(this.conversations);
}

class ConversationsError extends ConversationsState {
  final String message;
  ConversationsError(this.message);
}

class ConversationsCubit extends Cubit<ConversationsState> {
  final ChatRepository _chatRepository;
  String? currentUserId;
  Timer? _pollingTimer;

  List<ConversationModel> _localConversations = [];

  ConversationsCubit(this._chatRepository) : super(ConversationsInitial()) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getString('user_id') ?? 'current_user_123';
    
    await loadConversations();
    _startPolling();
  }

  Future<void> loadConversations() async {
    if (state is ConversationsInitial) {
      emit(ConversationsLoading());
    }

    try {
      final conversations = await _chatRepository.getConversations(currentUserId!);
      if (conversations.isNotEmpty) {
        _localConversations = conversations;
      }
      emit(ConversationsLoaded(List.from(_localConversations)));
    } catch (e) {
      emit(ConversationsLoaded(List.from(_localConversations)));
    }
  }

  /// Clears the unread count locally when the user opens a chat
  void markAsRead(String conversationId) {
    bool updated = false;
    for (int i = 0; i < _localConversations.length; i++) {
      if (_localConversations[i].id == conversationId && _localConversations[i].unreadCount > 0) {
        _localConversations[i].unreadCount = 0;
        updated = true;
      }
    }
    
    if (updated) {
      emit(ConversationsLoaded(List.from(_localConversations)));
    }
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      loadConversations();
    });
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
