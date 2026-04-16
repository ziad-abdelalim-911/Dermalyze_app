import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/theme/cubit/theme_cubit.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors that adapt to theme
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey.shade400 : AppColors.Gray,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  return SwitchListTile(
                    title: Text('Dark Mode', style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
                    subtitle: Text('Enable dark theme across the app', style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                    secondary: Icon(
                      themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                      color: AppColors.SkyBlue,
                    ),
                    activeColor: AppColors.Turqouoise,
                    value: themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'General',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey.shade400 : AppColors.Gray,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    textColor: textColor,
                    onTap: () => Navigator.pushNamed(context, '/notifications'),
                  ),
                  Divider(height: 1, color: Theme.of(context).dividerColor),
                  _buildSettingsTile(
                    icon: Icons.lock_outline,
                    title: 'Privacy & Security',
                    textColor: textColor,
                    onTap: () => _showInfoSheet(
                      context,
                      title: 'Privacy & Security',
                      icon: Icons.lock_outline,
                      body:
                          'Your data is encrypted end-to-end.\n\n• Medical images are stored securely.\n• We never share your data with third parties.\n• You can request data deletion from your profile.',
                    ),
                  ),
                  Divider(height: 1, color: Theme.of(context).dividerColor),
                  _buildSettingsTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    textColor: Colors.red,
                    onTap: () async {
                      await TokenStorage().clearToken();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, AppRoutes.login, (route) => false);
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Dermalyze v1.0.0',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.SkyBlue),
      title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  static void _showInfoSheet(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String body,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Got it', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
