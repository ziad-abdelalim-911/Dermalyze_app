import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/login/AccountTypeCard.dart';
import 'package:dermalyze/features/auth/view/login/Patient_SignUp.dart';
import 'package:dermalyze/features/auth/view/login/doctor_SignUp.dart';
import 'package:dermalyze/features/auth/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:dermalyze/core/theme/theme_extensions.dart';
import 'package:flutter_svg/flutter_svg.dart' show SvgPicture;

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.dynamicBgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 94),

                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient2,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppAssets.Icon_register_1,
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "DERMALYZE",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                      foreground: Paint()
                        ..shader =
                            LinearGradient(
                              colors: const [
                                Color(0xFF4A90E2),
                                Color(0xFF4DC1CA),
                              ],
                            ).createShader(
                              const Rect.fromLTWH(0, 0, 220, 36),
                            ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "AI-Powered Skin Monitoring",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: context.dynamicTextColorSecondary,
                    ),
                  ),

                  const SizedBox(height: 48),

                  Text(
                    "Register As",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 30,
                      color: context.dynamicTextColorPrimary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Choose your account type to continue",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: context.dynamicTextColorSecondary,
                    ),
                  ),

                  SizedBox(height: 32),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientSignup(),
                        ),
                      );
                    },
                    child: AccountTypeCard(
                      iconPath: AppAssets.Icon_patient,
                      navigateTo: PatientSignup(),
                      title: "Patient",
                      subtitle:
                          "I'm seeking dermatological care and monitoring",
                      features: const [
                        "Track Conditions",
                        "Chat with Doctor",
                        "View Progress",
                        "AI Analysis",
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorSignup(),
                        ),
                      );
                    },
                    child: AccountTypeCard(
                      title: "Doctor",
                      subtitle:
                          "I'm a dermatologist managing patients",
                      features: [
                        "Manage Patients",
                        "Review Analysis",
                        "Track Cases",
                        "Prescribe Care",
                      ],
                      iconPath: AppAssets.Icon_doctor,
                      navigateTo: DoctorSignup(),
                    ),
                  ),

                  SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: context.dynamicTextColorSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginView(),
                            ),
                          );
                        },
                        child: const Text(
                          "Login here",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
