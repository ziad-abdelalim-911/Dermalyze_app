import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dermalyze/core/network/api_service.dart';
import 'package:dermalyze/features/auth/view/chat/model/message_model.dart';
import 'package:dermalyze/features/auth/view/chat/logic/chat_cubit.dart';
import 'package:dermalyze/features/auth/view/chat/data/repositories/chat_repository.dart';



class ChatView extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final String receiverRole;

  const ChatView({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverRole,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  /// ================= AUTO SCROLL =================
  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// ================= SEND MESSAGE =================
  void sendMessage(BuildContext context) {
    if (_controller.text.trim().isEmpty) return;
    context.read<ChatCubit>().sendMessage(_controller.text);
    _controller.clear();
    scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(
        ChatRepository(ApiService()),
        receiverId: widget.receiverId,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            ChatAppBar(
              name: widget.receiverName,
              role: widget.receiverRole,
            ),
            /// LIST
            Expanded(
              child: Builder(
                builder: (context) {
                  return BlocConsumer<ChatCubit, ChatState>(
                    listener: (context, state) {
                      if (state is ChatLoaded) {
                        scrollToBottom();
                      }
                    },
                    builder: (context, state) {
                      if (state is ChatLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ChatLoaded) {
                        final messages = state.messages;
                        if (messages.isEmpty) {
                          return const Center(child: Text("No messages yet."));
                        }
                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return MessageBubble(message: messages[index]);
                          },
                        );
                      } else if (state is ChatError) {
                        return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                      }
                      return const SizedBox.shrink();
                    },
                  );
                }
              ),
            ),
            Builder(
              builder: (context) {
                return MessageInputBar(
                  controller: _controller,
                  onSend: () => sendMessage(context),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}


/// ================= APP BAR =================
class ChatAppBar extends StatelessWidget {
  final String name;
  final String role;

  const ChatAppBar({super.key, required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 30),

      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient2,
        // borderRadius: const BorderRadius.only(
        //   bottomLeft: Radius.circular(28),
        //   bottomRight: Radius.circular(28),
        // ),
      ),

      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),

          const SizedBox(width: 12),

          const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Text(
                  role,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              Icon(Icons.circle, size: 10, color: Colors.greenAccent),

              SizedBox(width: 6),

              Text(
                "Online",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ================= MESSAGE BUBBLE =================
class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,

      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,

        children: [
          /// NAME + AVATAR
          if (!isMe)
            Row(
              children: [
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Color(0xFF4FB6C2),
                  child: Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 6),

                Text(
                  isMe ? "You" : "Dr.",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 6),

          /// BUBBLE
          Container(
            padding: const EdgeInsets.all(14),

            constraints: const BoxConstraints(maxWidth: 260),

            decoration: BoxDecoration(
              gradient: isMe ? AppColors.primaryGradient2 : null,

              color: isMe ? null : Theme.of(context).cardColor,

              borderRadius: BorderRadius.circular(16),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 5,
                ),
              ],
            ),

            child: Text(
              message.content,
              style: TextStyle(
                color: isMe ? Colors.white : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            _formatTime(message.timestamp),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
  String _formatTime(String? timestamp) {
    if (timestamp == null) return "";
    try {
      final date = DateTime.parse(timestamp);
      return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return "";
    }
  }
}

/// ================= INPUT =================
class MessageInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const MessageInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),

      color: Theme.of(context).scaffoldBackgroundColor,

      child: Row(
        children: [
          const Icon(Icons.attach_file, color: Colors.grey),

          const SizedBox(width: 10),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),

              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
              ),

              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          GestureDetector(
            onTap: onSend,

            child: Container(
              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient2,
                shape: BoxShape.circle,
              ),

              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
