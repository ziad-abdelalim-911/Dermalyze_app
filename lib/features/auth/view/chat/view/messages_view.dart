import 'package:flutter/material.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/chat/view/chat_view.dart';
import 'package:dermalyze/core/network/api_service.dart';
import 'package:dermalyze/features/auth/view/chat/data/repositories/chat_repository.dart';
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
          /// ================= HEADER =================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient2,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    if (Navigator.canPop(context))
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
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
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// ================= BODY =================
          Expanded(
            child: BlocBuilder<ConversationsCubit, ConversationsState>(
              builder: (context, state) {
                if (state is ConversationsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ConversationsLoaded) {
                  return ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: state.conversations.length,
                    separatorBuilder: (context, index) => Divider(
                          height: 1,
                          indent: 80,
                          endIndent: 16,
                          color: Theme.of(context).dividerColor.withOpacity(0.1),
                        ),
                    itemBuilder: (context, index) {
                      final conv = state.conversations[index];
                      return _ChatItemTile(
                        conversation: conv,
                        onTap: () {
                          context.read<ConversationsCubit>().markAsRead(conv.id);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ChatView(
                                receiverId: conv.receiverId,
                                receiverName: conv.name,
                                receiverRole: conv.role,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is ConversationsError) {
                  return Center(
                      child: Text(state.message,
                          style: const TextStyle(color: Colors.red)));
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

/// ================= CHAT ITEM TILE (WhatsApp Style) =================
class _ChatItemTile extends StatelessWidget {
  final dynamic conversation; // Using dynamic for brevity in this replacement
  final VoidCallback onTap;

  const _ChatItemTile({required this.conversation, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.SkyBlue.withOpacity(0.1),
            child: Icon(Icons.person, color: AppColors.SkyBlue, size: 30),
          ),
          if (conversation.isOnline)
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFF25D366),
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            conversation.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            conversation.time,
            style: TextStyle(
              fontSize: 12,
              color: conversation.unreadCount > 0 
                  ? const Color(0xFF25D366) 
                  : Colors.grey,
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                conversation.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            if (conversation.unreadCount > 0)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF25D366),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  conversation.unreadCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
