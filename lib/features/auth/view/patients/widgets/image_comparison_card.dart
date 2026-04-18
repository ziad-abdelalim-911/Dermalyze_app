import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ImageComparisonCard extends StatelessWidget {
  const ImageComparisonCard({super.key});

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
          Text(
            'Image Comparison',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.Black,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Previous Scan
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.camera_alt_outlined,
                            size: 14, color: AppColors.Gray),
                        const SizedBox(width: 4),
                        Text(
                          'Previous Scan',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.Gray),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFCDD2),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.Black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Severity: 65%',
                        style:
                            TextStyle(color: Theme.of(context).cardColor, fontSize: 11),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Jan 15, 2025',
                      style:
                          TextStyle(fontSize: 11, color: AppColors.Gray),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Current Scan
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.camera_alt_outlined,
                            size: 14, color: AppColors.Gray),
                        const SizedBox(width: 4),
                        Text(
                          'Current Scan',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.Gray),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.Turqouoise, width: 2),
                      ),
                      child: Center(
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Color(0xFFC8F5C8),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.Black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Severity: 50%',
                        style:
                            TextStyle(color: Theme.of(context).cardColor, fontSize: 11),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Today',
                      style:
                          TextStyle(fontSize: 11, color: AppColors.Gray),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}