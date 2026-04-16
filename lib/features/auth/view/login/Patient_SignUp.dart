import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/features/auth/bloc/register_bloc.dart';
import 'package:dermalyze/features/auth/bloc/register_event.dart';
import 'package:dermalyze/features/auth/bloc/register_state.dart';
import 'package:dermalyze/features/auth/view/login/login_view.dart';
import 'package:dermalyze/features/shared/custom_date_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PatientSignup extends StatefulWidget {
  const PatientSignup({super.key});

  @override
  State<PatientSignup> createState() => _PatientSignupState();
}

class _PatientSignupState extends State<PatientSignup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _doctorCodeController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  // ── Validators ──────────────────────────────────────────────

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Full name is required';
    if (v.trim().length < 3) return 'Name must be at least 3 characters';
    return null;
  }

  String? _validateNationalId(String? v) {
    if (v == null || v.isEmpty) return 'National ID is required';
    if (v.length != 14) return 'National ID must be exactly 14 digits';
    if (!RegExp(r'^\d{14}$').hasMatch(v)) return 'Only numbers are allowed';
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.isEmpty) return 'Mobile number is required';
    if (!RegExp(r'^01[0-9]{9}$').hasMatch(v)) {
      return 'Enter a valid Egyptian mobile (01x + 9 digits)';
    }
    return null;
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final emailRegExp = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-z]{2,}$');
    if (!emailRegExp.hasMatch(v.trim())) return 'Enter a valid email address';
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

  String? _validateDoctorCode(String? v) {
    if (v == null || v.trim().isEmpty) return 'Doctor code is required';
    return null;
  }

  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterBloc(),
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            if (state.role == 'doctor') {
              Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.doctorHome, (route) => false);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.bottomNavBar, (route) => false);
            }
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
        child: Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Form(
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
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                            child: const Icon(Icons.person_add_alt_1,
                                color: Colors.white, size: 36),
                          ),
                          const SizedBox(height: 16),
                          const Text('Patient Sign Up',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          const SizedBox(height: 6),
                          const Text('Join DERMALYZE today',
                              style: TextStyle(fontSize: 14, color: Colors.white70)),
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
                          // Full Name
                          _buildValidatedField(
                            label: 'Full Name *',
                            hint: 'Enter your full name',
                            icon: Icons.person_outline,
                            controller: _nameController,
                            validator: _validateName,
                          ),
                          const SizedBox(height: 16),

                          // National ID
                          _buildNationalIdField(),
                          const SizedBox(height: 16),

                          // Phone + DOB
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildPhoneField(),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Date of Birth *',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                    const SizedBox(height: 6),
                                    CustomDateTextformfield(
                                      hint: 'DD / MM / YYYY',
                                      controller: _birthDateController,
                                      validatorText: 'Please select date of birth',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Doctor Code
                          _buildValidatedField(
                            label: 'Doctor Code *',
                            hint: 'Enter doctor\'s code',
                            icon: Icons.person_add_alt,
                            controller: _doctorCodeController,
                            validator: _validateDoctorCode,
                          ),
                          const SizedBox(height: 12),
                          _infoBox(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Account Details ──
                    _buildCard(
                      title: 'Account Details',
                      icon: Icons.lock_outline,
                      child: Column(
                        children: [
                          // Email
                          _buildEmailField(),
                          const SizedBox(height: 16),

                          // Password
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
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Must include uppercase, lowercase, and number',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Confirm Password
                          _buildPasswordField(
                            label: 'Confirm Password *',
                            hint: 'Re-enter your password',
                            controller: _confirmPasswordController,
                            hidden: _isConfirmPasswordHidden,
                            toggle: () => setState(() =>
                                _isConfirmPasswordHidden = !_isConfirmPasswordHidden),
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
                          return Container(
                            height: 56,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient2,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: state is RegisterLoading
                                    ? null
                                    : () {
                                        if (!_formKey.currentState!.validate()) return;
                                        context.read<RegisterBloc>().add(
                                          RegisterSubmitted(
                                            name: _nameController.text.trim(),
                                            email: _emailController.text.trim(),
                                            password: _passwordController.text,
                                            role: 'patient',
                                            doctorCode:
                                                _doctorCodeController.text.trim(),
                                            phone: _phoneController.text.trim(),
                                            nationalId:
                                                _nationalIdController.text.trim(),
                                            birthDate:
                                                _birthDateController.text.trim(),
                                          ),
                                        );
                                      },
                                borderRadius: BorderRadius.circular(16),
                                child: Center(
                                  child: state is RegisterLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.person_add_alt,
                                                color: Colors.white),
                                            SizedBox(width: 8),
                                            Text(
                                              'Register',
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
                        const Text('Already have an account? ',
                            style: TextStyle(color: Colors.grey)),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'Login here',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
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

  // ── National ID Field (14 digits exact) ────────────────────
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
                // counter inside the suffix
                suffixText: '$count / 14',
                suffixStyle: TextStyle(
                  fontSize: 12,
                  color: count == 14 ? Colors.green : AppColors.Gray,
                  fontWeight: FontWeight.w500,
                ),
                counterText: '', // hide default counter
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
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Numbers only • Must be exactly 14 digits',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  // ── Phone Field (Egyptian 01x 11-digit) ────────────────────
  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mobile *',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          keyboardType: TextInputType.phone,
          maxLength: 11,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(11),
          ],
          validator: _validatePhone,
          decoration: InputDecoration(
            hintText: '01xxxxxxxxx',
            hintStyle: TextStyle(color: AppColors.Gray),
            prefixIcon: const Icon(Icons.phone_outlined),
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
        ),
      ],
    );
  }

  // ── Email Field ─────────────────────────────────────────────
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Email Address *',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
          decoration: InputDecoration(
            hintText: 'your.email@example.com',
            hintStyle: TextStyle(color: AppColors.Gray),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: SvgPicture.asset(AppAssets.Massage, width: 20, height: 20),
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
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
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
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: hidden,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.Gray),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: SvgPicture.asset(AppAssets.Lock, width: 20, height: 20),
            ),
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
            color: Colors.black.withValues(alpha: 0.05),
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

  Widget _infoBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, size: 18, color: Color(0xFF2563EB)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Required to link with your supervising dermatologist. Contact your doctor if you don\'t have this code.',
              style: TextStyle(fontSize: 12, color: Color(0xFF2563EB)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _nationalIdController.dispose();
    _phoneController.dispose();
    _doctorCodeController.dispose();
    _birthDateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
