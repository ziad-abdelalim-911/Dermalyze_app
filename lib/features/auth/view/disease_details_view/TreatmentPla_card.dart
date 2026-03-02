import 'package:flutter/material.dart';

class TreatmentStepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color circleColor;
  final Color textColor;
  final Color subtitleColor;

  const TreatmentStepCard({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.circleColor,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [
          /// circle number
          Container(
            width: 32,
            height: 32,

            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),

            alignment: Alignment.center,

            child: Text(
              stepNumber.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// title
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                /// subtitle
                Text(
                  subtitle,
                  style: TextStyle(color: subtitleColor, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
