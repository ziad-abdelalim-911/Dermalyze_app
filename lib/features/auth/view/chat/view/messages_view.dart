import 'package:flutter/material.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/chat/view/chat_view.dart';
import 'package:dermalyze/features/auth/view/chat/logic/conversations_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient2),
            child: Row(
              children: [
                if (Navigator.canPop(context))
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 20),
                    ),
                  ),
                const Expanded(
                  child: Text(
                    "Messages",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () =>
                      context.read<ConversationsCubit>().loadConversations(),
                ),
              ],
            ),
          ),

          // ── Body ──────────────────────────────────────────────────
          Expanded(
            child: BlocBuilder<ConversationsCubit, ConversationsState>(
              builder: (context, state) {
                if (state is ConversationsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ConversationsError) {
                  return _ErrorState(
                    message: state.message,
                    onRetry: () =>
                        context.read<ConversationsCubit>().loadConversations(),
                  );
                }

                if (state is ConversationsLoaded) {
                  if (state.conversations.isEmpty) {
                    return _EmptyState(
                      onRefresh: () =>
                          context.read<ConversationsCubit>().loadConversations(),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.SkyBlue,
                    onRefresh: () =>
                        context.read<ConversationsCubit>().loadConversations(),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: state.conversations.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        indent: 80,
                        endIndent: 16,
                        color: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: 0.1),
                      ),
                      itemBuilder: (context, index) {
                        final conv = state.conversations[index];
                        return _ChatItemTile(
                          conversation: conv,
                          onTap: () {
                            context
                                .read<ConversationsCubit>()
                                .markAsRead(conv.id);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ChatView(
                                  receiverId: conv.receiverId,
                                  receiverName: conv.name,
                                  receiverRole: conv.role,
                                ),
                              ),
                            );
                          },
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: const Text('Delete Conversation'),
                                  content: const Text(
                                      'Are you sure you want to delete this entire conversation? This action cannot be undone.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<ConversationsCubit>()
                                            .deleteConversation(conv.receiverId);
                                        Navigator.pop(ctx);
                                      },
                                      child: const Text('Delete',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────── Empty State ────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onRefresh;
  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.SkyBlue,
      onRefresh: () async => onRefresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.15),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.SkyBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.chat_bubble_outline,
                      size: 64, color: AppColors.SkyBlue),
                ),
                const SizedBox(height: 20),
                const Text(
                  'No conversations yet',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pull down to refresh',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.SkyBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────── Error State ────────────────────────────────

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

// ─────────────────────────────── Chat Item ──────────────────────────────────

class _ChatItemTile extends StatelessWidget {
  final dynamic conversation;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _ChatItemTile({
    required this.conversation,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDoctor = (conversation.role as String)
        .toLowerCase()
        .contains('dermat');

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // ── Avatar ──────────────────────────────────────────────
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: isDoctor
                      ? AppColors.SkyBlue.withValues(alpha: 0.15)
                      : Colors.teal.withValues(alpha: 0.15),
                  child: Icon(
                    isDoctor ? Icons.medical_services : Icons.person,
                    color: isDoctor ? AppColors.SkyBlue : Colors.teal,
                    size: 28,
                  ),
                ),
                if (conversation.isOnline as bool)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: const Color(0xFF25D366),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),

            // ── Content ─────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          conversation.name as String,
                          style: TextStyle(
                            fontWeight: (conversation.unreadCount as int) > 0
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: 15.5,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if ((conversation.time as String).isNotEmpty)
                        Text(
                          conversation.time as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: (conversation.unreadCount as int) > 0
                                ? const Color(0xFF25D366)
                                : Colors.grey,
                            fontWeight: (conversation.unreadCount as int) > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: (conversation.unreadCount as int) > 0
                                ? (isDark ? Colors.white70 : Colors.black87)
                                : Colors.grey,
                            fontWeight: (conversation.unreadCount as int) > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if ((conversation.unreadCount as int) > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          constraints: const BoxConstraints(minWidth: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: const BoxDecoration(
                            color: Color(0xFF25D366),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text(
                            (conversation.unreadCount as int) > 99
                                ? '99+'
                                : '${conversation.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if ((conversation.role as String).isNotEmpty)
                    Text(
                      conversation.role as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDoctor
                            ? AppColors.SkyBlue.withValues(alpha: 0.8)
                            : Colors.teal.withValues(alpha: 0.8),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
