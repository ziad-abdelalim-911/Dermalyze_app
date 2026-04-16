import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'core/routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    try {
      final tokenStorage = TokenStorage();
      final token = await tokenStorage.getToken();

      if (token != null && token.isNotEmpty) {
        // المستخدم logged in — اعرف دوره
        final user = await tokenStorage.getUser();
        final role = user?['role'] ?? 'patient';

        if (!mounted) return;
        if (role == 'doctor') {
          Navigator.pushReplacementNamed(context, AppRoutes.doctorHome);
        } else {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.bottomNavBar,
            arguments: false, // patient
          );
        }
      } else {
        // مفيش token — روح للـ onboarding
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    } catch (_) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Column(
        children: [
          const Spacer(),
          Center(child: SvgPicture.asset(AppAssets.Logo, width: 190)),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: const SpinKitRing(color: Colors.grey, size: 80),
          ),
        ],
      ),
    );
  }
}
