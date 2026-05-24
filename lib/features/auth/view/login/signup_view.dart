import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/shared/custem_txtfield.dart';
import 'package:dermalyze/features/shared/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:gap/gap.dart';
import 'package:dermalyze/core/theme/theme_extensions.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  // Controllers
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController confirmPassCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    passCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }

  // Password Conditions
  bool get _isLengthOk => passCtrl.text.length >= 8;
  bool get _hasUppercase => passCtrl.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => passCtrl.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecialChar =>
      passCtrl.text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

  @override
  Widget build(BuildContext context) {
    final _ = MediaQuery.of(context).size; // size available if needed

    return Container(
      decoration: BoxDecoration(
        gradient: context.dynamicBgGradient,
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(48),

                // ⬅ Back
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppAssets.ArrowLeft,
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 6),
                          CustomText(
                            text: 'Back',
                            size: 16,
                            color: AppColors.SkyBlue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


                const Gap(48),

                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: 'Create Account',
                      weight: FontWeight.w600,
                      size: 19,
                    ),
                  ),
                ),

                const Gap(8),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: 'Join us for better skin health care',
                      weight: FontWeight.w400,
                      size: 16,
                      color: AppColors.Gray,
                    ),
                  ),
                ),

                const Gap(32),

                // FORM
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      CustemTxtfield(
                        prefixIcon: SvgPicture.asset(
                          AppAssets.User,
                          width: 18,
                          height: 16,
                        ),
                        hintText: 'Full name',
                        isPassword: false,
                        controller: nameCtrl,
                      ),

                      const Gap(16),

                      CustemTxtfield(
                        prefixIcon: SvgPicture.asset(
                          AppAssets.Massage,
                          width: 18,
                          height: 16,
                        ),
                        hintText: 'Email address',
                        isPassword: false,
                        controller: emailCtrl,
                      ),

                      const Gap(16),

                      CustemTxtfield(
                        prefixIcon: SvgPicture.asset(
                          AppAssets.Call,
                          width: 18,
                          height: 16,
                        ),
                        hintText: 'Phone number',
                        isPassword: false,
                        controller: phoneCtrl,
                      ),

                      const Gap(16),

                      CustemTxtfield(
                        prefixIcon: SvgPicture.asset(
                          AppAssets.Lock,
                          width: 18,
                          height: 16,
                        ),
                        hintText: 'Password (min 8 characters)',
                        isPassword: true,
                        controller: passCtrl,
                      ),

                      const Gap(16),

                      CustemTxtfield(
                        prefixIcon: SvgPicture.asset(
                          AppAssets.Lock,
                          width: 18,
                          height: 16,
                        ),
                        hintText: 'Confirm password',
                        isPassword: true,
                        controller: confirmPassCtrl,
                      ),

                      const Gap(16),

                      // ✔ Password Rules Box (AFTER Confirm Password)
                      PasswordRequirementsBox(
                        isLengthOk: _isLengthOk,
                        hasUppercase: _hasUppercase,
                        hasNumber: _hasNumber,
                        hasSpecialChar: _hasSpecialChar,
                      ),

                      const Gap(24),

                      // Continue Button
                      SizedBox(
                        height: 57,
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(context, AppRoutes.register),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient2,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.White,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Gap(23),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.Gray,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.SkyBlue,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Gap(48),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------- Password Requirements -------- //

class PasswordRequirementsBox extends StatelessWidget {
  final bool isLengthOk;
  final bool hasUppercase;
  final bool hasNumber;
  final bool hasSpecialChar;

  const PasswordRequirementsBox({
    super.key,
    required this.isLengthOk,
    required this.hasUppercase,
    required this.hasNumber,
    required this.hasSpecialChar,
  });

  Widget _row(BuildContext context, bool ok, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const Color checkColor = Color(0xFF34C759); // green check
    final Color inactiveDot = isDark ? Colors.grey.shade600 : const Color(0xFFC2CDD9); // inactive circle
    final Color bodyColor = isDark ? Colors.grey.shade400 : const Color(0xFF4A5568);

    return Row(
      children: [
        if (ok)
          const Icon(
            Icons.check_circle,
            size: 18,
            color: checkColor,
          )
        else
          Icon(
            Icons.radio_button_unchecked,
            size: 18,
            color: inactiveDot,
          ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: ok ? (isDark ? Colors.white : const Color(0xFF1E2D3D)) : bodyColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color boxBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF0F7FF);
    final Color border20 = isDark ? Colors.white24 : const Color(0x334A90E2);
    final Color titleColor = isDark ? Colors.white : const Color(0xFF1E2D3D);

    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: boxBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border20, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Password must contain:",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const Gap(12),
          _row(context, isLengthOk, "At least 8 characters"),
          const Gap(8),
          _row(context, hasUppercase, "One uppercase letter"),
          const Gap(8),
          _row(context, hasNumber, "One number"),
          const Gap(8),
          _row(context, hasSpecialChar, "One special character"),
        ],
      ),
    );
  }
}
