import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// ================= MODEL =================
class ChatMessage {
  final String senderName;
  final String message;
  final String time;
  final bool isMe;

  ChatMessage({
    required this.senderName,
    required this.message,
    required this.time,
    required this.isMe,
  });
}

/// ================= CHAT VIEW =================
class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final List<ChatMessage> messages = [
    ChatMessage(
      senderName: "Dr. Ahmed Hassan",
      message: "Hello! How are you feeling today?",
      time: "09:15 AM",
      isMe: false,
    ),

    ChatMessage(
      senderName: "You",
      message: "Good morning Dr. Ahmed. I'm feeling much better!",
      time: "09:18 AM",
      isMe: true,
    ),

    ChatMessage(
      senderName: "Dr. Ahmed Hassan",
      message:
          "That's great to hear! Are you still experiencing any itching or redness?",
      time: "09:20 AM",
      isMe: false,
    ),
  ];

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
  void sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      senderName: "You",
      message: _controller.text.trim(),
      time: TimeOfDay.now().format(context),
      isMe: true,
    );

    setState(() {
      messages.add(newMessage);
    });

    _controller.clear();

    scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: Column(
        children: [
          const ChatAppBar(),

          /// LIST
          Expanded(
            child: ListView.builder(
              controller: _scrollController,

              padding: const EdgeInsets.all(16),

              itemCount: messages.length,

              itemBuilder: (context, index) {
                return MessageBubble(message: messages[index]);
              },
            ),
          ),

          MessageInputBar(
            controller: _controller,
            onSend: sendMessage,
          ),
        ],
      ),
    );
  }
}

/// ================= APP BAR =================
class ChatAppBar extends StatelessWidget {
  const ChatAppBar({super.key});

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

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dr. Ahmed Hassan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                Text(
                  "Dermatologist",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: const [
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
  final ChatMessage message;

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
                  message.senderName,
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

              color: isMe ? null : Colors.white,

              borderRadius: BorderRadius.circular(16),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 5,
                ),
              ],
            ),

            child: Text(
              message.message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            message.time,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
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

      color: Colors.white,

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
