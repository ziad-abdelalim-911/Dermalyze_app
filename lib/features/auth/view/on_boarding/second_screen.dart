import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/login/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient1,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (c) => RegisterView(),
                      ),
                    );
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.Gray,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 150),

              /// Icon
              Container(
                height: 126,
                width: 126,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: AppColors.primaryGradient2,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.Icon_intro_2,
                    height: 64,
                    width: 64,
                  ),
                ),
              ),

              SizedBox(height: 24),

              /// Title
              Text(
                "DERMALYZE",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                  foreground: Paint()
                    ..shader =
                        LinearGradient(
                          colors: [
                            Color(0xFF4A90E2),
                            Color(0xFF4DC1CA),
                          ],
                        ).createShader(
                          const Rect.fromLTWH(0, 0, 220, 36),
                        ),
                ),
              ),

              SizedBox(height: 5),

              Text(
                "Track Your Progress",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                ),
              ),

              SizedBox(height: 5),

              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: Text(
                  "Monitor recovery rates and see\n improvements over time with detailed analytics",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.31,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
