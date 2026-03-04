import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/features/Login2/Data/repositories/login_repository_impl.dart';
import 'package:dermalyze/features/Login2/presentation/bloc/login_bloc.dart';
import 'package:dermalyze/features/Login2/presentation/bloc/login_event.dart';
import 'package:dermalyze/features/Login2/presentation/bloc/login_state.dart';
import 'package:dermalyze/features/auth/view/login/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const TextStyle kTitleTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w700,
  color: Color(0xFF1F2933),
  height: 1.3,
);

const TextStyle kSubtitleTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Color(0xFF6B7280),
  height: 1.4,
);

const TextStyle kFieldLabelStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Color(0xFF4B5563),
);

const TextStyle kButtonTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

const TextStyle kLinkTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Color(0xFF2563EB),
);

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isPasswordHidden = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(LoginRepositoryImpl()),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushNamed(context, AppRoutes.bottomNavBar);
          }

          if (state is LoginFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
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
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                /// LOGO
                                Center(
                                  child: Container(
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
                                ),
                                const SizedBox(height: 28),
                                Text(
                                  'Welcome Back',
                                  textAlign: TextAlign.center,
                                  style: kTitleTextStyle,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Sign in to continue your skin health journey',
                                  textAlign: TextAlign.center,
                                  style: kSubtitleTextStyle,
                                ),
                                const SizedBox(height: 30),

                                /// EMAIL
                                TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email address',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                /// PASSWORD
                                TextField(
                                  controller: _passwordController,
                                  obscureText: _isPasswordHidden,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isPasswordHidden
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordHidden =
                                              !_isPasswordHidden;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                /// SIGN IN BUTTON
                                BlocBuilder<LoginBloc, LoginState>(
                                  builder: (context, state) {
                                    return SizedBox(
                                      height: 57,
                                      child: InkWell(
                                        onTap: state is LoginLoading
                                            ? null
                                            : () {
                                                context.read<LoginBloc>().add(
                                                  LoginButtonPressed(
                                                    email: _emailController.text
                                                        .trim(),
                                                    password:
                                                        _passwordController.text
                                                            .trim(),
                                                  ),
                                                );
                                              },
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient:
                                                AppColors.primaryGradient2,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Center(
                                            child: state is LoginLoading
                                                ? const CircularProgressIndicator(
                                                    color: Colors.white,
                                                  )
                                                : Text(
                                                    'Sign In',
                                                    style: kButtonTextStyle,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
