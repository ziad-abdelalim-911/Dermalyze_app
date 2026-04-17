import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/features/Login2/Data/repositories/login_repository_impl.dart';
import 'package:dermalyze/features/Login2/presentation/bloc/login_bloc.dart';
import 'package:dermalyze/features/Login2/presentation/bloc/login_event.dart';
import 'package:dermalyze/features/Login2/presentation/bloc/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-z]{2,}$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(LoginRepositoryImpl()),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            if (state.role == 'doctor') {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.bottomNavBar, (route) => false,
                  arguments: true);
            } else {
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.bottomNavBar, (route) => false,
                  arguments: false);
            }
          }
          if (state is LoginFailure) {
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
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(gradient: AppColors.primaryGradient1),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 48),

                        // ── Logo ──
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient2,
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              AppAssets.Icon_register_1,
                              height: 44,
                              width: 44,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── App Name ──
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              AppColors.primaryGradient2.createShader(bounds),
                          child: const Text(
                            'DERMALYZE',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'AI-Powered Skin Monitoring',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.Gray,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // ── Card ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.withValues(alpha: 0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Center(
                                child: Text(
                                  'Welcome Back',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.Black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // ── Email ──
                              Text(
                                'E-mail',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.Black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: _validateEmail,
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.Black),
                                decoration: InputDecoration(
                                  hintText: 'Enter your E-mail',
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: AppColors.Gray),
                                  prefixIcon: Icon(Icons.person_outline,
                                      color: AppColors.SkyBlue, size: 20),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                        color: AppColors.Gray2, width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                        color: AppColors.Gray2, width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                        color: AppColors.SkyBlue, width: 1.8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1.2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1.5),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // ── Password ──
                              Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.Black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _isPasswordHidden,
                                validator: _validatePassword,
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.Black),
                                decoration: InputDecoration(
                                  hintText: 'Enter your password',
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: AppColors.Gray),
                                  prefixIcon: Icon(Icons.lock_outline,
                                      color: AppColors.SkyBlue, size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordHidden
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: AppColors.Gray,
                                      size: 20,
                                    ),
                                    onPressed: () => setState(() =>
                                        _isPasswordHidden = !_isPasswordHidden),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                        color: AppColors.Gray2, width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                        color: AppColors.Gray2, width: 1.5),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                        color: AppColors.SkyBlue, width: 1.8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1.2),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: Colors.red, width: 1.5),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // ── Login Button ──
                              BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: AppColors.primaryGradient2,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: state is LoginLoading
                                            ? null
                                            : () {
                                                if (!_formKey.currentState!.validate()) return;
                                                context.read<LoginBloc>().add(
                                                      LoginButtonPressed(
                                                        email: _emailController
                                                            .text
                                                            .trim(),
                                                        password:
                                                            _passwordController
                                                                .text
                                                                .trim(),
                                                      ),
                                                    );
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                        ),
                                        child: state is LoginLoading
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : const Text(
                                                'Login',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),

                              // ── Forgot Password ──
                              Center(
                                child: GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, AppRoutes.forgotPassword),
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.SkyBlue,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              Divider(color: AppColors.Gray2),
                              const SizedBox(height: 16),

                              // ── Sign Up ──
                              Center(
                                child: GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, AppRoutes.register),
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Don't have an account? ",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.Gray,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'Sign Up',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.SkyBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Footer ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.security_outlined,
                                size: 14, color: AppColors.Gray),
                            const SizedBox(width: 6),
                            Text(
                              'Secure medical platform • HIPAA Compliant',
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.Gray),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}