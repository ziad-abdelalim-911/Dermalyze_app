import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/forgot_password/auth_password_repository.dart';
import 'package:dermalyze/features/auth/view/forgot_password/verify_code_view.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() =>
      _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  bool isEmailSelected = true;
  bool _isSending = false;
  final TextEditingController _controller = TextEditingController();
  final _repo = AuthPasswordRepository();

  Future<void> _sendCode() async {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    setState(() => _isSending = true);
    try {
      await _repo.sendResetCode(value);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VerifyCodeView(email: value),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient2,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ================= Header =================
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).cardColor,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.key,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Reset Password",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "We'll send you a verification code",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ================= Card =================
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: const Text(
                            "Forgot Your Password?",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Center(
                          child: const Text(
                            "Enter your email or mobile number to \n        receive a verification code",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Text(
                          "Recovery Method",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.Black3,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            _RecoveryButton(
                              title: "Email",
                              icon: Icons.email_outlined,
                              isActive: isEmailSelected,
                              onTap: () {
                                setState(() {
                                  isEmailSelected = true;
                                });
                              },
                            ),
                            const SizedBox(width: 12),
                            _RecoveryButton(
                              title: "Phone",
                              icon: Icons.phone_outlined,
                              isActive: !isEmailSelected,
                              onTap: () {
                                setState(() {
                                  isEmailSelected = false;
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Text(
                          isEmailSelected
                              ? "Email Address"
                              : "Phone Number",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 8),

                        TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.black),
                          keyboardType: isEmailSelected
                              ? TextInputType.emailAddress
                              : TextInputType.phone,
                          decoration: InputDecoration(
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                            ),
                            hintText: isEmailSelected
                                ? "example@email.com"
                                : "+1 555 123 4567",
                            prefixIcon: Icon(
                              isEmailSelected
                                  ? Icons.email_outlined
                                  : Icons.phone_outlined,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(
                                color: Color(0xFF2563EB),
                                width: 1.4,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isSending ? null : _sendCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient2,
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.send,
                                      color: Theme.of(context).cardColor,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Send Verification Code",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFBFDBFE),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 18,
                                color: Color(0xFF2563EB),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  "Security Note:\nThe code will expire in 10 minutes for your protection.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= Recovery Button =================
class _RecoveryButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _RecoveryButton({
    required this.title,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.primaryGradient2 : null,
            color: isActive ? null : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
