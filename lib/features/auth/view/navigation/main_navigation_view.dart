import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/home/home_view.dart';
import 'package:flutter/material.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() =>
      _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomeView(),
    const Placeholder(),
    const Placeholder(),
  ]; // Profile Page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}
