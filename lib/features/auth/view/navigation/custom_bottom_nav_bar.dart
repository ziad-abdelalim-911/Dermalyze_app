import 'dart:ui';
import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/chat/logic/conversations_cubit.dart';
import 'package:dermalyze/features/auth/view/chat/view/messages_view.dart';
import 'package:dermalyze/features/auth/view/home/doctor/screens/doctor_home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

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

  Widget _buildNavItem({
    required int index,
    required String icon,
    required String label,
    required bool isDark,
    bool isChat = false,
  }) {
    final isSelected = _currentIndex == index;
    final activeColor = AppColors.SkyBlue;
    final inactiveColor = isDark ? Colors.grey.shade500 : AppColors.Gray;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withOpacity(isDark ? 0.2 : 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isChat
                ? BlocBuilder<ConversationsCubit, ConversationsState>(
                    builder: (context, state) {
                      int totalUnread = 0;
                      if (state is ConversationsLoaded) {
                        totalUnread = state.totalUnreadCount;
                      }

                      return Badge(
                        label: Text(totalUnread > 9 ? '9+' : '$totalUnread'),
                        isLabelVisible: totalUnread > 0,
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ImageIcon(
                          AssetImage(icon),
                          size: 24,
                          color: isSelected ? activeColor : inactiveColor,
                        ),
                      );
                    },
                  )
                : ImageIcon(
                    AssetImage(icon),
                    size: 24,
                    color: isSelected ? activeColor : inactiveColor,
                  ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuint,
              child: isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: activeColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(1.5), // Border thickness
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient2,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(38.5), // Slightly smaller for inner
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Theme.of(context).cardColor.withOpacity(0.85)
                            : Colors.white.withOpacity(0.85),
                      ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildNavItem(
                          index: 0,
                          icon: AppAssets.home_icon,
                          label: 'Home',
                          isDark: isDark,
                        ),
                        _buildNavItem(
                          index: 1,
                          icon: AppAssets.chat_icon,
                          label: 'Chat',
                          isDark: isDark,
                          isChat: true,
                        ),
                        _buildNavItem(
                          index: 2,
                          icon: AppAssets.profile_icon,
                          label: 'Profile',
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}