// import 'package:flutter/material.dart';
//
// class MessagesView extends StatelessWidget {
//   const MessagesView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(appBar: AppBar());
//   }
// }

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
    return BlocProvider(
      create: (context) => ConversationsCubit(ChatRepository(ApiService())),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),
        body: Column(
          children: [
            /// ================= HEADER =================
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient2,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  /// ===== TOP ROW =====
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(right: 12, top: 4, bottom: 4),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Messages",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            BlocBuilder<ConversationsCubit, ConversationsState>(
                              builder: (context, state) {
                                int unreadTotal = 0;
                                if (state is ConversationsLoaded) {
                                  unreadTotal = state.conversations.fold(0, (sum, item) => sum + item.unreadCount);
                                }
                                return Text(
                                  "Chat with your doctors • $unreadTotal unread",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  /// ===== SEARCH FIELD =====
                  SizedBox(
                    height: 48,
                    child: TextField(
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search doctors...",
                        hintStyle: const TextStyle(
                          color: Colors.white70,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
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
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 16),
                      itemCount: state.conversations.length,
                      itemBuilder: (context, index) {
                        final conv = state.conversations[index];
                        return InkWell(
                          onTap: () {
                            // Mark as read locally
                            context.read<ConversationsCubit>().markAsRead(conv.id);
                            
                            // Navigate to chat
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
                          child: _ChatItem(
                            name: conv.name,
                            message: conv.lastMessage,
                            time: conv.time,
                            isOnline: conv.isOnline,
                            unreadCount: conv.unreadCount,
                          ),
                        );
                      },
                    );
                  } else if (state is ConversationsError) {
                    return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= CHAT ITEM =================
class _ChatItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final bool isOnline;
  final int unreadCount;

  const _ChatItem({
    required this.name,
    required this.message,
    required this.time,
    this.isOnline = false,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              /// ===== AVATAR =====
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.SkyBlue,
                child: const Text(
                  "AH",
                  style: TextStyle(color: Colors.white),
                ),
              ),

              /// ===== ONLINE DOT =====
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          Column(
            children: [
              /// ===== TIME =====
              Text(
                time,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 6),

              /// ===== UNREAD COUNT =====
              if (unreadCount > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
