import 'dart:io';
import 'package:dermalyze/features/auth/view/chat/model/message_type.dart';
import 'package:dermalyze/features/auth/view/chat/widgets/voice_message_player.dart';
import 'package:dermalyze/features/auth/view/chat/widgets/voice_recorder_button.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/chat/view/whatsapp_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dermalyze/core/network/api_service.dart';
import 'package:dermalyze/features/auth/view/chat/model/message_model.dart';
import 'package:dermalyze/features/auth/view/chat/logic/chat_cubit.dart';
import 'package:dermalyze/features/auth/view/chat/logic/conversations_cubit.dart';
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
  bool _showEmoji = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() => _showEmoji = false);
      }
    });

    // Mark as read immediately when entering the chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConversationsCubit>().markConversationAsRead(widget.receiverId);
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => ChatCubit(
        ChatRepository(ApiService()),
        receiverId: widget.receiverId,
      ),
      child: PopScope(
        canPop: !_showEmoji,
        onPopInvokedWithResult: (didPop, result) {
          if (_showEmoji) {
            setState(() => _showEmoji = false);
          }
        },
        child: Scaffold(
          backgroundColor: isDark ? WhatsAppStyles.darkChatBg : WhatsAppStyles.lightChatBg,
          body: Column(
            children: [
              ChatAppBar(
                name: widget.receiverName,
                role: widget.receiverRole,
              ),
              Expanded(
                child: BlocConsumer<ChatCubit, ChatState>(
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
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
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
                ),
              ),
              MessageInputBar(
                controller: _controller,
                focusNode: _focusNode,
                showEmoji: _showEmoji,
                onEmojiToggle: () {
                  if (_showEmoji) {
                    _focusNode.requestFocus();
                  } else {
                    _focusNode.unfocus();
                  }
                  setState(() => _showEmoji = !_showEmoji);
                },
              ),
              if (_showEmoji)
                SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      setState(() {
                        _controller.text += emoji.emoji;
                      });
                    },
                    config: Config(
                      height: 250,
                      checkPlatformCompatibility: true,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatAppBar extends StatelessWidget {
  final String name;
  final String role;

  const ChatAppBar({super.key, required this.name, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient2,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  role,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.videocam, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final color = WhatsAppStyles.getAppSentBubbleColor(context);
    final receivedColor = WhatsAppStyles.getAppReceivedBubbleColor(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Stack(
          children: [
            CustomPaint(
              size: const Size(15, 15),
              painter: BubblePainter(
                color: isMe ? color : receivedColor,
                isMe: isMe,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: isMe ? 20 : 10,
                right: isMe ? 10 : 20,
              ),
              padding: const EdgeInsets.all(4),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: isMe ? color : receivedColor,
                borderRadius: BorderRadius.only(
                  topLeft: isMe ? const Radius.circular(12) : Radius.zero,
                  topRight: isMe ? Radius.zero : const Radius.circular(12),
                  bottomLeft: const Radius.circular(12),
                  bottomRight: const Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildMessageContent(context),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          _buildStatusIcon(message.status),
                        ],
                      ],
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

  Widget _buildMessageContent(BuildContext context) {
    switch (message.type) {
      case MessageType.image:
        return _buildImageContent();
      case MessageType.audio:
        return _buildAudioContent(context);
      case MessageType.file:
        return _buildFileContent();
      default:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            message.content,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
            ),
          ),
        );
    }
  }

  Widget _buildImageContent() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: message.mediaUrl != null && message.mediaUrl!.startsWith('/')
          ? Image.file(File(message.mediaUrl!), fit: BoxFit.cover)
          : Container(
              height: 200,
              width: 250,
              color: Colors.grey[200],
              child: const Icon(Icons.image, size: 50, color: Colors.grey),
            ),
    );
  }

  Widget _buildAudioContent(BuildContext context) {
    return VoiceMessagePlayer(
      audioPath: message.mediaUrl ?? '',
      isMe: message.isMe,
      durationMs: message.durationMs,
    );
  }

  Widget _buildFileContent() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.insert_drive_file, color: Colors.grey),
          const SizedBox(width: 8),
          const Expanded(child: Text("Document.pdf", overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.pending:
        return const Icon(Icons.access_time, size: 12, color: Colors.grey);
      case MessageStatus.sent:
        return const Icon(Icons.done, size: 14, color: Colors.grey);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 14, color: Colors.grey);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 14, color: Colors.blue);
    }
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

class MessageInputBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool showEmoji;
  final VoidCallback onEmojiToggle;

  const MessageInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.showEmoji,
    required this.onEmojiToggle,
  });

  @override
  State<MessageInputBar> createState() => _MessageInputBarState();
}

class _MessageInputBarState extends State<MessageInputBar> {
  bool _isTextEmpty = true;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() => _isTextEmpty = widget.controller.text.trim().isEmpty);
    });
  }

  void _showAttachmentMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildActionItem(Icons.insert_drive_file, "Document", Colors.indigo, () async {
              Navigator.pop(context);
              await FilePicker.pickFiles();
            }),
            _buildActionItem(Icons.camera_alt, "Camera", Colors.pink, () async {
              Navigator.pop(context);
              final image = await ImagePicker().pickImage(source: ImageSource.camera);
              if (image != null && mounted) {
                context.read<ChatCubit>().sendMedia(image.path, MessageType.image);
              }
            }),
            _buildActionItem(Icons.image, "Gallery", Colors.purple, () async {
              Navigator.pop(context);
              final image = await ImagePicker().pickImage(source: ImageSource.gallery);
              if (image != null && mounted) {
                context.read<ChatCubit>().sendMedia(image.path, MessageType.image);
              }
            }),
            _buildActionItem(Icons.headset, "Audio", Colors.orange, () {}),
            _buildActionItem(Icons.location_on, "Location", Colors.green, () {}),
            _buildActionItem(Icons.person, "Contact", Colors.blue, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomRight,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          widget.showEmoji ? Icons.keyboard : Icons.emoji_emotions_outlined,
                          color: Colors.grey[600],
                        ),
                        onPressed: widget.onEmojiToggle,
                      ),
                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          focusNode: widget.focusNode,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: "Message",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.attach_file, color: Colors.grey[600]),
                        onPressed: () => _showAttachmentMenu(context),
                      ),
                      if (_isTextEmpty)
                        IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.grey[600]),
                          onPressed: () async {
                            final image = await ImagePicker().pickImage(source: ImageSource.camera);
                            if (image != null && context.mounted) {
                              context.read<ChatCubit>().sendMedia(image.path, MessageType.image);
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              
              Opacity(
                opacity: _isTextEmpty ? 0.0 : 1.0,
                child: GestureDetector(
                  onTap: _isTextEmpty ? null : () {
                    context.read<ChatCubit>().sendMessage(widget.controller.text);
                    widget.controller.clear();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A90E2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          
          if (_isTextEmpty)
            Positioned(
              right: 0,
              bottom: 0,
              left: _isRecording ? 0 : null,
              child: VoiceRecorderButton(
                onSend: () {},
                onCancel: () => setState(() => _isRecording = false),
                onRecordingStart: () => setState(() => _isRecording = true),
                onRecordingComplete: (path, durationMs) {
                  setState(() => _isRecording = false);
                  context.read<ChatCubit>().sendVoice(path, durationMs);
                },
              ),
            ),
        ],
      ),
    );
  }
}
