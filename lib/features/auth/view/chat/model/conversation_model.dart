class ConversationModel {
  final String id;
  final String receiverId;
  final String name;
  final String role;
  final String lastMessage;
  final String time;
  final bool isOnline;
  int unreadCount;

  ConversationModel({
    required this.id,
    required this.receiverId,
    required this.name,
    required this.role,
    required this.lastMessage,
    required this.time,
    this.isOnline = false,
    this.unreadCount = 0,
  });

  // ─────────────────────────────────────────────────────────────────
  // From GET /chat/conversations response
  // Handles both:
  //   { participant: { _id, name, role }, lastMessage: { content, createdAt }, unreadCount }
  //   { _id, receiverId, name, role, lastMessage, createdAt, unreadCount }
  // ─────────────────────────────────────────────────────────────────
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final participant = json['participant'] as Map<String, dynamic>?;
    final otherId = participant?['_id']?.toString()
        ?? participant?['id']?.toString()
        ?? json['receiverId']?.toString()
        ?? json['_id']?.toString()
        ?? '';

    final name = participant?['name']?.toString() ?? json['name']?.toString() ?? 'Unknown';
    final role = participant?['role']?.toString() ?? json['role']?.toString() ?? '';

    final lastMsgObj = json['lastMessage'];
    String lastMsg = '';
    String time = '';

    if (lastMsgObj is Map<String, dynamic>) {
      lastMsg = lastMsgObj['content']?.toString() ?? '';
      time = _formatTime(lastMsgObj['createdAt']?.toString() ?? lastMsgObj['timestamp']?.toString());
    } else {
      lastMsg = lastMsgObj?.toString() ?? '';
      time = _formatTime(json['createdAt']?.toString() ?? json['time']?.toString() ?? '');
    }

    return ConversationModel(
      id: otherId,
      receiverId: otherId,
      name: _addPrefix(name, role),
      role: _formatRole(role),
      lastMessage: lastMsg.isEmpty ? 'Tap to start chatting' : lastMsg,
      time: time,
      isOnline: json['isOnline'] as bool? ?? false,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // From GET /doctor/patients response
  // { _id, name, status, diagnosis, updatedAt, ... }
  // ─────────────────────────────────────────────────────────────────
  factory ConversationModel.fromPatient(Map<String, dynamic> json) {
    final id = json['_id']?.toString() ?? json['id']?.toString() ?? '';
    final name = json['name']?.toString() ?? 'Patient';
    final status = json['status']?.toString() ?? '';
    final updatedAt = json['updatedAt']?.toString() ?? json['createdAt']?.toString() ?? '';

    return ConversationModel(
      id: id,
      receiverId: id,
      name: name,
      role: status.isNotEmpty ? _capitalize(status) : 'Patient',
      lastMessage: 'Tap to chat',
      time: _formatTime(updatedAt),
      isOnline: false,
      unreadCount: 0,
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────
  static String _addPrefix(String name, String role) {
    if (role.toLowerCase().contains('doctor') ||
        role.toLowerCase().contains('dr')) {
      if (!name.toLowerCase().startsWith('dr')) return 'Dr. $name';
    }
    return name;
  }

  static String _formatRole(String role) {
    switch (role.toLowerCase()) {
      case 'doctor': return 'Dermatologist';
      case 'patient': return 'Patient';
      default: return role.isEmpty ? '' : _capitalize(role);
    }
  }

  static String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  static String _formatTime(String? iso) {
    if (iso == null || iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inHours < 1) return '${diff.inMinutes}m ago';
      if (diff.inDays < 1) {
        return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      }
      if (diff.inDays == 1) return 'Yesterday';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.day}/${dt.month}';
    } catch (_) {
      return '';
    }
  }

  // ─────────────────────────────────────────────────────────────────
  Map<String, dynamic> toJson() => {
    'id': id, 'receiverId': receiverId, 'name': name,
    'role': role, 'lastMessage': lastMessage, 'time': time,
    'isOnline': isOnline, 'unreadCount': unreadCount,
  };

  ConversationModel copyWith({
    String? id, String? receiverId, String? name, String? role,
    String? lastMessage, String? time, bool? isOnline, int? unreadCount,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      receiverId: receiverId ?? this.receiverId,
      name: name ?? this.name,
      role: role ?? this.role,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      isOnline: isOnline ?? this.isOnline,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
