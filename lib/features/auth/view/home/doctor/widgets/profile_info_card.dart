import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final String email;
  final String phone;
  final String specialization;
  final String licenseNumber;
  final String experience;

  const ProfileInfoCard({
    super.key,
    required this.email,
    required this.phone,
    required this.specialization,
    required this.licenseNumber,
    required this.experience,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
          Text(
            'Personal Information',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(context, Icons.email_outlined, 'Email', email),
          _buildDivider(),
          _buildInfoRow(context, Icons.phone_outlined, 'Phone', phone),
          _buildDivider(),
          _buildInfoRow(context, Icons.shield_outlined, 'Specialization', specialization),
          _buildDivider(),
          _buildInfoRow(context, Icons.shield_outlined, 'License Number', licenseNumber),
          _buildDivider(),
          _buildInfoRow(context, Icons.calendar_today_outlined, 'Experience', experience),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.Gray3),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: AppColors.Gray3),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: AppColors.Gray2.withOpacity(0.2));
  }
}