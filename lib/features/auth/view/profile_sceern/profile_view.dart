
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:dermalyze/features/shared/info_box.dart';
import 'package:dermalyze/features/shared/section_card.dart';
import 'package:dermalyze/features/shared/info_row.dart';
import 'package:dermalyze/features/shared/profile_header.dart';
import 'package:dermalyze/features/shared/settings_tile.dart';
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
  String _diagnosis = '—';
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
          _diagnosis = user['diagnosis'] ?? '—';
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  ProfileHeader(
                    name: _name,
                    accountType: "Patient Account",
                  ),

                  const SizedBox(height: 16),

                  SectionCard(
                    title: "Personal Information",
                    icon: Icons.person_outline,
                    child: Column(
                      children: [
                        InfoRow(
                          icon: Icons.email_outlined,
                          title: "Email",
                          value: _email,
                        ),
                        const Divider(),
                        InfoRow(
                          icon: Icons.phone_outlined,
                          title: "Phone",
                          value: _phone,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (_diagnosis != '—')
                    SectionCard(
                      title: "Medical Information",
                      icon: Icons.medical_services_outlined,
                      child: InfoBox(
                        title: "Current Diagnosis",
                        value: _diagnosis,
                        bgColor: const Color(0xFFF0FDFF),
                        borderColor: const Color(0xFF5AC8D8),
                        textColor: Colors.blue,
                      ),
                    ),

                  const SizedBox(height: 16),

                  SectionCard(
                    title: "Settings",
                    icon: Icons.settings_outlined,
                    child: Column(
                      children: [
                        SettingsTile(
                          icon: Icons.notifications_outlined,
                          title: "Notifications",
                          onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
                        ),
                        const Divider(),
                        SettingsTile(
                          icon: Icons.settings_outlined,
                          title: "Settings",
                          onTap: () => Navigator.pushNamed(context, AppRoutes.Settings),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}
