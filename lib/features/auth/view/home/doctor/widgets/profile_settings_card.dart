import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileSettingsCard extends StatelessWidget {
  final VoidCallback onNotifications;
  final VoidCallback onPrivacy;
  final VoidCallback onMessages;

  const ProfileSettingsCard({
    super.key,
    required this.onNotifications,
    required this.onPrivacy,
    required this.onMessages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.White,
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
            'Settings',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.Black,
            ),
          ),
          const SizedBox(height: 8),
          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            onTap: onNotifications,
          ),
          Divider(height: 1, color: AppColors.Gray2.withOpacity(0.5)),
          _buildSettingsTile(
            icon: Icons.shield_outlined,
            label: 'Privacy & Security',
            onTap: onPrivacy,
          ),
          Divider(height: 1, color: AppColors.Gray2.withOpacity(0.5)),
          _buildSettingsTile(
            icon: Icons.mail_outline,
            label: 'Messages',
            onTap: onMessages,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: AppColors.Gray3),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.Black,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.Gray),
          ],
        ),
      ),
    );
  }
}