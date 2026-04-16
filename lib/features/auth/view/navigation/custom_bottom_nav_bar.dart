import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/chat/view/messages_view.dart';
import 'package:dermalyze/features/auth/view/home/doctor/screens/doctor_home_screen.dart';
import 'package:dermalyze/features/auth/view/home/doctor/screens/doctor_profile_screen.dart';
import 'package:dermalyze/features/auth/view/home/home_view.dart';
import 'package:dermalyze/features/auth/view/profile_sceern/profile_view.dart';
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
        ]
      : [
          const HomeView(),
          const MessagesView(),
          const ProfileView(),
        ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Theme.of(context).cardColor
              : Colors.white,
          boxShadow: [
            if (Theme.of(context).brightness == Brightness.light)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
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
          unselectedItemColor: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey.shade500 
              : AppColors.Gray,
          items: const [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(AppAssets.home_icon), size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(AppAssets.chat_icon), size: 24),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage(AppAssets.profile_icon), size: 24),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}