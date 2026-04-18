import 'package:flutter/material.dart';

class NextStepsCard extends StatelessWidget {
  final List<String> steps;

  const NextStepsCard({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF3B82F6),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Next Steps",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D4ED8),
            ),
          ),

          const SizedBox(height: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: steps.map((step) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  "• $step",
                  style: const TextStyle(
                    color: Color(0xFF1D4ED8),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
