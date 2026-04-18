import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProgressStatisticsCard extends StatelessWidget {
  final String previousSeverity;
  final String previousDate;
  final String currentSeverity;
  final String affectedAreaPrevious;
  final String affectedAreaCurrent;
  final String improvementRate;

  const ProgressStatisticsCard({
    super.key,
    required this.previousSeverity,
    required this.previousDate,
    required this.currentSeverity,
    required this.affectedAreaPrevious,
    required this.affectedAreaCurrent,
    required this.improvementRate,
  });

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
              Icon(Icons.trending_up, color: AppColors.Turqouoise, size: 20),
              const SizedBox(width: 8),
              Text(
                'Progress Statistics',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.Black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Severity Row
          Row(
            children: [
              // Previous
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFFFFCDD2), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Previous Severity',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.Gray),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        previousSeverity,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE05252),
                        ),
                      ),
                      Text(
                        previousDate,
                        style: TextStyle(
                            fontSize: 11, color: AppColors.Gray),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Current
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppColors.Turqouoise, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Severity',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.Gray),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        currentSeverity,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.Turqouoise,
                        ),
                      ),
                      Text(
                        'Today',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.Gray),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Affected Area
          _buildStatRow(
            label: 'Affected Area',
            oldValue: affectedAreaPrevious,
            newValue: affectedAreaCurrent,
          ),
          Divider(height: 24, color: AppColors.Gray2.withOpacity(0.5)),
          // Improvement Rate
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Improvement Rate',
                style: TextStyle(fontSize: 13, color: AppColors.Black),
              ),
              Row(
                children: [
                  Icon(Icons.trending_up,
                      color: AppColors.Turqouoise, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    improvementRate,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.Turqouoise,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow({
    required String label,
    required String oldValue,
    required String newValue,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 13, color: AppColors.Black)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              oldValue,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.Gray,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            Text(
              newValue,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.Turqouoise,
              ),
            ),
          ],
        ),
      ],
    );
  }
}