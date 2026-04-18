import 'package:flutter/material.dart';

class NextStepsCard extends StatelessWidget {
  const NextStepsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFC5D8EC), width: 1.5),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Color(0xFF3A8FA8), size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Steps',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1A2E3B),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'After creating the patient file, you can add their initial scan and start monitoring their progress from their profile page.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8A9BAB),
                    height: 1.5,
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
