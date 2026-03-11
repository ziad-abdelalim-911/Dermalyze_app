import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AiAnalysisProgressCard extends StatelessWidget {
  const AiAnalysisProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
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
        children: [
          // Loading Circle
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.SkyBlue, width: 2.5),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.Turqouoise,
                strokeWidth: 2.5,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'AI Analysis in Progress',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.Black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Comparing with previous scans...',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.Gray,
            ),
          ),
        ],
      ),
    );
  }
}