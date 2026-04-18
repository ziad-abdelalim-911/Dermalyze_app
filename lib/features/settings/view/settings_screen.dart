import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:dermalyze/core/theme/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Privacy Controls
  bool _profileVisibility = true;
  bool _dataSharing = false;
  bool _analyticsData = true;

  // Notification Preferences
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;

  // Security
  bool _twoFactor = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F6FA);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSecondary = isDark ? Colors.grey.shade400 : const Color(0xFF6A7282);
    final dividerColor = isDark ? Colors.white12 : Colors.grey.shade200;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: textPrimary, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy & Settings',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
            ),
            Text(
              'Manage your preferences',
              style: TextStyle(fontSize: 12, color: textSecondary),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            // ── Privacy Controls ──────────────────────────────────
            _buildSectionHeader(
              icon: Icons.shield_outlined,
              label: 'Privacy Controls',
              gradient: AppColors.primaryGradient2,
            ),
            const SizedBox(height: 8),
            _buildCard(
              cardBg: cardBg,
              dividerColor: dividerColor,
              children: [
                _buildSwitchTile(
                  icon: Icons.visibility_outlined,
                  iconColor: AppColors.SkyBlue,
                  title: 'Profile Visibility',
                  subtitle: 'Allow other doctors to view your profile information',
                  extraNote: "Your profile is visible to verified healthcare providers in the network",
                  value: _profileVisibility,
                  onChanged: (v) => setState(() => _profileVisibility = v),
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  showDivider: true,
                ),
                _buildSwitchTile(
                  icon: Icons.share_outlined,
                  iconColor: const Color(0xFF8B5CF6),
                  title: 'Data Sharing',
                  subtitle: 'Share anonymized medical data for research and improving AI models',
                  value: _dataSharing,
                  onChanged: (v) => setState(() => _dataSharing = v),
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  showDivider: true,
                ),
                _buildSwitchTile(
                  icon: Icons.bar_chart_outlined,
                  iconColor: const Color(0xFF10B981),
                  title: 'Analytics & Usage Data',
                  subtitle: 'Help us improve the app by sharing usage statistics',
                  value: _analyticsData,
                  onChanged: (v) => setState(() => _analyticsData = v),
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  showDivider: false,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Notification Preferences ──────────────────────────
            _buildSectionHeader(
              icon: Icons.notifications_outlined,
              label: 'Notification Preferences',
              gradient: AppColors.primaryGradient2,
            ),
            const SizedBox(height: 8),
            _buildCard(
              cardBg: cardBg,
              dividerColor: dividerColor,
              children: [
                _buildSwitchTile(
                  icon: Icons.notifications_active_outlined,
                  iconColor: AppColors.SkyBlue,
                  title: 'Push Notifications',
                  subtitle: 'Receive alerts for messages and updates',
                  value: _pushNotifications,
                  onChanged: (v) => setState(() => _pushNotifications = v),
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  showDivider: true,
                ),
                _buildSwitchTile(
                  icon: Icons.email_outlined,
                  iconColor: AppColors.SkyBlue,
                  title: 'Email Notifications',
                  subtitle: 'Get updates via email',
                  value: _emailNotifications,
                  onChanged: (v) => setState(() => _emailNotifications = v),
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  showDivider: true,
                ),
                _buildSwitchTile(
                  icon: Icons.sms_outlined,
                  iconColor: AppColors.SkyBlue,
                  title: 'SMS Notifications',
                  subtitle: 'Receive text messages for urgent alerts',
                  value: _smsNotifications,
                  onChanged: (v) => setState(() => _smsNotifications = v),
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  showDivider: false,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Security ─────────────────────────────────────────
            _buildSectionHeader(
              icon: Icons.lock_outline,
              label: 'Security',
              color: Colors.red.shade600,
            ),
            const SizedBox(height: 8),
            _buildCard(
              cardBg: cardBg,
              dividerColor: dividerColor,
              children: [
                _buildSwitchTile(
                  icon: Icons.security_outlined,
                  iconColor: Colors.red.shade400,
                  title: 'Two-Factor Authentication',
                  subtitle: 'Add an extra layer of security to your account',
                  value: _twoFactor,
                  onChanged: (v) => setState(() => _twoFactor = v),
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  showDivider: false,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── App Settings ─────────────────────────────────────
            _buildSectionHeader(
              icon: Icons.settings_outlined,
              label: 'App Settings',
              color: const Color(0xFF1F2937),
              colorDark: const Color(0xFF334155),
            ),
            const SizedBox(height: 8),
            _buildCard(
              cardBg: cardBg,
              dividerColor: dividerColor,
              children: [
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (ctx, themeMode) {
                    return _buildSwitchTile(
                      icon: Icons.dark_mode_outlined,
                      iconColor: AppColors.SkyBlue,
                      title: 'Dark Mode',
                      subtitle: 'Switch to dark theme',
                      value: themeMode == ThemeMode.dark,
                      onChanged: (_) => ctx.read<ThemeCubit>().toggleTheme(),
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      dividerColor: dividerColor,
                      showDivider: false,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Legal & Privacy ───────────────────────────────────
            _buildSectionHeader(
              icon: Icons.article_outlined,
              label: 'Legal & Privacy',
              color: textPrimary,
              colorDark: const Color(0xFF334155),
            ),
            const SizedBox(height: 8),
            _buildCard(
              cardBg: cardBg,
              dividerColor: dividerColor,
              children: [
                _buildNavTile(
                  icon: Icons.article_outlined,
                  iconColor: AppColors.SkyBlue,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy and data handling directives',
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  showDivider: true,
                  onTap: () => _showInfoSheet(
                    context,
                    title: 'Privacy Policy',
                    icon: Icons.article_outlined,
                    body:
                        'We are committed to protecting your medical information.\n\n• All data is encrypted and stored securely.\n• We never share your personal health information without your explicit consent.\n• You may request a copy of your data at any time.',
                  ),
                ),
                _buildNavTile(
                  icon: Icons.gavel_outlined,
                  iconColor: AppColors.SkyBlue,
                  title: 'Terms of Service',
                  subtitle: 'View terms and conditions',
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  showDivider: true,
                  onTap: () => _showInfoSheet(
                    context,
                    title: 'Terms of Service',
                    icon: Icons.gavel_outlined,
                    body:
                        'By using Dermalyze, you agree to use this app for lawful purposes only. Medical information is provided for professional use by licensed healthcare providers.',
                  ),
                ),
                _buildNavTile(
                  icon: Icons.health_and_safety_outlined,
                  iconColor: AppColors.SkyBlue,
                  title: 'HIPAA Compliance',
                  subtitle: 'Learn about our HIPAA compliance measures',
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  showDivider: true,
                  onTap: () => _showInfoSheet(
                    context,
                    title: 'HIPAA Compliance',
                    icon: Icons.health_and_safety_outlined,
                    body:
                        'Dermalyze complies with all HIPAA regulations.\n\n• Data is encrypted at rest and in transit.\n• Access logs are maintained for all PHI access.\n• Breach notification procedures are in place.',
                  ),
                ),
                _buildNavTile(
                  icon: Icons.delete_outline,
                  iconColor: Colors.red.shade400,
                  title: 'Data Deletion Request',
                  subtitle: 'Request deletion of all your personal data',
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  showDivider: false,
                  onTap: () => _showDeleteConfirm(context),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Logout ────────────────────────────────────────────
            _buildCard(
              cardBg: cardBg,
              dividerColor: dividerColor,
              children: [
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red.shade400),
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.red.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () async {
                    await TokenStorage().clearToken();
                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                          AppRoutes.login, (route) => false);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Your Privacy Matters ─────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.SkyBlue.withValues(alpha: 0.15)
                    : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.SkyBlue.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.SkyBlue.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shield_outlined,
                      color: AppColors.SkyBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Privacy Matters',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.SkyBlue,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'DERMALYZE is committed to protecting your medical information. All data is encrypted and complies with HIPAA regulations. We never share your personal health information without your explicit consent.',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.grey.shade300
                                : const Color(0xFF374151),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Text(
              'Dermalyze v1.0.0',
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── Section Header ───────────────────────────────────────────
  Widget _buildSectionHeader({
    required IconData icon,
    required String label,
    LinearGradient? gradient,
    Color? color,
    Color? colorDark,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor =
        isDark && colorDark != null ? colorDark : (color ?? AppColors.SkyBlue);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? effectiveColor : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).cardColor, size: 18),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ── Card Container ───────────────────────────────────────────
  Widget _buildCard({
    required Color cardBg,
    required Color dividerColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // ── Switch Tile ──────────────────────────────────────────────
  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    String? extraNote,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color textPrimary,
    required Color textSecondary,
    required Color dividerColor,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: textSecondary),
                    ),
                    if (extraNote != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        extraNote,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.SkyBlue.withValues(alpha: 0.85),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.Turqouoise,
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, indent: 68, endIndent: 16, color: dividerColor),
      ],
    );
  }

  // ── Nav Tile (arrow) ─────────────────────────────────────────
  Widget _buildNavTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color textPrimary,
    required Color textSecondary,
    required Color dividerColor,
    required bool showDivider,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style:
                            TextStyle(fontSize: 12, color: textSecondary),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 14, color: textSecondary),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, indent: 68, endIndent: 16, color: dividerColor),
      ],
    );
  }

  // ── Bottom Sheets ─────────────────────────────────────────────
  void _showInfoSheet(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String body,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.SkyBlue),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              body,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.SkyBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Got it',
                    style: TextStyle(color: Theme.of(context).cardColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Account Data?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'This action cannot be undone. All your personal data and medical records will be permanently deleted.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade500,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Data deletion request submitted successfully.')),
              );
            },
            child:
                const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
