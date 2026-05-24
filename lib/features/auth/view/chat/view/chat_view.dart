import 'dart:io';
import 'package:flutter/services.dart';
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
  // Track the last message count to avoid jumping when polling adds 0 messages
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) setState(() => _showEmoji = false);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<ConversationsCubit>()
          .markConversationAsRead(widget.receiverId);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void scrollToBottom({bool animated = true}) {
    Future.delayed(const Duration(milliseconds: 80), () {
      if (_scrollController.hasClients) {
        if (animated) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent);
        }
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
          if (_showEmoji) setState(() => _showEmoji = false);
        },
        child: Scaffold(
          backgroundColor:
              isDark ? WhatsAppStyles.darkChatBg : WhatsAppStyles.lightChatBg,
          body: Column(
            children: [
              // ── App Bar ───────────────────────────────────────────
              ChatAppBar(
                name: widget.receiverName,
                role: widget.receiverRole,
                receiverId: widget.receiverId,
              ),

              // ── Messages ──────────────────────────────────────────
              Expanded(
                child: BlocConsumer<ChatCubit, ChatState>(
                  listenWhen: (prev, curr) => curr is ChatLoaded,
                  listener: (context, state) {
                    if (state is ChatLoaded) {
                      final msgs = state.messages;
                      if (msgs.length != _lastMessageCount) {
                        _lastMessageCount = msgs.length;
                        scrollToBottom(animated: msgs.length > 1);
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ChatError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.wifi_off,
                                size: 48, color: Colors.grey),
                            const SizedBox(height: 12),
                            Text(state.message,
                                style:
                                    const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<ChatCubit>().loadMessages(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is ChatLoaded) {
                      final messages = state.messages;

                      if (messages.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.chat_bubble_outline,
                                  size: 64,
                                  color: Colors.grey.withValues(alpha: 0.4)),
                              const SizedBox(height: 16),
                              Text(
                                'Say hi to ${widget.receiverName}! 👋',
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 20),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final showDate = index == 0 ||
                              !_isSameDay(
                                messages[index - 1].timestamp,
                                msg.timestamp,
                              );
                          return Column(
                            children: [
                              if (showDate) _DateSeparator(timestamp: msg.timestamp),
                              MessageBubble(message: msg),
                            ],
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),

              // ── Input Bar ─────────────────────────────────────────
              MessageInputBar(
                controller: _controller,
                focusNode: _focusNode,
                showEmoji: _showEmoji,
                receiverId: widget.receiverId,
                onEmojiToggle: () {
                  if (_showEmoji) {
                    _focusNode.requestFocus();
                  } else {
                    _focusNode.unfocus();
                  }
                  setState(() => _showEmoji = !_showEmoji);
                },
                onMessageSent: (content) {
                  // Update conversation preview in messages list
                  context.read<ConversationsCubit>().updateLastMessage(
                    widget.receiverId,
                    content,
                    'Just now',
                  );
                },
              ),

              if (_showEmoji)
                SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      setState(() => _controller.text += emoji.emoji);
                    },
                    config: const Config(height: 250, checkPlatformCompatibility: true),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isSameDay(String? ts1, String? ts2) {
    if (ts1 == null || ts2 == null) return false;
    try {
      final d1 = DateTime.parse(ts1).toLocal();
      final d2 = DateTime.parse(ts2).toLocal();
      return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
    } catch (_) {
      return false;
    }
  }
}

// ─────────────────────────────── Date Separator ──────────────────────────────

class _DateSeparator extends StatelessWidget {
  final String? timestamp;
  const _DateSeparator({this.timestamp});

  @override
  Widget build(BuildContext context) {
    final label = _formatDate(timestamp);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white12
                    : Colors.black.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                label,
                style:
                    const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  String _formatDate(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final msgDay = DateTime(dt.year, dt.month, dt.day);
      final diff = today.difference(msgDay).inDays;
      if (diff == 0) return 'Today';
      if (diff == 1) return 'Yesterday';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }
}

// ─────────────────────────────── App Bar ────────────────────────────────────

class ChatAppBar extends StatelessWidget {
  final String name;
  final String role;
  final String receiverId;

  const ChatAppBar({
    super.key,
    required this.name,
    required this.role,
    required this.receiverId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
      decoration: BoxDecoration(gradient: AppColors.primaryGradient2),
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
                      fontWeight: FontWeight.bold),
                ),
                if (role.isNotEmpty)
                  Text(role,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'delete') {
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
                                .deleteConversation(receiverId);
                            Navigator.pop(ctx); // Close dialog
                            Navigator.pop(context); // Exit chat screen
                          },
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Chat', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────── Message Bubble ──────────────────────────────

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final sentColor = WhatsAppStyles.getAppSentBubbleColor(context);
    final receivedColor = WhatsAppStyles.getAppReceivedBubbleColor(context);
    final color = isMe ? sentColor : receivedColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => _showMessageOptions(context, message),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Stack(
          children: [
            CustomPaint(
              size: const Size(15, 15),
              painter: BubblePainter(color: color, isMe: isMe),
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
                color: color,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft:
                      isMe ? const Radius.circular(16) : Radius.zero,
                  topRight:
                      isMe ? Radius.zero : const Radius.circular(16),
                  bottomLeft: const Radius.circular(16),
                  bottomRight: const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildContent(context),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(
                            fontSize: 10,
                            color:
                                isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                        if (isMe) ...[
                          const SizedBox(width: 4),
                          _buildStatus(message.status),
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
      ),
    );
  }

  void _showMessageOptions(BuildContext context, MessageModel message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(sheetCtx).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message.type == MessageType.text)
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy Text'),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  Clipboard.setData(ClipboardData(text: message.content));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Text copied to clipboard')),
                  );
                },
              ),
            if (message.isMe && message.id != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Message', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  context.read<ChatCubit>().deleteMessage(message.id!);
                },
              ),
            if (!message.isMe || message.type != MessageType.text)
              if (!(message.isMe && message.id != null))
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No actions available for this message', style: TextStyle(color: Colors.grey)),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (message.type) {
      case MessageType.image:
        return _buildImage();
      case MessageType.audio:
        return VoiceMessagePlayer(
          audioPath: message.mediaUrl ?? '',
          isMe: message.isMe,
          durationMs: message.durationMs,
        );
      case MessageType.file:
        return _buildFile();
      default:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            message.content,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black87,
            ),
          ),
        );
    }
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: message.mediaUrl != null &&
              (message.mediaUrl!.startsWith('/') ||
                  message.mediaUrl!.startsWith('file://'))
          ? Image.file(File(message.mediaUrl!),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _imagePlaceholder())
          : message.mediaUrl != null && message.mediaUrl!.startsWith('http')
              ? Image.network(message.mediaUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imagePlaceholder())
              : _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 200,
      width: 250,
      color: Colors.grey[200],
      child: const Icon(Icons.image, size: 50, color: Colors.grey),
    );
  }

  Widget _buildFile() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.insert_drive_file, color: Colors.grey),
          SizedBox(width: 8),
          Expanded(
              child: Text('Document', overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildStatus(MessageStatus status) {
    switch (status) {
      case MessageStatus.pending:
        return const Icon(Icons.access_time, size: 12, color: Colors.grey);
      case MessageStatus.sent:
        return const Icon(Icons.done, size: 14, color: Colors.grey);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 14, color: Colors.grey);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 14, color: Colors.blue);
      case MessageStatus.failed:
        return const Icon(Icons.error_outline, size: 14, color: Colors.red);
    }
  }

  String _formatTime(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}

// ─────────────────────────────── Bubble Painter ──────────────────────────────

class BubblePainter extends CustomPainter {
  final Color color;
  final bool isMe;
  BubblePainter({required this.color, required this.isMe});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    if (isMe) {
      path
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height);
    } else {
      path
        ..moveTo(size.width, 0)
        ..lineTo(0, 0)
        ..lineTo(0, size.height);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BubblePainter old) =>
      old.color != color || old.isMe != isMe;
}

// ─────────────────────────────── Input Bar ───────────────────────────────────

class MessageInputBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool showEmoji;
  final String receiverId;
  final VoidCallback onEmojiToggle;
  final void Function(String content)? onMessageSent;

  const MessageInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.showEmoji,
    required this.receiverId,
    required this.onEmojiToggle,
    this.onMessageSent,
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

  void _showAttachmentMenu(BuildContext parentContext) {
    final chatCubit = parentContext.read<ChatCubit>();
    showModalBottomSheet(
      context: parentContext,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(sheetCtx).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _attachItem(Icons.insert_drive_file, 'Document', Colors.indigo,
                () async {
              Navigator.pop(sheetCtx);
              final result = await FilePicker.pickFiles();
              if (result != null &&
                  result.files.single.path != null &&
                  mounted) {
                chatCubit.sendMedia(
                    result.files.single.path!, MessageType.file);
              }
            }),
            _attachItem(Icons.camera_alt, 'Camera', Colors.pink, () async {
              Navigator.pop(sheetCtx);
              final img = await ImagePicker().pickImage(
                source: ImageSource.camera,
                imageQuality: 40,
              );
              if (img != null && mounted) {
                chatCubit.sendMedia(img.path, MessageType.image);
              }
            }),
            _attachItem(Icons.image, 'Gallery', Colors.purple, () async {
              Navigator.pop(sheetCtx);
              final img = await ImagePicker().pickImage(
                source: ImageSource.gallery,
                imageQuality: 40,
              );
              if (img != null && mounted) {
                chatCubit.sendMedia(img.path, MessageType.image);
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _attachItem(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
              radius: 25,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white)),
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
              // ── Text field ────────────────────────────────────────
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          widget.showEmoji
                              ? Icons.keyboard
                              : Icons.emoji_emotions_outlined,
                          color: Colors.grey[600],
                        ),
                        onPressed: widget.onEmojiToggle,
                      ),
                      Expanded(
                        child: TextField(
                          controller: widget.controller,
                          focusNode: widget.focusNode,
                          maxLines: null,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            hintText: 'Message',
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
                            final img = await ImagePicker().pickImage(
                              source: ImageSource.camera,
                              imageQuality: 40,
                            );
                            if (img != null && context.mounted) {
                              context
                                  .read<ChatCubit>()
                                  .sendMedia(img.path, MessageType.image);
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // ── Send button ───────────────────────────────────────
              AnimatedOpacity(
                opacity: _isTextEmpty ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: GestureDetector(
                  onTap: _isTextEmpty
                      ? null
                      : () {
                          final text = widget.controller.text;
                          context.read<ChatCubit>().sendMessage(text);
                          widget.onMessageSent?.call(text);
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

          // ── Voice recorder ────────────────────────────────────────
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
                  widget.onMessageSent?.call('🎤 Voice message');
                },
              ),
            ),
        ],
      ),
    );
  }
}
