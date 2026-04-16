import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileSettingsCard extends StatelessWidget {
  final VoidCallback onNotifications;
  final VoidCallback onSettings;
  final VoidCallback onMessages;

  const ProfileSettingsCard({
    super.key,
    required this.onNotifications,
    required this.onSettings,
    required this.onMessages,
  });

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
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          _buildSettingsTile(
            context: context,
            icon: Icons.notifications_outlined,
            label: 'Notifications',
            onTap: onNotifications,
          ),
          Divider(height: 1, color: AppColors.Gray2.withValues(alpha: 0.5)),
          _buildSettingsTile(
            context: context,
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: onSettings,
          ),
          Divider(height: 1, color: AppColors.Gray2.withValues(alpha: 0.5)),
          _buildSettingsTile(
            context: context,
            icon: Icons.mail_outline,
            label: 'Messages',
            onTap: onMessages,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
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
                  color: Theme.of(context).colorScheme.onSurface,
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