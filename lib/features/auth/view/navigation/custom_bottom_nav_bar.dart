import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/chat/view/messages_view.dart';
import 'package:dermalyze/features/auth/view/home/doctor/screens/doctor_home_screen.dart';
import 'package:dermalyze/features/auth/view/home/doctor/screens/doctor_profile_screen.dart';
import 'package:dermalyze/features/auth/view/home/home_view.dart';
import 'package:dermalyze/features/auth/view/profile_sceern/profile_view.dart';
import 'package:dermalyze/features/settings/view/settings_screen.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  final bool isDoctor;

  const CustomBottomNavBar({
    super.key,
    this.isDoctor = false,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _currentIndex = 0;

  List<Widget> get _pages => widget.isDoctor
      ? [
          const DoctorHomeScreen(),
          const MessagesView(),
          const DoctorProfileScreen(),
          const SettingsScreen(),
        ]
      : [
          const HomeView(),
          const MessagesView(),
          const ProfileView(),
          const SettingsScreen(),
        ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).cardColor : Colors.white,
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedItemColor: AppColors.SkyBlue,
          unselectedItemColor:
              isDark ? Colors.grey.shade600 : AppColors.Gray,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(const AssetImage(AppAssets.home_icon), size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(const AssetImage(AppAssets.chat_icon), size: 24),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                  const AssetImage(AppAssets.profile_icon), size: 24),
              label: 'Profile',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined, size: 24),
              activeIcon: Icon(Icons.settings, size: 24),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}