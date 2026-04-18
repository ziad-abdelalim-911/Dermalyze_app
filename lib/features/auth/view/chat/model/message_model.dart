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
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    return MessageModel(
      id: json['id']?.toString(),
      senderId: json['senderId']?.toString() ?? '',
      receiverId: json['receiverId']?.toString(),
      content: json['content']?.toString() ?? '',
      timestamp: json['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
      isMe: json['senderId']?.toString() == currentUserId,
      type: _parseType(json['type']?.toString()),
      mediaUrl: json['mediaUrl']?.toString(),
      status: _parseStatus(json['status']?.toString()),
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

  MessageModel copyWith({MessageStatus? status}) {
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
    );
  }
}
