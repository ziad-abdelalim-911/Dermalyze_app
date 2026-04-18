import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AiRecommendationCard extends StatelessWidget {
  final String recommendation;

  const AiRecommendationCard({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.Turqouoise, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome,
                  color: AppColors.Turqouoise, size: 20),
              const SizedBox(width: 8),
              Text(
                'AI Recommendation',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.Black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            recommendation,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.Gray3,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}