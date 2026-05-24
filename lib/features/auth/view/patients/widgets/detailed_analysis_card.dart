import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class DetailedAnalysisItem {
  final String label;
  final String oldValue;
  final String newValue;

  const DetailedAnalysisItem({
    required this.label,
    required this.oldValue,
    required this.newValue,
  });
}

class DetailedAnalysisCard extends StatelessWidget {
  final List<DetailedAnalysisItem> items;

  const DetailedAnalysisCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Icon(Icons.info_outline,
                  color: AppColors.Turqouoise, size: 20),
              const SizedBox(width: 8),
              Text(
                'Detailed Analysis',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: context.dynamicTextColorPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...items.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            return Column(
              children: [
                _buildAnalysisRow(context, item),
                if (i < items.length - 1)
                  Divider(
                    height: 20,
                    color: context.isDarkMode
                        ? Colors.white10
                        : AppColors.Gray2.withOpacity(0.5),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAnalysisRow(BuildContext context, DetailedAnalysisItem item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          item.label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: context.dynamicTextColorPrimary,
          ),
        ),
        Row(
          children: [
            Text(
              item.oldValue,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFE05252),
                decoration: TextDecoration.lineThrough,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Icon(
                Icons.arrow_forward,
                size: 12,
                color: context.dynamicTextColorSecondary,
              ),
            ),
            Text(
              item.newValue,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.Turqouoise,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.check_circle_outline,
                color: AppColors.Turqouoise, size: 16),
          ],
        ),
      ],
    );
  }
}