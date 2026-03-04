import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:flutter/material.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F8),

      body: Column(
        children: [
          /// ================= HEADER =================
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                /// back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),

                  child: Container(
                    width: 40,
                    height: 40,

                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: const Icon(Icons.arrow_back),
                  ),
                ),

                const SizedBox(width: 12),

                /// title + unread
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Notifications",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        "3 unread",
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                /// mark all read
                Row(
                  children: const [
                    Icon(Icons.check, color: Color(0xFF10B981), size: 18),

                    SizedBox(width: 6),

                    Text(
                      "Mark all as read",
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// ================= BODY =================
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 16),

                /// NEW label
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "New",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),

                const SizedBox(height: 8),

                /// unread notifications
                notificationCard(
                  icon: AppAssets.chat_icon,
                  iconColor: Colors.blue,
                  title: "Dr. Rasha sent a message",
                  subtitle:
                      "Your test results are ready for review. Please check the latest",
                  time: "5 min ago",
                  priority: "High",
                  isUnread: true,
                ),

                notificationCard(
                  icon: AppAssets.medication_icon,
                  iconColor: Colors.teal,
                  title: "Medication Reminder",
                  subtitle:
                      "Time to take Hydrocortisone Cream. Apply to affected areas.",
                  time: "1 hour ago",
                  priority: "High",
                  isUnread: true,
                ),

                notificationCard(
                  icon: AppAssets.analysis_icon,
                  iconColor: Colors.purple,
                  title: "Analysis Complete",
                  subtitle:
                      "Your skin condition analysis has been completed. Recovery rate: 76%",
                  time: "2 hours ago",
                  priority: "Medium",
                  isUnread: true,
                ),

                const SizedBox(height: 16),

                /// EARLIER label
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Earlier",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),

                const SizedBox(height: 8),

                notificationCard(
                  icon: AppAssets.time_icon,
                  iconColor: Colors.orange,
                  title: "Upcoming Appointment",
                  subtitle:
                      "Your appointment with Dr. Rasha is scheduled for Jan 15, 2026 at 10:00",
                  time: "5 hours ago",
                  priority: "Medium",
                  isUnread: false,
                ),

                notificationCard(
                  icon: AppAssets.medication_icon,
                  iconColor: Colors.teal,
                  title: "Medication Refill Needed",
                  subtitle:
                      "Cetirizine 10mg prescription will expire in 5 days. Request refill.",
                  time: "1 day ago",
                  priority: "Medium",
                  isUnread: false,
                ),

                notificationCard(
                  icon: AppAssets.i_icon,
                  iconColor: Colors.green,
                  title: "Image Upload Successful",
                  subtitle:
                      "Your disease progress photo has been uploaded and is being analyzed.",
                  time: "2 days ago",
                  priority: "Low",
                  isUnread: false,
                ),

                notificationCard(
                  icon: AppAssets.chat_icon,
                  iconColor: Colors.blue,
                  title: "New Treatment Plan",
                  subtitle:
                      "Dr. Rasha updated your treatment plan. Review the changes.",
                  time: "3 days ago",
                  priority: "High",
                  isUnread: false,
                ),

                const SizedBox(height: 16),

                /// tips box
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F7F5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF2DD4BF)),
                  ),

                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "💡 Notification Tips",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      SizedBox(height: 8),

                      Text("• Tap any notification to mark it as read"),
                      Text(
                        "• High priority alerts require immediate attention",
                      ),
                      Text("• Enable push notifications in settings"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget notificationCard({
  required String icon,
  required Color iconColor,
  required String title,
  required String subtitle,
  required String time,
  required String priority,
  required bool isUnread,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.all(16),

    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),

      border: Border.all(
        color: isUnread ? const Color(0xFF2DD4BF) : Colors.transparent,
        width: 1.5,
      ),

      boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
      ],
    ),

    child: Row(
      children: [
        /// icon box
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(.15),
            borderRadius: BorderRadius.circular(12),
          ),

          child: Center(
            child: ImageIcon(
              AssetImage(icon), // ← use asset icon
              color: iconColor,
              size: 22,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                  priorityBadge(priority),
                ],
              ),

              const SizedBox(height: 4),

              Text(subtitle, style: const TextStyle(color: Colors.grey)),

              const SizedBox(height: 6),

              Row(
                children: [
                  const Icon(Icons.access_time, size: 14),

                  const SizedBox(width: 4),

                  Text(time),

                  if (isUnread)
                    Container(
                      margin: const EdgeInsets.only(left: 6),
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// ================= PRIORITY BADGE =================

Widget priorityBadge(String priority) {
  Color bg;
  Color text;

  switch (priority) {
    case "High":
      bg = const Color(0xFFFEE2E2);
      text = Colors.red;
      break;

    case "Medium":
      bg = const Color(0xFFFEF3C7);
      text = Colors.orange;
      break;

    default:
      bg = const Color(0xFFE5E7EB);
      text = Colors.grey;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(20),
    ),

    child: Text(priority, style: TextStyle(color: text, fontSize: 12)),
  );
}
