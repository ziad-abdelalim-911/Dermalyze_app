import 'package:flutter/material.dart';
import 'package:dermalyze/core/constants/app_assets.dart';

class KeyMetricsCard extends StatelessWidget {
  const KeyMetricsCard({super.key, required List<MetricItem> MetricItems});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TITLE
          const Text(
            "Key Metrics",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          /// GRID
          Row(
            children: [

              Expanded(
                child: MetricItem(
                  iconPath: AppAssets.calendarIcon,
                  value: "17",
                  label: "Days in Treatment",

                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  iconColor: const Color(0xFF14B8A6),
                  textColor: const Color(0xFF0F766E),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: MetricItem(
                  iconPath: AppAssets.progress_icon,
                  value: "+28%",
                  label: "Overall Improvement",

                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  iconColor: const Color(0xFF16A34A),
                  textColor: const Color(0xFF166534),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              Expanded(
                child: MetricItem(
                  iconPath: AppAssets.pulse_icon,
                  value: "3",
                  label: "Doctor Checkups",

                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  iconColor: const Color(0xFF2563EB),
                  textColor: const Color(0xFF1D4ED8),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: MetricItem(
                  iconPath: AppAssets.award_Icon,
                  value: "95%",
                  label: "Medication Adherence",

                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  iconColor: const Color(0xFF9333EA),
                  textColor: const Color(0xFF7E22CE),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MetricItem extends StatelessWidget {

  final String iconPath;
  final String value;
  final String label;

  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const MetricItem({
    super.key,
    required this.iconPath,
    required this.value,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ICON
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
            color: iconColor,
          ),

          const SizedBox(height: 12),

          /// VALUE
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),

          const SizedBox(height: 4),

          /// LABEL
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: textColor.withOpacity(.8),
            ),
          ),
        ],
      ),
    );
  }
}

