class MessageModel {
  final String? id;
  final String senderId;
  final String? receiverId; // Can be null if it's a group or not needed
  final String content;
  final String? timestamp;
  final bool isMe;

  MessageModel({
    this.id,
    required this.senderId,
    this.receiverId,
    required this.content,
    this.timestamp,
    required this.isMe,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    return MessageModel(
      id: json['id']?.toString(),
      senderId: json['senderId']?.toString() ?? '',
      receiverId: json['receiverId']?.toString(),
      content: json['content']?.toString() ?? '',
      timestamp: json['timestamp']?.toString() ?? DateTime.now().toIso8601String(),
      isMe: json['senderId']?.toString() == currentUserId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'receiverId': receiverId,
      'content': content,
    };
  }
}
