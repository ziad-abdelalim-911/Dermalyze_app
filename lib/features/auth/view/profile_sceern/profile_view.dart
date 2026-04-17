import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _tokenStorage = TokenStorage();

  String _name = 'Patient';
  String _email = '—';
  String _phone = '—';
  String _birthDate = '—';
  String _nationalId = '—';
  String _diagnosis = '—';
  String _allergies = '—';
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
          _name = user['name'] ?? 'Patient';
          _email = user['email'] ?? '—';
          _phone = user['phone'] ?? '—';
          _birthDate = user['birthDate'] ?? user['dateOfBirth'] ?? '—';
          _nationalId = user['nationalId'] ?? '—';
          _diagnosis = user['diagnosis'] ?? '—';
          _allergies = user['allergies'] ?? '—';
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
    final textSecondary =
        isDark ? Colors.grey.shade400 : const Color(0xFF6B7280);
    final dividerColor = isDark ? Colors.white12 : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF4F6FA),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ── Gradient Header ──────────────────────────────
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
                          // Title row
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.arrow_back_ios_new,
                                    color: Colors.white, size: 16),
                                SizedBox(width: 8),
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
                          const SizedBox(height: 24),
                          // Avatar
                          Container(
                            width: 88,
                            height: 88,
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: Icon(Icons.person_2_outlined,
                                size: 46, color: AppColors.SkyBlue),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Patient Account',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 13),
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
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Personal Information ─────────────────
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
                                icon: Icons.calendar_today_outlined,
                                label: 'Date of Birth',
                                value: _birthDate,
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                                divider: dividerColor,
                                showDivider: true,
                              ),
                              _buildInfoRow(
                                icon: Icons.shield_outlined,
                                label: 'National ID',
                                value: _nationalId,
                                textPrimary: textPrimary,
                                textSecondary: textSecondary,
                                divider: dividerColor,
                                showDivider: false,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Medical Information ──────────────────
                        _buildCard(
                          cardBg: cardBg,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Medical Information',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: textPrimary,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Allergies box (pink)
                              if (_allergies != '—') ...[
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? Colors.red.withValues(alpha: 0.12)
                                        : const Color(0xFFFFF0F0),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.red.withValues(alpha: 0.25),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Allergies',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red.shade400,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _allergies,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],

                              // Current Diagnosis box (blue)
                              if (_diagnosis != '—')
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? AppColors.SkyBlue
                                            .withValues(alpha: 0.12)
                                        : const Color(0xFFF0FDFF),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColors.Turqouoise
                                          .withValues(alpha: 0.4),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Current Diagnosis',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.SkyBlue,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _diagnosis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.SkyBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // لو مفيش diagnosis ولا allergies
                              if (_diagnosis == '—' && _allergies == '—')
                                Center(
                                  child: Text(
                                    'No medical information available',
                                    style: TextStyle(
                                        fontSize: 13, color: textSecondary),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Settings ─────────────────────────────
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
                                showDivider: false,
                                onTap: () => Navigator.pushNamed(
                                    context, AppRoutes.Settings),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Logout Button ─────────────────────────
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
                        style:
                            TextStyle(fontSize: 12, color: textSecondary)),
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
                Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.Gray),
              ],
            ),
          ),
        ),
        if (showDivider) Divider(height: 1, color: divider),
      ],
    );
  }
}
