class NotificationModel {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final String priority; // High, Medium, Low
  final String type; // chat, medication, analysis, appointment, system
  final bool isUnread;

  NotificationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.priority,
    required this.type,
    required this.isUnread,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title'] ?? 'Notification',
      subtitle: json['subtitle'] ?? json['message'] ?? '',
      time: json['time'] ?? json['createdAt'] ?? 'Just now',
      priority: json['priority'] ?? 'Medium',
      type: json['type'] ?? 'system',
      isUnread: json['isUnread'] ?? json['unread'] ?? false,
    );
  }
}
