import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/home/home_view.dart';
import 'package:dermalyze/features/auth/view/profile_sceern/profile_view.dart';
import 'package:flutter/material.dart';

import '../chat/view/messages_view.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() =>
      _MainNavigationViewState();
}

class _MainNavigationViewState extends State<CustomBottomNavBar> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomeView(),
    MessagesView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: pages),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient1,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },

          selectedItemColor: AppColors.SkyBlue,

          unselectedItemColor: AppColors.Gray,

          items: const [
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage(AppAssets.home_icon),
                size: 24,
              ),
              label: "Home",
            ),

            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage(AppAssets.chat_icon),
                size: 24,
              ),
              label: "Chat",
            ),

            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage(AppAssets.profile_icon),
                size: 24,
              ),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
