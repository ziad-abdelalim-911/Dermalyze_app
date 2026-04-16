import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/features/auth/bloc/register_bloc.dart';
import 'package:dermalyze/features/auth/bloc/register_event.dart';
import 'package:dermalyze/features/auth/bloc/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoctorSignup extends StatefulWidget {
  const DoctorSignup({super.key});

  @override
  State<DoctorSignup> createState() => _DoctorSignupState();
}

class _DoctorSignupState extends State<DoctorSignup> {
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // ── Validators ──────────────────────────────────────────────

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Full name is required';
    if (v.trim().length < 3) return 'Name must be at least 3 characters';
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final emailRegExp = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-z]{2,}$');
    if (!emailRegExp.hasMatch(v.trim())) return 'Enter a valid email address';
    return null;
  }

  String? _validateNationalId(String? v) {
    if (v == null || v.isEmpty) return 'National ID is required';
    if (v.length != 14) return 'National ID must be exactly 14 digits';
    if (!RegExp(r'^\d{14}$').hasMatch(v)) return 'Only numbers are allowed';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Password must be at least 8 characters';
    if (!v.contains(RegExp(r'[A-Z]'))) return 'Must contain an uppercase letter';
    if (!v.contains(RegExp(r'[a-z]'))) return 'Must contain a lowercase letter';
    if (!v.contains(RegExp(r'[0-9]'))) return 'Must contain a number';
    return null;
  }

  String? _validateConfirmPassword(String? v) {
    if (v != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  // ─────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nationalIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(),
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.doctorHome, (route) => false);
          }
          if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade400,
              ),
            );
          }
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.primaryColor,
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ── Header ──
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient2,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              label: const Text('Back',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: 72, height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.medical_services_outlined,
                                color: Colors.white, size: 36),
                          ),
                          const SizedBox(height: 16),
                          const Text('Doctor Registration',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          const SizedBox(height: 6),
                          const Text('Join DERMALYZE as a Medical Professional',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white70)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Personal Information ──
                    _buildCard(
                      title: 'Personal Information',
                      icon: Icons.person_outline,
                      child: Column(
                        children: [
                          _buildValidatedField(
                            label: 'Full Name *',
                            hint: 'Dr. John Smith',
                            icon: Icons.person_outline,
                            controller: _nameController,
                            validator: _validateName,
                          ),
                          const SizedBox(height: 16),
                          _buildValidatedField(
                            label: 'Email Address *',
                            hint: 'doctor@hospital.com',
                            icon: Icons.email_outlined,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── National ID Verification ──
                    _buildCard(
                      title: 'National ID Verification',
                      icon: Icons.badge_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter your 14-digit National ID number for doctor verification.',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),

                          // National ID Input with live counter
                          _buildNationalIdField(),

                          const SizedBox(height: 16),

                          // Info box
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: const Color(0xFFBFDBFE)),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.info_outline,
                                        size: 18, color: Color(0xFF2563EB)),
                                    SizedBox(width: 6),
                                    Text(
                                      'Why we need this:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2563EB)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '• Used to verify your identity as a licensed doctor.\n'
                                  '• Your National ID is kept secure and confidential.\n'
                                  '• Used only for doctor verification purposes.',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF2563EB),
                                      height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Account Security ──
                    _buildCard(
                      title: 'Account Security',
                      icon: Icons.lock_outline,
                      child: Column(
                        children: [
                          _buildPasswordField(
                            label: 'Password *',
                            hint: 'Min. 8 characters',
                            controller: _passwordController,
                            hidden: _isPasswordHidden,
                            toggle: () => setState(
                                () => _isPasswordHidden = !_isPasswordHidden),
                            validator: _validatePassword,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Must include uppercase, lowercase, and number',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          _buildPasswordField(
                            label: 'Confirm Password *',
                            hint: 'Re-enter your password',
                            controller: _confirmPasswordController,
                            hidden: _isConfirmPasswordHidden,
                            toggle: () => setState(() =>
                                _isConfirmPasswordHidden =
                                    !_isConfirmPasswordHidden),
                            validator: _validateConfirmPassword,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Register Button ──
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: BlocBuilder<RegisterBloc, RegisterState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: state is RegisterLoading
                                  ? null
                                  : () {
                                      if (!_formKey.currentState!.validate()) return;
                                      context.read<RegisterBloc>().add(
                                        RegisterSubmitted(
                                          name: _nameController.text.trim(),
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text,
                                          role: 'doctor',
                                          nationalId:
                                              _nationalIdController.text.trim(),
                                        ),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Ink(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient2,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: state is RegisterLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              AppAssets.Icon_doctor,
                                              width: 20, height: 20,
                                              // ignore: deprecated_member_use
                                              color: Colors.white,
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Register as Doctor',
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
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? '),
                        GestureDetector(
                          onTap: () => Navigator.pushNamedAndRemoveUntil(
                            context, AppRoutes.login, (route) => false),
                          child: const Text(
                            'Back to Login',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── National ID Field (14 digits, live counter) ─────────────
  Widget _buildNationalIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('National ID *',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _nationalIdController,
          builder: (_, value, __) {
            final count = value.text.length;
            return TextFormField(
              controller: _nationalIdController,
              keyboardType: TextInputType.number,
              maxLength: 14,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(14),
              ],
              validator: _validateNationalId,
              decoration: InputDecoration(
                hintText: 'Enter 14-digit National ID',
                hintStyle: TextStyle(color: AppColors.Gray),
                prefixIcon: const Icon(Icons.badge_outlined),
                suffixText: '$count / 14',
                suffixStyle: TextStyle(
                  fontSize: 12,
                  color: count == 14 ? Colors.green : AppColors.Gray,
                  fontWeight: FontWeight.w500,
                ),
                counterText: '',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red, width: 1.2),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red, width: 1.4),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        const Text(
          'Numbers only • Must be exactly 14 digits',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  // ── Generic Validated Field ─────────────────────────────────
  Widget _buildValidatedField({
    required String label,
    required String hint,
    required IconData icon,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.Gray),
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  // ── Password Field ──────────────────────────────────────────
  Widget _buildPasswordField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool hidden,
    required VoidCallback toggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: hidden,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.Gray),
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(hidden
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
              onPressed: toggle,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  // ── Card Wrapper ─────────────────────────────────────────────
  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
