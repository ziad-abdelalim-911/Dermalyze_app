import 'package:dermalyze/features/auth/view/forgot_password/auth_password_repository.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CreateNewPasswordView extends StatefulWidget {
  final String email;
  final String code;
  const CreateNewPasswordView({
    super.key,
    this.email = '',
    this.code = '',
  });

  @override
  State<CreateNewPasswordView> createState() =>
      _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState
    extends State<CreateNewPasswordView> {
  final TextEditingController _passwordController =
      TextEditingController();
  final TextEditingController _confirmController =
      TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirm = true;
  bool _isSubmitting = false;
  final _repo = AuthPasswordRepository();

  // ===== Password Rules =====
  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasNumber = false;
  bool hasSpecialChar = false;
  bool passwordsMatch = false;

  void _validatePassword(String value) {
    setState(() {
      hasMinLength = value.length >= 8;
      hasUppercase = value.contains(RegExp(r'[A-Z]'));
      hasLowercase = value.contains(RegExp(r'[a-z]'));
      hasNumber = value.contains(RegExp(r'[0-9]'));
      hasSpecialChar = value.contains(
        RegExp(r'[!@#\$%^&*(),.?":{}|<>]'),
      );

      passwordsMatch =
          value.isNotEmpty && value == _confirmController.text;
    });
  }

  bool get isFormValid =>
      hasMinLength &&
      hasUppercase &&
      hasLowercase &&
      hasNumber &&
      hasSpecialChar &&
      passwordsMatch;

  Future<void> _submit() async {
    final newPassword = _passwordController.text;
    setState(() => _isSubmitting = true);
    try {
      await _repo.resetPassword(
        email: widget.email,
        code: widget.code,
        newPassword: newPassword,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successfully! Please log in.'),
            backgroundColor: Color(0xFF4ECDC4),
          ),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: ${e.toString()}'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient2,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ===== Back =====
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  // ===== Icon =====
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.lock_outline,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Create New Password",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "Choose a strong, secure password",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ===== Card =====
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "Set New Password",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text("New Password"),
                        const SizedBox(height: 6),
                        _passwordField(
                          controller: _passwordController,
                          hidden: _hidePassword,
                          toggle: () => setState(
                            () => _hidePassword = !_hidePassword,
                          ),
                          hint: "Enter new password",
                          onChanged: _validatePassword,
                        ),

                        const SizedBox(height: 16),

                        const Text("Confirm Password"),
                        const SizedBox(height: 6),
                        _passwordField(
                          controller: _confirmController,
                          hidden: _hideConfirm,
                          toggle: () => setState(
                            () => _hideConfirm = !_hideConfirm,
                          ),
                          hint: "Re-enter new password",
                          onChanged: (_) => _validatePassword(
                            _passwordController.text,
                          ),
                        ),

                        const SizedBox(height: 20),

                        _rule("At least 8 characters", hasMinLength),
                        _rule(
                          "One uppercase letter (A-Z)",
                          hasUppercase,
                        ),
                        _rule(
                          "One lowercase letter (a-z)",
                          hasLowercase,
                        ),
                        _rule("One number (0-9)", hasNumber),
                        _rule(
                          "One special character",
                          hasSpecialChar,
                        ),

                        if (passwordsMatch)
                          _successBox("Passwords match"),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: isFormValid && !_isSubmitting ? _submit : null,
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
                                gradient: isFormValid
                                    ? AppColors.primaryGradient2
                                    : LinearGradient(
                                        colors: [
                                          Colors.grey.shade300,
                                          Colors.grey.shade400,
                                        ],
                                      ),
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                              ),
                              child: const Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.lock_reset,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Reset & Login",
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required bool hidden,
    required VoidCallback toggle,
    required String hint,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      obscureText: hidden,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            hidden
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: toggle,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _rule(String text, bool valid) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            valid ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: valid ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: valid ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _successBox(String text) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(color: Colors.green)),
        ],
      ),
    );
  }
}
