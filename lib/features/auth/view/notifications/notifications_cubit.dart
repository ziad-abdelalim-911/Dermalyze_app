import 'package:dermalyze/features/auth/view/notifications/notification_model.dart';
import 'package:dermalyze/features/auth/view/notifications/notifications_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;
  final int unreadCount;

  NotificationsLoaded(this.notifications)
    : unreadCount = notifications.where((n) => n.isUnread).length;
}

class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message);
}

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsCubit(this._repository) : super(NotificationsLoading());

  Future<void> fetchNotifications() async {
    emit(NotificationsLoading());
    try {
      final notifications = await _repository.getNotifications();
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(
        NotificationsError(
          'Failed to load notifications. Please check your connection.',
        ),
      );
    }
  }

  Future<void> markAllAsRead() async {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      try {
        await _repository.markAllAsRead();
        // Update local state optimistically
        final updatedList = currentState.notifications.map((n) {
          return NotificationModel(
            id: n.id,
            title: n.title,
            subtitle: n.subtitle,
            time: n.time,
            priority: n.priority,
            type: n.type,
            isUnread: false,
          );
        }).toList();

        emit(NotificationsLoaded(updatedList));
      } catch (e) {
        // Silently fail or handle error
      }
    }
  }

  Future<void> markAsRead(String id) async {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      try {
        await _repository.markAsRead(id);
        // Update local state optimistically
        final updatedList = currentState.notifications.map((n) {
          if (n.id == id) {
            return NotificationModel(
              id: n.id,
              title: n.title,
              subtitle: n.subtitle,
              time: n.time,
              priority: n.priority,
              type: n.type,
              isUnread: false,
            );
          }
          return n;
        }).toList();

        emit(NotificationsLoaded(updatedList));
      } catch (e) {
        // Silently fail or handle error
      }
    }
  }
}
