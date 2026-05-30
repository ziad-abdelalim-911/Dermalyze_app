import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PatientItemCard extends StatelessWidget {
  final String id;
  final String name;
  final String diagnosis;
  final String statusBadge;
  final String qualityBadge;
  final double recoveryRate;
  final String lastVisit;
  final int age;
  final VoidCallback onTap;
  final VoidCallback? onChatTap;

  const PatientItemCard({
    super.key,
    required this.id,
    required this.name,
    required this.diagnosis,
    required this.statusBadge,
    required this.qualityBadge,
    required this.recoveryRate,
    required this.lastVisit,
    required this.age,
    required this.onTap,
    this.onChatTap,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'improving':
        return const Color(0xFF4CAF50);
      case 'stable':
        return const Color(0xFF4A90E2);
      case 'recovering':
        return const Color(0xFF4ECDC4);
      case 'critical':
        return const Color(0xFFE05252);
      default:
        return AppColors.Gray;
    }
  }

  Color _qualityColor(String quality) {
    switch (quality.toLowerCase()) {
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

  Color _progressColor(double rate) {
    if (rate >= 0.7) return const Color(0xFF4CAF50);
    if (rate >= 0.4) return const Color(0xFF4A90E2);
    return const Color(0xFFE05252);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person_outline,
                color: AppColors.SkyBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Arrow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.Black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          if (onChatTap != null)
                            GestureDetector(
                              onTap: onChatTap,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.SkyBlue.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.chat_bubble_outline, size: 16, color: AppColors.SkyBlue),
                              ),
                            ),
                          if (onChatTap != null)
                            const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: AppColors.Gray,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    diagnosis,
                    style: TextStyle(fontSize: 12, color: AppColors.Gray),
                  ),
                  const SizedBox(height: 8),
                  // Status + Quality Badges
                  Row(
                    children: [
                      _buildBadge(statusBadge, _statusColor(statusBadge)),
                      const SizedBox(width: 6),
                      _buildBadge(qualityBadge, _qualityColor(qualityBadge)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Recovery Rate Label
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recovery Rate',
                        style: TextStyle(fontSize: 11, color: AppColors.Gray),
                      ),
                      Text(
                        '${(recoveryRate * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _progressColor(recoveryRate),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: recoveryRate,
                      minHeight: 5,
                      backgroundColor: AppColors.Gray2.withOpacity(0.4),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _progressColor(recoveryRate),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Last Visit + Age
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Last visit: $lastVisit',
                        style:
                            TextStyle(fontSize: 11, color: AppColors.Gray),
                      ),
                      Text(
                        'Age: $age',
                        style:
                            TextStyle(fontSize: 11, color: AppColors.Gray),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}