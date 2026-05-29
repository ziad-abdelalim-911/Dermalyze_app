import 'package:dermalyze/features/auth/view/chat/model/message_type.dart';

class MessageModel {
  final String? id;
  final String senderId;
  final String? receiverId;
  final String content;
  final String? timestamp;
  final bool isMe;
  final MessageType type;
  final String? mediaUrl;
  final MessageStatus status;
  final int durationMs; // for audio messages
  final String? reaction;

  MessageModel({
    this.id,
    required this.senderId,
    this.receiverId,
    required this.content,
    this.timestamp,
    required this.isMe,
    this.type = MessageType.text,
    this.mediaUrl,
    this.status = MessageStatus.sent,
    this.durationMs = 0,
    this.reaction,
  });

  /// Parse from backend response.
  /// Backend may return:
  ///   { _id, sender, receiver, content, createdAt, isRead, type }
  /// OR older format:
  ///   { id, senderId, receiverId, content, timestamp, type, status }
  factory MessageModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    // ── ID ───────────────────────────────────────────
    final id = json['_id']?.toString() ?? json['id']?.toString();

    // ── Sender / Receiver ────────────────────────────
    // Backend may store sender as nested object or plain ID string
    final senderRaw = json['sender'];
    final String senderId;
    if (senderRaw is Map<String, dynamic>) {
      senderId = senderRaw['_id']?.toString() ?? senderRaw['id']?.toString() ?? '';
    } else {
      senderId = senderRaw?.toString()
          ?? json['senderId']?.toString()
          ?? '';
    }

    final receiverRaw = json['receiver'];
    final String? receiverId;
    if (receiverRaw is Map<String, dynamic>) {
      receiverId = receiverRaw['_id']?.toString() ?? receiverRaw['id']?.toString();
    } else {
      receiverId = receiverRaw?.toString() ?? json['receiverId']?.toString();
    }

    // ── Timestamp ─────────────────────────────────────
    final timestamp = json['createdAt']?.toString()
        ?? json['timestamp']?.toString()
        ?? DateTime.now().toIso8601String();

    // ── Read status ───────────────────────────────────
    MessageStatus status;
    if (json.containsKey('isRead')) {
      status = (json['isRead'] == true) ? MessageStatus.read : MessageStatus.sent;
    } else {
      status = _parseStatus(json['status']?.toString());
    }

    return MessageModel(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      content: json['content']?.toString() ?? '',
      timestamp: timestamp,
      isMe: senderId == currentUserId,
      type: _parseType(json['type']?.toString()),
      mediaUrl: json['mediaUrl']?.toString(),
      status: status,
      durationMs: json['durationMs'] as int? ?? 0,
      reaction: json['reaction']?.toString(),
    );
  }

  static MessageType _parseType(String? type) {
    switch (type) {
      case 'image': return MessageType.image;
      case 'audio': return MessageType.audio;
      case 'file': return MessageType.file;
      case 'sticker': return MessageType.sticker;
      default: return MessageType.text;
    }
  }

  static MessageStatus _parseStatus(String? status) {
    switch (status) {
      case 'pending': return MessageStatus.pending;
      case 'delivered': return MessageStatus.delivered;
      case 'read': return MessageStatus.read;
      default: return MessageStatus.sent;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'receiverId': receiverId,
      'content': content,
      'type': type.name,
      'mediaUrl': mediaUrl,
      'status': status.name,
    };
  }

  MessageModel copyWith({MessageStatus? status, String? reaction}) {
    return MessageModel(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      timestamp: timestamp,
      isMe: isMe,
      type: type,
      mediaUrl: mediaUrl,
      status: status ?? this.status,
      durationMs: durationMs,
      reaction: reaction ?? this.reaction,
    );
  }
}
