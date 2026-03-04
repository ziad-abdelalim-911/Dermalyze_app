class ChatMessage {
  final String senderName;
  final String message;
  final String time;
  final bool isMe;
  final String kind;
  final String image;

  ChatMessage({
    required this.senderName,
    required this.message,
    required this.time,
    required this.isMe,
    required this.kind,
    required this.image,
  });
}
