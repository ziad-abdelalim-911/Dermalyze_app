import 'package:flutter/material.dart';

class ImportantRemindersCard extends StatelessWidget {
  const ImportantRemindersCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFF2DD4BF)),
      ),

      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Important Reminders",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),

          SizedBox(height: 8),

          Text("• Take all medications as prescribed by your doctor"),
          Text("• Set daily reminders to avoid missing doses"),
          Text("• Contact your doctor if you experience side effects"),
          Text("• Do not share medications with others"),
        ],
      ),
    );
  }
}
