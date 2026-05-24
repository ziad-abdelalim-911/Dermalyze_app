import 'package:dermalyze/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class KeyMetricsCard extends StatelessWidget {
  final List<MetricItem> MetricItems;

  const KeyMetricsCard({super.key, required this.MetricItems});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDarkMode;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? .1 : .05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text(
            "Key Metrics",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: context.dynamicTextColorPrimary,
            ),
          ),
          const SizedBox(height: 16),

          /// GRID
          if (MetricItems.length >= 4) ...[
            Row(
              children: [
                Expanded(child: MetricItems[0]),
                const SizedBox(width: 12),
                Expanded(child: MetricItems[1]),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: MetricItems[2]),
                const SizedBox(width: 12),
                Expanded(child: MetricItems[3]),
              ],
            ),
          ] else ...[
            const Center(child: Text("Insufficient metric data")),
          ],
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
    final bool isDark = context.isDarkMode;

    // Resolve readable high-contrast colors dynamically in Dark Mode
    Color resolvedTextColor = textColor;
    Color resolvedIconColor = iconColor;

    if (isDark) {
      if (textColor.value == 0xFF0F766E || textColor.value == 0xFF166534) {
        resolvedTextColor = Colors.green.shade300;
        resolvedIconColor = Colors.green.shade300;
      } else if (textColor.value == 0xFF1D4ED8) {
        resolvedTextColor = Colors.blue.shade300;
        resolvedIconColor = Colors.blue.shade300;
      } else if (textColor.value == 0xFF7E22CE || textColor.value == 0xFF6D28D9) {
        resolvedTextColor = const Color(0xFFB57BEE);
        resolvedIconColor = const Color(0xFFB57BEE);
      } else {
        resolvedTextColor = context.dynamicTextColorPrimary;
        resolvedIconColor = context.dynamicTextColorPrimary;
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? context.dynamicInputColor : backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: Colors.white10) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ICON
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
            color: resolvedIconColor,
          ),
          const SizedBox(height: 12),

          /// VALUE
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: resolvedTextColor,
            ),
          ),
          const SizedBox(height: 4),

          /// LABEL
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey.shade400 : resolvedTextColor.withOpacity(.8),
            ),
          ),
        ],
      ),
    );
  }
}
