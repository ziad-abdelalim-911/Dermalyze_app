class ConversationModel {
  final String id;
  final String receiverId;
  final String name;
  final String role;
  final String lastMessage;
  final String time;
  final bool isOnline;
  int unreadCount; // Mutable to allow clearing it easily

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

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      receiverId: json['receiverId'] ?? '',
      name: json['name'] ?? 'Unknown',
      role: json['role'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      time: json['time'] ?? '',
      isOnline: json['isOnline'] ?? false,
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receiverId': receiverId,
      'name': name,
      'role': role,
      'lastMessage': lastMessage,
      'time': time,
      'isOnline': isOnline,
      'unreadCount': unreadCount,
    };
  }
}
