import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:dermalyze/features/auth/view/chat/view/messages_view.dart';
import 'package:flutter/material.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  final _tokenStorage = TokenStorage();
  String _name = 'Doctor';
  String _email = '—';
  String _phone = '—';
  String _doctorCode = '—';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = await _tokenStorage.getUser();
      if (mounted && user != null) {
        setState(() {
          _name = user['name'] ?? 'Doctor';
          _email = user['email'] ?? '—';
          _phone = user['phone'] ?? '—';
          _doctorCode = user['doctorCode'] ?? '—';
          _isLoading = false;
        });
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    await _tokenStorage.clearToken();
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
          AppRoutes.login, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1F2937);
    final textSecondary = isDark ? Colors.grey.shade400 : const Color(0xFF6B7280);
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F6FA),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ── Gradient Header ─────────────────────────────
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient2,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
                      child: Column(
                        children: [
                          // Back row
                          if (Navigator.canPop(context))
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.arrow_back_ios_new,
                                        color: Colors.white, size: 16),
                                    SizedBox(width: 6),
                                    Text(
                                      'Profile',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: 24),
                          // Avatar circle
                          Container(
                            width: 88,
                            height: 88,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.person_2_outlined,
                                size: 46, color: AppColors.SkyBlue),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Dr. $_name',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Doctor Account',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Body ────────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
                    child: Column(
                      children: [
                        // Personal Information Card
                        _buildCard(
                          cardBg: cardBg,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Personal Information',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                icon: Icons.email_outlined,
                                label: 'Email',
                                value: _email,
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                                divider: dividerColor,
                                showDivider: true,
                              ),
                              _buildInfoRow(
                                icon: Icons.phone_outlined,
                                label: 'Phone',
                                value: _phone,
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                                divider: dividerColor,
                                showDivider: true,
                              ),
                              _buildInfoRow(
                                icon: Icons.shield_outlined,
                                label: 'Specialization',
                                value: 'Dermatology',
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                                divider: dividerColor,
                                showDivider: true,
                              ),
                              _buildInfoRow(
                                icon: Icons.badge_outlined,
                                label: 'License Number',
                                value: _doctorCode != '—'
                                    ? _doctorCode
                                    : 'Not assigned',
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                                divider: dividerColor,
                                showDivider: true,
                              ),
                              _buildInfoRow(
                                icon: Icons.calendar_month_outlined,
                                label: 'Experience',
                                value: '—',
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                                divider: dividerColor,
                                showDivider: false,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Settings Card
                        _buildCard(
                          cardBg: cardBg,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Settings',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              _buildSettingsTile(
                                icon: Icons.notifications_outlined,
                                label: 'Notifications',
                                textPrimary: textPrimary,
                                divider: dividerColor,
                                showDivider: true,
                                onTap: () => Navigator.pushNamed(
                                    context, AppRoutes.notifications),
                              ),
                              _buildSettingsTile(
                                icon: Icons.shield_outlined,
                                label: 'Privacy & Security',
                                textPrimary: textPrimary,
                                divider: dividerColor,
                                showDivider: true,
                                onTap: () => Navigator.pushNamed(
                                    context, AppRoutes.Settings),
                              ),
                              _buildSettingsTile(
                                icon: Icons.mail_outline,
                                label: 'Messages',
                                textPrimary: textPrimary,
                                divider: dividerColor,
                                showDivider: false,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const MessagesView()),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Logout Button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: OutlinedButton.icon(
                            onPressed: _logout,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Color(0xFFE05252), width: 1.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.logout,
                                color: Color(0xFFE05252), size: 20),
                            label: const Text(
                              'Logout',
                              style: TextStyle(
                                color: Color(0xFFE05252),
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────

  Widget _buildCard({required Color cardBg, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color textPrimary,
    required Color textSecondary,
    required Color divider,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: textSecondary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(fontSize: 12, color: textSecondary)),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) Divider(height: 1, color: divider),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String label,
    required Color textPrimary,
    required Color divider,
    required bool showDivider,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
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
                      color: textPrimary,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    size: 14, color: AppColors.Gray),
              ],
            ),
          ),
        ),
        if (showDivider) Divider(height: 1, color: divider),
      ],
    );
  }
}