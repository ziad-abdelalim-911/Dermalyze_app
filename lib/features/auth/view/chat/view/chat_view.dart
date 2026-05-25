import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:dermalyze/features/auth/view/chat/model/message_type.dart';
import 'package:dermalyze/features/auth/view/chat/widgets/voice_message_player.dart';
import 'package:dermalyze/features/auth/view/chat/widgets/voice_recorder_button.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dermalyze/features/auth/view/chat/view/whatsapp_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dermalyze/core/network/api_service.dart';
import 'package:dermalyze/features/auth/view/chat/model/message_model.dart';
import 'package:dermalyze/features/auth/view/chat/logic/chat_cubit.dart';
import 'package:dermalyze/features/auth/view/chat/logic/conversations_cubit.dart';
import 'package:dermalyze/features/auth/view/chat/data/repositories/chat_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  ChatView
// ─────────────────────────────────────────────────────────────────────────────
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
  int _lastMessageCount = 0;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _showEmoji) {
        setState(() => _showEmoji = false);
      }
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

  void _scrollToBottom({bool animated = true}) {
    Future.delayed(const Duration(milliseconds: 80), () {
      if (!mounted || !_scrollController.hasClients) return;
      if (animated) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chatBg = WhatsAppStyles.getChatBg(context);

    return BlocProvider(
      create: (_) => ChatCubit(
        ChatRepository(ApiService()),
        receiverId: widget.receiverId,
      ),
      child: PopScope(
        canPop: !_showEmoji,
        onPopInvokedWithResult: (didPop, _) {
          if (_showEmoji) setState(() => _showEmoji = false);
        },
        child: Scaffold(
          backgroundColor: chatBg,
          body: Stack(
            children: [
              // ── Messages ────────────────────────────────────────────
              Positioned.fill(
                child: BlocConsumer<ChatCubit, ChatState>(
                  listenWhen: (p, c) => c is ChatLoaded,
                  listener: (_, state) {
                    if (state is ChatLoaded) {
                      if (state.messages.length != _lastMessageCount) {
                        _lastMessageCount = state.messages.length;
                        _scrollToBottom(animated: state.messages.length > 1);
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: const Color(0xFF2AABEE),
                        ),
                      );
                    }

                    if (state is ChatError) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.wifi_off, size: 48,
                                color: isDark ? Colors.white38 : Colors.grey),
                            const SizedBox(height: 12),
                            Text(state.message,
                                style: TextStyle(
                                    color: isDark ? Colors.white54 : Colors.grey)),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2AABEE)),
                              onPressed: () =>
                                  context.read<ChatCubit>().loadMessages(),
                              child: const Text('Retry',
                                  style: TextStyle(color: Colors.white)),
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
                                  color: isDark
                                      ? Colors.white24
                                      : Colors.grey.withOpacity(0.4)),
                              const SizedBox(height: 16),
                              Text(
                                'Say hi to ${widget.receiverName}! 👋',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: isDark
                                        ? Colors.white38
                                        : Colors.grey[500]),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        // bottom padding = floating bar (~68) + margin (16) + gap (24)
                        padding: const EdgeInsets.only(
                            top: 110, bottom: 120, left: 12, right: 12),
                        itemCount: messages.length,
                        itemBuilder: (ctx, i) {
                          final msg = messages[i];
                          final showDate = i == 0 ||
                              !_isSameDay(messages[i - 1].timestamp,
                                  msg.timestamp);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (showDate)
                                _DateSeparator(timestamp: msg.timestamp),
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

              // ── AppBar ──────────────────────────────────────────────
              Positioned(
                top: 0, left: 0, right: 0,
                child: ChatAppBar(
                  name: widget.receiverName,
                  role: widget.receiverRole,
                  receiverId: widget.receiverId,
                ),
              ),

              // ── Emoji picker ────────────────────────────────────────
              if (_showEmoji)
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 280,
                    color: isDark
                        ? const Color(0xFF1C2635)
                        : const Color(0xFFF0F4F8),
                    child: EmojiPicker(
                      onEmojiSelected: (_, emoji) =>
                          setState(() => _controller.text += emoji.emoji),
                      config: const Config(
                          height: 280, checkPlatformCompatibility: true),
                    ),
                  ),
                ),

              // ── Floating Input Bar ──────────────────────────────────
              Positioned(
                bottom: 16,
                left: 12,
                right: 12,
                child: _ChatInputBar(
                  controller: _controller,
                  focusNode: _focusNode,
                  showEmoji: _showEmoji,
                  onEmojiToggle: () {
                    _showEmoji ? _focusNode.requestFocus() : _focusNode.unfocus();
                    setState(() => _showEmoji = !_showEmoji);
                  },
                  onSend: (text) {
                    context.read<ChatCubit>().sendMessage(text);
                    context.read<ConversationsCubit>().updateLastMessage(
                        widget.receiverId, text, 'Just now');
                  },
                  onVoiceSend: (path, durationMs) {
                    context.read<ChatCubit>().sendVoice(path, durationMs);
                    context.read<ConversationsCubit>().updateLastMessage(
                        widget.receiverId, '🎤 Voice message', 'Just now');
                  },
                  onAttach: (path, type) =>
                      context.read<ChatCubit>().sendMedia(path, type),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isSameDay(String? a, String? b) {
    if (a == null || b == null) return false;
    try {
      final d1 = DateTime.parse(a).toLocal();
      final d2 = DateTime.parse(b).toLocal();
      return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
    } catch (_) {
      return false;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Floating Chat Input Bar
// ─────────────────────────────────────────────────────────────────────────────
class _ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool showEmoji;
  final VoidCallback onEmojiToggle;
  final void Function(String) onSend;
  final void Function(String path, int durationMs) onVoiceSend;
  final void Function(String path, MessageType type) onAttach;

  const _ChatInputBar({
    required this.controller,
    required this.focusNode,
    required this.showEmoji,
    required this.onEmojiToggle,
    required this.onSend,
    required this.onVoiceSend,
    required this.onAttach,
  });

  @override
  State<_ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<_ChatInputBar> {
  bool _isEmpty = true;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final empty = widget.controller.text.trim().isEmpty;
    if (empty != _isEmpty) setState(() => _isEmpty = empty);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final img = await ImagePicker()
        .pickImage(source: source, imageQuality: 60);
    if (img != null) widget.onAttach(img.path, MessageType.image);
  }

  void _showAttachMenu() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2A3A) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Share',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _attachTile(Icons.camera_alt_rounded, 'Camera',
                      const Color(0xFFFF6B6B), () => _pickImage(ImageSource.camera)),
                  _attachTile(Icons.photo_library_rounded, 'Gallery',
                      const Color(0xFF9B59B6), () => _pickImage(ImageSource.gallery)),
                  _attachTile(Icons.insert_drive_file_rounded, 'Document',
                      const Color(0xFF3498DB), () async {
                    Navigator.pop(context);
                    final res = await FilePicker.pickFiles();
                    if (res != null && res.files.single.path != null) {
                      widget.onAttach(res.files.single.path!, MessageType.file);
                    }
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _attachTile(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black54)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ── Unified bar colors ─────────────────────────────────────────
    final barBg = isDark
        ? const Color(0xFF1F2937).withOpacity(0.97)
        : const Color(0xFFF0FDFA).withOpacity(0.97);
    final borderColor = isDark
        ? const Color(0xFF4A90E2).withOpacity(0.20)
        : const Color(0xFF4ECDC4).withOpacity(0.35);
    final iconColor = const Color(0xFF4A90E2);
    final hintColor = isDark
        ? Colors.white.withOpacity(0.32)
        : const Color(0xFF6A7282);
    final textColor = isDark ? Colors.white : const Color(0xFF1F2937);

    return SafeArea(
      top: false,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerRight,
        children: [
          // ── The Pill ──
          Container(
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.28 : 0.08),
                  blurRadius: 20,
                  spreadRadius: -4,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: const Color(0xFF4A90E2).withOpacity(0.09),
                  blurRadius: 16,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: barBg,
                    border: Border.all(color: borderColor, width: 1.0),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      if (!_isRecording) ...[
                        const SizedBox(width: 4),
                        _IconBtn(
                          icon: widget.showEmoji
                              ? Icons.keyboard_rounded
                              : Icons.emoji_emotions_outlined,
                          color: iconColor,
                          size: 22,
                          onTap: widget.onEmojiToggle,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: TextField(
                            controller: widget.controller,
                            focusNode: widget.focusNode,
                            maxLines: 1,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(
                                color: textColor, fontSize: 15.5, height: 1.3),
                            decoration: InputDecoration(
                              hintText: 'Message',
                              hintStyle: TextStyle(color: hintColor, fontSize: 15.5),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (_isEmpty)
                          _IconBtn(
                            icon: Icons.camera_alt_rounded,
                            color: iconColor,
                            size: 21,
                            onTap: () => _pickImage(ImageSource.camera),
                          ),
                        if (_isEmpty)
                          _IconBtn(
                            icon: Icons.attach_file_rounded,
                            color: iconColor,
                            size: 21,
                            onTap: _showAttachMenu,
                          ),
                        
                        // Empty space to prevent content from going under the floating button
                        const SizedBox(width: 48),
                      ],
                      
                      if (_isRecording) const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── The Voice Recorder / Send button ──
          if (_isEmpty)
            Positioned(
              right: 2,
              left: _isRecording ? 0 : null,
              top: _isRecording ? 1 : null,
              bottom: _isRecording ? 1 : null,
              child: VoiceRecorderButton(
                onSend: () {},
                onCancel: () {
                  if (mounted) setState(() => _isRecording = false);
                },
                onRecordingStart: () {
                  if (mounted) setState(() => _isRecording = true);
                },
                onRecordingComplete: (path, ms) {
                  if (mounted) setState(() => _isRecording = false);
                  widget.onVoiceSend(path, ms);
                },
              ),
            ),
            
          if (!_isEmpty)
            Positioned(
              right: 2,
              child: _SendButton(
                isEmpty: _isEmpty,
                controller: widget.controller,
                onSend: widget.onSend,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Reusable icon button with fixed 40×40 touch target ──────────────────────
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    required this.color,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(child: Icon(icon, color: color, size: size)),
      ),
    );
  }
}


// Send / Mic blue circle
class _SendButton extends StatefulWidget {
  final bool isEmpty;
  final TextEditingController controller;
  final void Function(String) onSend;

  const _SendButton({
    required this.isEmpty,
    required this.controller,
    required this.onSend,
  });

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _scale = Tween<double>(begin: 1, end: 0.88)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _anim.forward();
  void _onTapUp(_) => _anim.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => _anim.reverse(),
      onTap: widget.isEmpty
          ? null
          : () {
              final text = widget.controller.text.trim();
              if (text.isEmpty) return;
              widget.onSend(text);
              widget.controller.clear();
            },
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF2AABEE), Color(0xFF1A86C8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2AABEE).withOpacity(0.45),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: widget.isEmpty
              ? null
              : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
//  Date Separator
// ─────────────────────────────────────────────────────────────────────────────
class _DateSeparator extends StatelessWidget {
  final String? timestamp;
  const _DateSeparator({this.timestamp});

  String _label() {
    if (timestamp == null) return '';
    try {
      final dt = DateTime.parse(timestamp!).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final d = DateTime(dt.year, dt.month, dt.day);
      final diff = today.difference(d).inDays;
      if (diff == 0) return 'Today';
      if (diff == 1) return 'Yesterday';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
              child: Divider(
                  color: isDark ? Colors.white12 : Colors.black12)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.07)
                    : Colors.black.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                _label(),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white38 : Colors.black45,
                ),
              ),
            ),
          ),
          Expanded(
              child: Divider(
                  color: isDark ? Colors.white12 : Colors.black12)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Chat AppBar
// ─────────────────────────────────────────────────────────────────────────────
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

  static const _palette = [
    Color(0xFF7B68EE), Color(0xFF20B2AA), Color(0xFFFF6B6B),
    Color(0xFF4ECDC4), Color(0xFF45B7D1), Color(0xFF96CEB4),
    Color(0xFFDDA0DD), Color(0xFFFF8C69),
  ];

  Color _avatarColor() {
    if (name.isEmpty) return _palette[0];
    return _palette[name.codeUnitAt(0) % _palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final ac = _avatarColor();

    final barBg = isDark
        ? const Color(0xFF1A2332).withOpacity(0.97)
        : Colors.white.withOpacity(0.97);
    final borderC = isDark ? Colors.white12 : Colors.black.withOpacity(0.08);
    final titleC = isDark ? Colors.white : Colors.black87;
    final subtitleC = isDark ? Colors.white54 : Colors.black45;
    final iconC = isDark ? Colors.white70 : Colors.black54;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(
              4, MediaQuery.of(context).padding.top + 6, 4, 10),
          decoration: BoxDecoration(
            color: barBg,
            border: Border(
                bottom: BorderSide(color: borderC, width: 0.5)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded,
                    color: iconC, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              // Avatar with initials
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [ac, ac.withOpacity(0.75)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: ac.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: Center(
                  child: Text(initial,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(name,
                        style: TextStyle(
                            color: titleC,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1)),
                    if (role.isNotEmpty)
                      Text(role,
                          style:
                              TextStyle(color: subtitleC, fontSize: 12)),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: iconC),
                color: isDark ? const Color(0xFF1E2A3A) : Colors.white,
                onSelected: (v) {
                  if (v != 'delete') return;
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor:
                          isDark ? const Color(0xFF1E2A3A) : Colors.white,
                      title: Text('Delete Conversation',
                          style: TextStyle(color: titleC)),
                      content: Text(
                          'Are you sure you want to delete this conversation?',
                          style: TextStyle(color: subtitleC)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text('Cancel',
                              style: TextStyle(color: subtitleC)),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<ConversationsCubit>()
                                .deleteConversation(receiverId);
                            Navigator.pop(ctx);
                            Navigator.pop(context);
                          },
                          child: const Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(children: [
                      const Icon(Icons.delete_outline, color: Colors.red),
                      const SizedBox(width: 10),
                      Text('Delete Chat',
                          style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87)),
                    ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  Message Bubble
// ─────────────────────────────────────────────────────────────────────────────
class MessageBubble extends StatelessWidget {
  final MessageModel message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMe = message.isMe;
    final color = isMe
        ? WhatsAppStyles.getAppSentBubbleColor(context)
        : WhatsAppStyles.getAppReceivedBubbleColor(context);

    final textColor = isMe
        ? (isDark ? Colors.white : Colors.black87)
        : (isDark ? Colors.white : Colors.black87);
    final timeColor = isDark ? Colors.white54 : Colors.black38;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => _showOptions(context),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: isMe
                    ? const Radius.circular(20)
                    : const Radius.circular(4),
                topRight: isMe
                    ? const Radius.circular(4)
                    : const Radius.circular(20),
                bottomLeft: const Radius.circular(20),
                bottomRight: const Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildContent(context, textColor),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_formatTime(message.timestamp),
                          style: TextStyle(
                              fontSize: 11, color: timeColor)),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        _buildStatus(message.status, isDark),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2A3A) : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reactions row
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ['👍', '❤️', '😂', '😮', '😢', '🙏']
                    .map((e) => GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(e,
                              style: const TextStyle(fontSize: 30)),
                        ))
                    .toList(),
              ),
            ),
            Divider(
                color: isDark ? Colors.white12 : Colors.black12,
                height: 0),
            if (message.type == MessageType.text)
              ListTile(
                leading: Icon(Icons.copy_rounded,
                    color: isDark ? Colors.white70 : Colors.black54),
                title: Text('Copy',
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87)),
                onTap: () {
                  Navigator.pop(context);
                  Clipboard.setData(
                      ClipboardData(text: message.content));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Copied!')),
                  );
                },
              ),
            if (message.isMe && message.id != null)
              ListTile(
                leading: const Icon(Icons.delete_rounded,
                    color: Colors.redAccent),
                title: const Text('Delete',
                    style: TextStyle(color: Colors.redAccent)),
                onTap: () {
                  Navigator.pop(context);
                  context
                      .read<ChatCubit>()
                      .deleteMessage(message.id!);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Color textColor) {
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
        return _buildFile(textColor);
      default:
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
          child: Text(message.content,
              style: TextStyle(fontSize: 15.5, color: textColor, height: 1.35)),
        );
    }
  }

  Widget _buildImage() => ClipRRect(
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(16), bottom: Radius.circular(4)),
        child: message.mediaUrl != null
            ? (message.mediaUrl!.startsWith('http')
                ? Image.network(message.mediaUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imgPlaceholder())
                : Image.file(File(message.mediaUrl!),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imgPlaceholder()))
            : _imgPlaceholder(),
      );

  Widget _imgPlaceholder() => Container(
        height: 180,
        width: 220,
        color: Colors.grey.withOpacity(0.2),
        child: const Icon(Icons.broken_image_rounded,
            size: 48, color: Colors.white38),
      );

  Widget _buildFile(Color textColor) => Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.insert_drive_file_rounded,
                  color: Colors.white70, size: 22),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text('Document',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: textColor, fontSize: 14)),
            ),
          ],
        ),
      );

  Widget _buildStatus(MessageStatus s, bool isDark) {
    switch (s) {
      case MessageStatus.pending:
        return Icon(Icons.access_time_rounded,
            size: 13, color: isDark ? Colors.white38 : Colors.black26);
      case MessageStatus.sent:
        return Icon(Icons.done_rounded,
            size: 15, color: isDark ? Colors.white54 : Colors.black38);
      case MessageStatus.delivered:
        return Icon(Icons.done_all_rounded,
            size: 15, color: isDark ? Colors.white54 : Colors.black38);
      case MessageStatus.read:
        return const Icon(Icons.done_all_rounded,
            size: 15, color: Color(0xFF2AABEE));
      case MessageStatus.failed:
        return const Icon(Icons.error_outline_rounded,
            size: 15, color: Colors.redAccent);
    }
  }

  String _formatTime(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}
