import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/shared/InfoBox.dart';
import 'package:dermalyze/features/shared/SectionCard.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProfileHeader(
              name: "Assem Ahmed",
              accountType: "Patient Account",
            ),

            const SizedBox(height: 16),

            SectionCard(
              title: "Personal Information",
              icon: Icons.person_outline,
              child: Column(
                children: const [
                  InfoRow(
                    icon: Icons.email_outlined,
                    title: "Email",
                    value: "assem.ahmed@email.com",
                  ),
                  Divider(),
                  InfoRow(
                    icon: Icons.phone_outlined,
                    title: "Phone",
                    value: "+1 (555) 123-4567",
                  ),
                  Divider(),
                  InfoRow(
                    icon: Icons.calendar_today_outlined,
                    title: "Date of Birth",
                    value: "March 15, 1990",
                  ),
                  Divider(),
                  InfoRow(
                    icon: Icons.shield_outlined,
                    title: "National ID",
                    value: "12345678901234",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            SectionCard(
              title: "Medical Information",
              icon: Icons.medical_services_outlined,
              child: Column(
                children: const [
                  InfoBox(
                    title: "Allergies",
                    value: "Penicillin",
                    bgColor: Color(0xFFFFF1F1),
                    borderColor: Color(0xFFFECACA),
                    textColor: Colors.red,
                  ),
                  SizedBox(height: 12),
                  InfoBox(
                    title: "Current Diagnosis",
                    value: "Atopic Dermatitis",
                    bgColor: Color(0xFFF0FDFF),
                    borderColor: Color(0xFF5AC8D8),
                    textColor: Colors.blue,
                  ),
                ],
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
                    onTap: () {},
                  ),
                  const Divider(),
                  SettingsTile(
                    icon: Icons.lock_outline,
                    title: "Privacy & Security",
                    onTap: () {},
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
                onPressed: () {},
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
