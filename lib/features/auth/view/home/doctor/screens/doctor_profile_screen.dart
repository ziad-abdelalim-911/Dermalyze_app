import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/profile_info_card.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/profile_settings_card.dart';
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

  Future<void> _logout(BuildContext context) async {
    await _tokenStorage.clearToken();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient2,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
                child: Column(
                  children: [
                    // Back Button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back,
                                color: Colors.white, size: 20),
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
                    const SizedBox(height: 20),
                    // Avatar
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_outline,
                        size: 48,
                        color: AppColors.SkyBlue,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Doctor Name — Real from token ✅
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Dr. $_name',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const SizedBox(height: 4),
                    Text(
                      _doctorCode != '—' ? _doctorCode : 'Doctor Account',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
              child: Column(
                children: [
                  ProfileInfoCard(
                    email: _email,
                    phone: '—',
                    specialization: 'Dermatology',
                    licenseNumber: _doctorCode,
                    experience: '—',
                  ),
                  const SizedBox(height: 16),
                  ProfileSettingsCard(
                    onNotifications: () =>
                        Navigator.pushNamed(context, AppRoutes.notifications),
                    onSettings: () => Navigator.pushNamed(context, AppRoutes.Settings),
                    onMessages: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MessagesView()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildLogoutButton(context),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton.icon(
          onPressed: () => _logout(context),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFE05252), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: const Icon(Icons.logout, color: Color(0xFFE05252), size: 20),
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
    );
  }
}