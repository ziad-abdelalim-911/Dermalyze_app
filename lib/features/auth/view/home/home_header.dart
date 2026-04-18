import 'package:dermalyze/features/auth/view/notifications/notifications_cubit.dart';
import 'package:dermalyze/features/auth/view/notifications/notifications_view.dart';
import 'package:dermalyze/features/settings/view/privacy_settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';

class HomeHeader extends StatefulWidget {
  final String userName;
  final String lastCheckup;
  final String nextVisit;

  const HomeHeader({
    super.key,
    required this.userName,
    this.lastCheckup = '—',
    this.nextVisit = '—',
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient2,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome back,",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    SizedBox(height: 6),
                    Text(
                      widget.userName,
                      style: TextStyle(
                        color: Theme.of(context).cardColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  BlocBuilder<NotificationsCubit, NotificationsState>(
                    builder: (context, state) {
                      int unreadCount = 0;
                      if (state is NotificationsLoaded) {
                        unreadCount = state.unreadCount;
                      }

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _circleIcon(
                            Icons.notifications_none,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NotificationsView(),
                                ),
                              );
                            },
                          ),
                          if (unreadCount > 0)
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Center(
                                  child: Text(
                                    unreadCount > 9 ? '9+' : '$unreadCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(width: 10),

                  _circleIcon(
                    Icons.settings_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PrivacySettingsView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _InfoMiniCard(
                  title: "Last Checkup",
                  value: widget.lastCheckup,
                  icon: Icons.monitor_heart_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _InfoMiniCard(
                  title: "Next Visit",
                  value: widget.nextVisit,
                  icon: Icons.description_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

/// ================= MINI CARD =================
class _InfoMiniCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoMiniCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
