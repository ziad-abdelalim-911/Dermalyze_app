import 'package:flutter/material.dart';

class DiagnosisInfoCard extends StatelessWidget {
  const DiagnosisInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 10),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Diagnosis Information",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          infoRow(
            icon: Icons.calendar_today,
            title: "Diagnosed On",
            value: "December 15, 2025",
          ),

          const SizedBox(height: 12),

          infoRow(
            icon: Icons.monitor_heart_outlined,
            title: "Severity Level",
            value: "Moderate",
          ),

          const SizedBox(height: 12),

          infoRow(
            icon: Icons.trending_up,
            title: "Current Status",
            value: "Improving",
            valueColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget infoRow({
    required IconData icon,
    required String title,
    required String value,
    Color valueColor = Colors.black,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey, fontWeight: FontWeight.w400),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 2),

            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
