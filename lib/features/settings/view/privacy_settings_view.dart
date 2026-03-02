import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: const Color(0xFFF5FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: const Text(
          "Privacy & Settings",
          style: TextStyle(color: Colors.black),
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
                    iconBgColor: Colors.blue.withOpacity(0.12),
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
                    iconBgColor: Colors.purple.withOpacity(0.12),
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
                    iconBgColor: Colors.green.withOpacity(0.12),
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
                    iconBgColor: Colors.blue.withOpacity(0.12),
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
                    iconBgColor: Colors.blue.withOpacity(0.12),
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
                    iconBgColor: Colors.grey.withOpacity(0.12),
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
                iconBgColor: Colors.red.withOpacity(0.12),
                switchColor: Colors.red,
              ),
            ),

            // ===== App Settings =====
            SettingsSectionCard(
              title: "App Settings",
              icon: Icons.settings_outlined,
              headerColor: const Color(0xFF1F2937),
              child: SettingsSwitchTile(
                icon: Icons.dark_mode_outlined,
                title: "Dark Mode",
                subtitle: "Switch to dark theme",
                value: darkMode,
                onChanged: (v) => setState(() => darkMode = v),
                iconColor: Colors.black87,
                iconBgColor: Colors.black12,
                switchColor: Colors.black87,
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
                    onTap: () {},
                  ),
                  SettingsNavTile(
                    icon: Icons.article_outlined,
                    title: "Terms of Service",
                    subtitle: "View terms and conditions",
                    onTap: () {},
                  ),
                  SettingsNavTile(
                    icon: Icons.verified_user_outlined,
                    title: "HIPAA Compliance",
                    subtitle: "Learn about our compliance measures",
                    onTap: () {},
                  ),
                  SettingsNavTile(
                    icon: Icons.delete_outline,
                    title: "Data Deletion Request",
                    subtitle:
                        "Request deletion of your personal data",
                    onTap: () {},
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
}
