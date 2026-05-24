import 'package:dermalyze/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class QualityStatusCard extends StatelessWidget {
  final String current;
  final String lastMonth;
  final String initial;

  const QualityStatusCard({
    super.key,
    required this.current,
    required this.lastMonth,
    required this.initial,
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
              color: Colors.black.withOpacity(isDark ? .3 : .2),
              blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text(
            "Quality Status",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.dynamicTextColorPrimary,
            ),
          ),
          const SizedBox(height: 16),

          /// CURRENT
          _buildRow(
            context: context,
            title: "Current",
            value: current,
            color: isDark ? Colors.green.shade300 : const Color(0xFF22C55E),
            bgColor: isDark
                ? Colors.green.withOpacity(0.2)
                : const Color(0xFFE7F6EC),
          ),

          const SizedBox(height: 12),

          /// LAST MONTH
          _buildRow(
            context: context,
            title: "Last Month",
            value: lastMonth,
            color: isDark ? Colors.amber.shade300 : const Color(0xFFD97706),
            bgColor: isDark
                ? Colors.amber.withOpacity(0.2)
                : const Color(0xFFFEF3C7),
          ),

          const SizedBox(height: 12),

          /// INITIAL
          _buildRow(
            context: context,
            title: "Initial",
            value: initial,
            color: isDark ? Colors.red.shade300 : const Color(0xFFEF4444),
            bgColor: isDark
                ? Colors.red.withOpacity(0.2)
                : const Color(0xFFFEE2E2),
          ),
        ],
      ),
    );
  }

  /// reusable row
  Widget _buildRow({
    required BuildContext context,
    required String title,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: context.dynamicTextColorPrimary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
