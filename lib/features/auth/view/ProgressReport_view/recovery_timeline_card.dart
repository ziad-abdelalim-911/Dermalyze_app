import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:flutter/material.dart';

class TimelineItemModel {
  final String title;
  final String date;
  final String recoveryRate;
  final String description;
  final Color color;
  final Color bgColor;

  TimelineItemModel({
    required this.title,
    required this.date,
    required this.recoveryRate,
    required this.description,
    required this.color,
    required this.bgColor,
  });
}

class RecoveryTimelineCard extends StatelessWidget {
  final List<TimelineItemModel> items;

  const RecoveryTimelineCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 10),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recovery Timeline",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          Column(
            children: items.map((item) => _TimelineRow(item: item)).toList(),
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final TimelineItemModel item;

  const _TimelineRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// LEFT LINE + CIRCLE
        Column(
          children: [
            Container(width: 2, height: 12, color: item.color),

            Container(
              width: 24,
              height: 24,

              decoration: BoxDecoration(
                color: item.color,
                shape: BoxShape.circle,
              ),

              child: Center(
                child: Image.asset(AppAssets.pulse_icon, width: 14, height: 14),
              ),
            ),

            Container(width: 2, height: 80, color: item.color),
          ],
        ),

        const SizedBox(width: 12),

        /// RIGHT CARD
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: item.bgColor,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: item.color,
                      ),
                    ),

                    Text(
                      item.date,
                      style: TextStyle(color: item.color, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  "Recovery Rate: ${item.recoveryRate}",
                  style: TextStyle(
                    color: item.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  item.description,
                  style: TextStyle(
                    color: item.color.withOpacity(.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
