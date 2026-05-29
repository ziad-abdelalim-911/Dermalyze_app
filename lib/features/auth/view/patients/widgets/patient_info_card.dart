import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PatientInfoCard extends StatelessWidget {
  final String name;
  final String diagnosis;
  final String quality;
  final String lastVisit;
  final String recoveryRate;

  final String improvement;

  const PatientInfoCard({
    super.key,
    required this.name,
    required this.diagnosis,
    required this.quality,
    required this.lastVisit,
    required this.recoveryRate,
    this.improvement = '',
  });

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
          // Name + Quality Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: _qualityColor(quality).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Quality: $quality',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _qualityColor(quality),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Diagnosis
          Text(
            diagnosis,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.SkyBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Theme.of(context).dividerColor, height: 1),
          const SizedBox(height: 16),
          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStat(
                  context: context,
                  icon: Icons.calendar_today_outlined,
                  label: 'Last Visit',
                  value: lastVisit,
                  valueColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStat(
                  context: context,
                  icon: Icons.show_chart,
                  label: 'Recovery Rate',
                  value: recoveryRate,
                  valueColor: AppColors.Turqouoise,
                ),
              ),
              if (improvement.isNotEmpty) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStat(
                    context: context,
                    icon: Icons.trending_up,
                    label: 'Improvement',
                    value: improvement.contains('+') || improvement.contains('-') 
                        ? improvement 
                        : '+$improvement',
                    valueColor: AppColors.SkyBlue,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.Gray),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: AppColors.Gray, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
