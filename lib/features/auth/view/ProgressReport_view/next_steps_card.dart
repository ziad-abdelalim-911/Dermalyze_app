import 'package:dermalyze/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class NextStepsCard extends StatelessWidget {
  final List<String> steps;

  const NextStepsCard({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.blue.shade800.withOpacity(0.5) : const Color(0xFF3B82F6),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Next Steps",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.blue.shade300 : const Color(0xFF1D4ED8),
              fontSize: 16,
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
                  style: TextStyle(
                    color: isDark ? Colors.grey.shade300 : const Color(0xFF1D4ED8),
                    fontSize: 14,
                    height: 1.4,
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
