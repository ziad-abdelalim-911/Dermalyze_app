import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:dermalyze/core/theme/theme_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dermalyze/core/theme/cubit/theme_cubit.dart';
import '../widgets/privacy_info_box.dart';
import '../widgets/settings_nav_tile.dart';
import '../widgets/settings_section_card.dart';
import '../widgets/settings_switch_tile.dart';

class PrivacySettingsView extends StatefulWidget {
  const PrivacySettingsView({super.key});

  @override
  State<PrivacySettingsView> createState() =>
      _PrivacySettingsViewState();
}

class _PrivacySettingsViewState extends State<PrivacySettingsView> {
  // ===== Backend-ready states =====
  bool profileVisible = true;
  bool dataSharing = false;
  bool analyticsEnabled = true;

  bool pushNotifications = true;
  bool emailNotifications = true;
  bool smsNotifications = false;

  bool twoFactorAuth = false;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: context.dynamicTextColorPrimary),
        leading: const BackButton(),
        title: Text(
          "Privacy & Settings",
          style: TextStyle(color: context.dynamicTextColorPrimary),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== Privacy Controls =====
            SettingsSectionCard(
              title: "Privacy Controls",
              icon: Icons.shield_outlined,
              headerColor: const Color(0xFF4ECDC4),
              child: Column(
                children: [
                  SettingsSwitchTile(
                    icon: Icons.visibility_outlined,
                    title: "Profile Visibility",
                    subtitle:
                        "Allow other doctors to view your profile information",
                    value: profileVisible,
                    onChanged: (v) =>
                        setState(() => profileVisible = v),
                    iconColor: Colors.blue,
                    iconBgColor: Colors.blue.withValues(alpha: 0.12),
                    switchColor: AppColors.SkyBlue,
                  ),
                  const SizedBox(height: 12),
                  SettingsSwitchTile(
                    icon: Icons.storage_outlined,
                    title: "Data Sharing",
                    subtitle:
                        "Share anonymized medical data for research",
                    value: dataSharing,
                    onChanged: (v) => setState(() => dataSharing = v),
                    iconColor: Colors.purple,
                    iconBgColor: Colors.purple.withValues(alpha: 0.12),
                    switchColor: AppColors.SkyBlue,
                  ),
                  const SizedBox(height: 12),
                  SettingsSwitchTile(
                    icon: Icons.analytics_outlined,
                    title: "Analytics & Usage Data",
                    subtitle:
                        "Help improve the app by sharing usage data",
                    value: analyticsEnabled,
                    onChanged: (v) =>
                        setState(() => analyticsEnabled = v),
                    iconColor: Colors.green,
                    iconBgColor: Colors.green.withValues(alpha: 0.12),
                    switchColor: AppColors.SkyBlue,
                  ),
                ],
              ),
            ),

            // ===== Notification Preferences =====
            SettingsSectionCard(
              title: "Notification Preferences",
              icon: Icons.notifications_outlined,
              headerColor: const Color(0xFF2563EB),
              child: Column(
                children: [
                  SettingsSwitchTile(
                    icon: Icons.notifications_active_outlined,
                    title: "Push Notifications",
                    subtitle: "Receive alerts and updates",
                    value: pushNotifications,
                    onChanged: (v) =>
                        setState(() => pushNotifications = v),
                    iconColor: Colors.blue,
                    iconBgColor: Colors.blue.withValues(alpha: 0.12),
                    switchColor: AppColors.SkyBlue,
                  ),
                  const SizedBox(height: 12),
                  SettingsSwitchTile(
                    icon: Icons.email_outlined,
                    title: "Email Notifications",
                    subtitle: "Get updates via email",
                    value: emailNotifications,
                    onChanged: (v) =>
                        setState(() => emailNotifications = v),
                    iconColor: Colors.blue,
                    iconBgColor: Colors.blue.withValues(alpha: 0.12),
                    switchColor: AppColors.SkyBlue,
                  ),
                  const SizedBox(height: 12),
                  SettingsSwitchTile(
                    icon: Icons.sms_outlined,
                    title: "SMS Notifications",
                    subtitle: "Receive urgent alerts via SMS",
                    value: smsNotifications,
                    onChanged: (v) =>
                        setState(() => smsNotifications = v),
                    iconColor: Colors.grey,
                    iconBgColor: Colors.grey.withValues(alpha: 0.12),
                    switchColor: AppColors.SkyBlue,
                  ),
                ],
              ),
            ),

            // ===== Security =====
            SettingsSectionCard(
              title: "Security",
              icon: Icons.lock_outline,
              headerColor: Colors.red,
              child: SettingsSwitchTile(
                icon: Icons.security,
                title: "Two-Factor Authentication",
                subtitle: "Add extra security to your account",
                value: twoFactorAuth,
                onChanged: (v) => setState(() => twoFactorAuth = v),
                iconColor: Colors.red,
                iconBgColor: Colors.red.withValues(alpha: 0.12),
                switchColor: Colors.red,
              ),
            ),

            // ===== App Settings =====
            SettingsSectionCard(
              title: "App Settings",
              icon: Icons.settings_outlined,
              headerColor: const Color(0xFF1F2937),
              child: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return SettingsSwitchTile(
                    icon: Icons.dark_mode_outlined,
                    title: "Dark Mode",
                    subtitle: "Switch to dark theme",
                    value: themeMode == ThemeMode.dark,
                    onChanged: (v) => context.read<ThemeCubit>().toggleTheme(),
                    iconColor: Colors.white,
                    iconBgColor: Colors.black12,
                    switchColor: Colors.black87,
                  );
                },
              ),
            ),

            // ===== Legal =====
            SettingsSectionCard(
              title: "Legal & Privacy",
              icon: Icons.description_outlined,
              child: Column(
                children: [
                  SettingsNavTile(
                    icon: Icons.privacy_tip_outlined,
                    title: "Privacy Policy",
                    subtitle: "Read how we handle your data",
                    onTap: () => _showDoc(
                      context,
                      title: 'Privacy Policy',
                      body: 'Dermalyze collects and processes medical images and health data solely to provide AI-powered skin analysis. Your data is encrypted at rest and in transit.\n\nWe do not sell or share personal health information with third parties without your explicit consent.\n\nYou may request a full copy of your stored data or deletion at any time.',
                    ),
                  ),
                  SettingsNavTile(
                    icon: Icons.article_outlined,
                    title: "Terms of Service",
                    subtitle: "View terms and conditions",
                    onTap: () => _showDoc(
                      context,
                      title: 'Terms of Service',
                      body: 'By using Dermalyze, you agree that:\n\n• AI analysis results are intended to assist licensed medical professionals, not replace clinical judgment.\n• You will not upload images of individuals without their consent.\n• Misuse of the platform may result in account suspension.\n\nBy continuing to use the app you agree to these terms.',
                    ),
                  ),
                  SettingsNavTile(
                    icon: Icons.verified_user_outlined,
                    title: "HIPAA Compliance",
                    subtitle: "Learn about our compliance measures",
                    onTap: () => _showDoc(
                      context,
                      title: 'HIPAA Compliance',
                      body: 'Dermalyze is designed to comply with the Health Insurance Portability and Accountability Act (HIPAA).\n\n• Protected Health Information (PHI) is handled according to HIPAA Security Rule requirements.\n• Business Associate Agreements are in place with all third-party service providers.\n• Regular security audits are conducted to maintain compliance.',
                    ),
                  ),
                  SettingsNavTile(
                    icon: Icons.delete_outline,
                    title: "Data Deletion Request",
                    subtitle: "Request deletion of your personal data",
                    onTap: () => _showDoc(
                      context,
                      title: 'Data Deletion Request',
                      body: 'To request deletion of your personal data and medical records:\n\n1. Send an email to: privacy@dermalyze.com\n2. Include your registered email address and full name.\n3. Your account and all associated data will be deleted within 30 days.\n\nNote: This action is irreversible.',
                    ),
                  ),
                ],
              ),
            ),

            const PrivacyInfoBox(
              text:
                  "DERMALYZE is committed to protecting your medical information. "
                  "All data is encrypted and complies with HIPAA regulations. "
                  "We never share your personal health information without your consent.",
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  static void _showDoc(BuildContext context, {required String title, required String body}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (_, ctrl) => Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: ctrl,
                  child: Text(body, style: TextStyle(fontSize: 14, height: 1.6, color: isDark ? Colors.grey.shade300 : Colors.black87)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Close', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
