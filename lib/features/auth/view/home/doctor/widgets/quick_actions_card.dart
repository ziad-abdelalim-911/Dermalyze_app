import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class QuickActionsCard extends StatelessWidget {
  final String totalPatients;
  final String criticalCases;
  final VoidCallback onAllPatients;
  final VoidCallback onCritical;

  const QuickActionsCard({
    super.key,
    required this.totalPatients,
    required this.criticalCases,
    required this.onAllPatients,
    required this.onCritical,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            onTap: onAllPatients,
            icon: Icons.people_outline,
            iconColor: AppColors.Turqouoise,
            bgColor: AppColors.Turqouoise.withOpacity(0.08),
            title: 'All Patients',
            subtitle: '$totalPatients total',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            onTap: onCritical,
            icon: Icons.warning_amber_outlined,
            iconColor: const Color(0xFFE05252),
            bgColor: const Color(0xFFE05252).withOpacity(0.08),
            title: 'Critical',
            subtitle: '$criticalCases cases',
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required VoidCallback onTap,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.Black,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: AppColors.Gray),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}