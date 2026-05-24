import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class ReadyForAnalysisCard extends StatelessWidget {
  final String patientName;
  final String diagnosis;

  const ReadyForAnalysisCard({
    super.key,
    required this.patientName,
    required this.diagnosis,
  });

  @override
  Widget build(BuildContext context) {
    final initials = patientName
        .trim()
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ready for Analysis',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: context.dynamicTextColorPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "The AI will compare this image with the patient's previous scans to detect improvements.",
            style: TextStyle(
              fontSize: 13,
              color: context.dynamicTextColorSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          // Patient Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.Turqouoise, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient2,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.dynamicTextColorPrimary,
                      ),
                    ),
                    Text(
                      diagnosis,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.dynamicTextColorSecondary,
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
}