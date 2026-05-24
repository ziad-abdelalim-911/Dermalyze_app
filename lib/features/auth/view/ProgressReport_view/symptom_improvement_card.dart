import 'package:dermalyze/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class SymptomModel {
  final String name;
  final int percent;

  SymptomModel({
    required this.name,
    required this.percent,
  });
}

class SymptomImprovementCard extends StatelessWidget {
  final List<SymptomModel> symptoms;

  const SymptomImprovementCard({
    super.key,
    required this.symptoms,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(isDark ? .3 : .05),
              blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Symptom Improvement",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: context.dynamicTextColorPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: symptoms.map((s) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          s.name,
                          style: TextStyle(
                            color: context.dynamicTextColorPrimary,
                          ),
                        ),
                        Text(
                          "-${s.percent}%",
                          style: TextStyle(
                            color: isDark ? Colors.green.shade300 : const Color(0xFF10B981),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: s.percent / 100,
                      minHeight: 6,
                      color: const Color(0xFF10B981),
                      backgroundColor: isDark ? Colors.white12 : Colors.grey[300],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
