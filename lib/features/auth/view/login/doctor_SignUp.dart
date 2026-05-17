import 'dart:io';
import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/features/auth/bloc/register_bloc.dart';
import 'package:dermalyze/features/auth/bloc/register_event.dart';
import 'package:dermalyze/features/auth/bloc/register_state.dart';
import 'package:dermalyze/features/auth/view/login/id_scanning_screen.dart';
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
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  File? _idCardFront;
  File? _idCardBack;
  File? _selfie;

  /// Opens the dedicated ID scanning screen which guides the user through
  /// front → back → selfie in one flow, then returns all 3 files at once.
  Future<void> _openIdScanner() async {
    final result = await Navigator.push<IdScanResult>(
      context,
      MaterialPageRoute(
        builder: (_) => const IdScanningScreen(),
        fullscreenDialog: true,
      ),
    );

    if (result == null) return;

    setState(() {
      _idCardFront = result.frontCard;
      _idCardBack = result.backCard;
      _selfie = result.selfie;
    });
  }

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

  String? _validatePhone(String? v) {
    if (v == null || v.isEmpty) return 'Mobile Number is required';
    if (v.length < 10) return 'Enter a valid mobile number';
    return null;
  }

  String? _validateNationalId(String? v) {
    // We only require images now, text can be optional or kept for backup
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
    _phoneController.dispose();
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
              context, AppRoutes.bottomNavBar, (route) => false, arguments: true);
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
                              icon: Icon(Icons.arrow_back,
                                  color: Theme.of(context).cardColor),
                              label: const Text('Back',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: 72, height: 72,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor.withValues(alpha: 0.2),
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
                          const SizedBox(height: 16),
                          _buildValidatedField(
                            label: 'Mobile Number *',
                            hint: '01234567890',
                            icon: Icons.phone_outlined,
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: _validatePhone,
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

                    const SizedBox(height: 24),

                    // ── National ID Verification ──
                    _buildCard(
                      title: 'National ID Verification',
                      icon: Icons.badge_outlined,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Please capture clear photos of your National ID and a selfie for verification. Tap on each box to scan.',
                            style: TextStyle(fontSize: 13, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          // Tapping any of the boxes launches the full scanning flow
                          GestureDetector(
                            onTap: _openIdScanner,
                            child: Row(
                              children: [
                                Expanded(child: _buildImagePickerBox('front', 'ID Front', _idCardFront)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildImagePickerBox('back', 'ID Back', _idCardBack)),
                                const SizedBox(width: 12),
                                Expanded(child: _buildImagePickerBox('selfie', 'Selfie', _selfie)),
                              ],
                            ),
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
                                      if (_idCardFront == null || _idCardBack == null || _selfie == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('ID card front, back, and selfie are all required for doctor registration', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
                                        );
                                        return;
                                      }
                                      context.read<RegisterBloc>().add(
                                        RegisterSubmitted(
                                          name: _nameController.text.trim(),
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text,
                                          role: 'doctor',
                                          phone: _phoneController.text.trim(),
                                          idCardFront: _idCardFront,
                                          idCardBack: _idCardBack,
                                          selfie: _selfie,
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
                                      ? CircularProgressIndicator(
                                          color: Theme.of(context).cardColor)
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

  Widget _buildStepIndicator(String title, bool isDone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDone ? const Color(0xFF4ADE80) : Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isDone ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }

  // ── Image Picker Box ───────────────────────────────────────
  Widget _buildImagePickerBox(String type, String label, File? imageFile) {
    return Column(
      children: [
        Container(
          height: 90,
          width: double.infinity,
          decoration: BoxDecoration(
            color: imageFile != null ? Colors.transparent : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: imageFile != null ? Colors.green : Colors.grey.shade300,
              width: 1.5,
            ),
            image: imageFile != null
                ? DecorationImage(
                    image: FileImage(imageFile),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: imageFile == null
              ? const Center(
                  child: Icon(Icons.camera_alt_outlined, color: Colors.grey, size: 28),
                )
              : Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle, color: Colors.green, size: 22),
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: imageFile != null ? Colors.green.shade700 : Colors.grey.shade800,
          ),
        ),
      ],
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
        color: Theme.of(context).cardColor,
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
