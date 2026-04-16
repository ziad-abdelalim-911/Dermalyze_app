import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/features/auth/view/notifications/notification_model.dart';
import 'package:dermalyze/features/auth/view/notifications/notifications_cubit.dart';
import 'package:dermalyze/features/auth/view/notifications/notifications_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit(NotificationsRepository())..fetchNotifications(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            /// ================= HEADER =================
            Container(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
              decoration: BoxDecoration(color: Theme.of(context).appBarTheme.backgroundColor),
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  int unread = 0;
                  if (state is NotificationsLoaded) unread = state.unreadCount;
                  
                  return Row(
                    children: [
                      /// back button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ),
                      const SizedBox(width: 12),
                      /// title + unread
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Notifications",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "$unread unread",
                              style: const TextStyle(
                                color: Color(0xFF10B981),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      /// mark all read
                      if (unread > 0)
                        GestureDetector(
                          onTap: () => context.read<NotificationsCubit>().markAllAsRead(),
                          child: Row(
                            children: const [
                              Icon(Icons.check, color: Color(0xFF10B981), size: 18),
                              SizedBox(width: 6),
                              Text(
                                "Mark all as read",
                                style: TextStyle(
                                  color: Color(0xFF10B981),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),

            /// ================= BODY =================
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (state is NotificationsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_off, size: 60, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(state.message, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<NotificationsCubit>().fetchNotifications(),
                            child: const Text('Retry'),
                          )
                        ],
                      ),
                    );
                  }
                  
                  if (state is NotificationsLoaded) {
                    final notifications = state.notifications;
                    if (notifications.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.notifications_none, size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            const Text("No notifications yet", style: TextStyle(color: Colors.grey, fontSize: 16)),
                          ],
                        ),
                      );
                    }

                    final newNotifications = notifications.where((n) => n.isUnread).toList();
                    final earlierNotifications = notifications.where((n) => !n.isUnread).toList();

                    return ListView(
                      padding: const EdgeInsets.only(top: 16, bottom: 30),
                      children: [
                        if (newNotifications.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text("New", style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
                          ),
                          const SizedBox(height: 8),
                          ...newNotifications.map((n) => _buildNotificationCard(context, n)),
                          const SizedBox(height: 16),
                        ],

                        if (earlierNotifications.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text("Earlier", style: TextStyle(fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onSurface)),
                          ),
                          const SizedBox(height: 8),
                          ...earlierNotifications.map((n) => _buildNotificationCard(context, n)),
                          const SizedBox(height: 16),
                        ],
                      ],
                    );
                  }
                  
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationModel notif) {
    String iconPath;
    Color iconColor;

    switch (notif.type.toLowerCase()) {
      case 'medication':
        iconPath = AppAssets.medication_icon;
        iconColor = Colors.teal;
        break;
      case 'analysis':
        iconPath = AppAssets.analysis_icon;
        iconColor = Colors.purple;
        break;
      case 'appointment':
        iconPath = AppAssets.time_icon;
        iconColor = Colors.orange;
        break;
      case 'chat':
      case 'message':
        iconPath = AppAssets.chat_icon;
        iconColor = Colors.blue;
        break;
      default:
        iconPath = AppAssets.i_icon;
        iconColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: notif.isUnread ? const Color(0xFF2DD4BF) : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: ImageIcon(
                AssetImage(iconPath),
                color: iconColor,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notif.title,
                        style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ),
                    _priorityBadge(notif.priority),
                  ],
                ),
                const SizedBox(height: 4),
                Text(notif.subtitle, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(notif.time, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    if (notif.isUnread)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priorityBadge(String priority) {
    Color bg;
    Color text;

    switch (priority) {
      case "High":
        bg = const Color(0xFFFEE2E2);
        text = Colors.red;
        break;
      case "Medium":
        bg = const Color(0xFFFEF3C7);
        text = Colors.orange;
        break;
      default:
        bg = const Color(0xFFE5E7EB);
        text = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(priority, style: TextStyle(color: text, fontSize: 12)),
    );
  }
}

