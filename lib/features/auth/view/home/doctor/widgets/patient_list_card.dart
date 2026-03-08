import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PatientListItem {
  final String name;
  final String diagnosis;
  final String qualityBadge;
  final String statusBadge;
  final double recoveryRate;
  final String lastVisit;

  const PatientListItem({
    required this.name,
    required this.diagnosis,
    required this.qualityBadge,
    required this.statusBadge,
    required this.recoveryRate,
    required this.lastVisit,
  });
}

class PatientListCard extends StatelessWidget {
  final List<PatientListItem> patients;
  final ValueChanged<PatientListItem> onPatientTap;

  const PatientListCard({
    super.key,
    required this.patients,
    required this.onPatientTap,
  });

  Color _qualityColor(String badge) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
        children: patients
            .map(
              (p) => Column(
                children: [
                  _buildPatientItem(context, p),
                  if (p != patients.last)
                    Divider(
                      height: 1,
                      color: AppColors.Gray2.withOpacity(0.5),
                      indent: 16,
                      endIndent: 16,
                    ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildPatientItem(BuildContext context, PatientListItem patient) {
    return InkWell(
      onTap: () => onPatientTap(patient),
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name + Badges Row
            Row(
              children: [
                Text(
                  patient.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.Black,
                  ),
                ),
                const SizedBox(width: 8),
                _buildBadge(
                  patient.qualityBadge,
                  _qualityColor(patient.qualityBadge),
                ),
                const Spacer(),
                _buildStatusBadge(
                  patient.statusBadge,
                  _statusColor(patient.statusBadge),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              patient.diagnosis,
              style: TextStyle(fontSize: 12, color: AppColors.Gray),
            ),
            const SizedBox(height: 10),
            // Recovery Rate Row
            Row(
              children: [
                Text(
                  'Recovery Rate ',
                  style: TextStyle(fontSize: 12, color: AppColors.Gray),
                ),
                Text(
                  '${(patient.recoveryRate * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.SkyBlue,
                  ),
                ),
                const Spacer(),
                Text(
                  patient.lastVisit,
                  style: TextStyle(fontSize: 11, color: AppColors.Gray),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: patient.recoveryRate,
                minHeight: 5,
                backgroundColor: AppColors.Gray2.withOpacity(0.4),
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.SkyBlue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
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

  Widget _buildStatusBadge(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}