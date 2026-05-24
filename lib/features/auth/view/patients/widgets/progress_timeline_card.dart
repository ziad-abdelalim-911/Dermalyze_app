import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class TimelineItem {
  final String label;
  final String badge;
  final String date;
  final String? improvement;

  const TimelineItem({
    required this.label,
    required this.badge,
    required this.date,
    this.improvement,
  });
}

class ProgressTimelineCard extends StatelessWidget {
  final List<TimelineItem> items;

  const ProgressTimelineCard({super.key, required this.items});

  Color _badgeColor(String badge) {
    switch (badge.toLowerCase()) {
      case 'high':
        return const Color(0xFF4CAF50);
      case 'medium':
        return const Color(0xFFFFC107);
      case 'low':
        return const Color(0xFFE05252);
      default:
        return AppColors.Gray;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
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
            'Progress Timeline',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          ...items.map((item) => _buildTimelineItem(context, item)),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, TimelineItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Image Placeholder
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white10 : AppColors.Gray2.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.show_chart, color: Theme.of(context).iconTheme.color ?? AppColors.Gray, size: 24),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label + Badge
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.Black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item.badge.isNotEmpty && item.badge != 'N/A') ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _badgeColor(item.badge).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.badge,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _badgeColor(item.badge),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  item.date,
                  style: TextStyle(fontSize: 12, color: AppColors.Gray),
                ),
                if (item.improvement != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.improvement!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.Turqouoise,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
