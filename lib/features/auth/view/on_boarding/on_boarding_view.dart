import 'package:dermalyze/core/constants/app_assets.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/login/login_view.dart';
import 'package:dermalyze/features/auth/view/login/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class OnboardingContent {
  final String icon;
  final String title;
  final String subtitle;
  final String description;

  OnboardingContent({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
  });
}

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView>
    with SingleTickerProviderStateMixin {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  late AnimationController _animController;
  late Animation<double> _floatAnimation;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      icon: AppAssets.Icon_intro_11,
      title: "DERMALYZE",
      subtitle: "AI-Powered Skin Monitoring",
      description:
          "Advanced technology to track and monitor \n your skin condition with precision",
    ),
    OnboardingContent(
      icon: AppAssets.Icon_intro_2,
      title: "DERMALYZE",
      subtitle: "Track Your Progress",
      description:
          "Monitor recovery rates and see\n improvements over time with detailed analytics",
    ),
    OnboardingContent(
      icon: AppAssets.Icon_intro_3,
      title: "DERMALYZE",
      subtitle: "Connect with Doctors",
      description:
          "Get professional medical advice and stay\n in touch with your healthcare provider",
    ),
    OnboardingContent(
      icon: AppAssets.Icon_intro_4,
      title: "DERMALYZE",
      subtitle: "Personalized Treatment",
      description:
          "Receive customized medication plans\n and treatment recommendations",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient1,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip Button
              Padding(
                padding: const EdgeInsets.only(right: 24, top: 16),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              RegisterView(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.Gray.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const Gap(40),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: _contents.length,
                  itemBuilder: (context, index) {
                    return _buildPageContent(_contents[index], index);
                  },
                ),
              ),

              // Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _contents.length,
                  (index) => _buildIndicator(index == _currentIndex),
                ),
              ),

              const Gap(40),

              // Next / Login Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 1.0, end: 1.0),
                  duration: const Duration(milliseconds: 200),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: GestureDetector(
                        onTapDown: (_) => setState(() {}),
                        onTapUp: (_) => setState(() {}),
                        onTapCancel: () => setState(() {}),
                        onTap: () {
                          if (_currentIndex == _contents.length - 1) {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        LoginView(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
                              ),
                            );
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOutCubic,
                            );
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient2,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4DC1CA).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Text(
                                    _currentIndex == _contents.length - 1
                                        ? "Get Started"
                                        : "Next",
                                    key: ValueKey<int>(_currentIndex),
                                    style: const TextStyle(
                                      fontFamily: "Inter",
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const Gap(8),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                  color: Colors.white,
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

              const Gap(30),

              // Footer Text
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  "Professional Medical Platform • Secure & HIPAA Compliant",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.Gray.withOpacity(0.6),
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(OnboardingContent content, int index) {
    // A subtle fade & scale animation for the content switching
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double value = 1.0;
        if (_controller.position.haveDimensions) {
          value = _controller.page! - index;
          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
        }
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with Floating Animation & Glow
          AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value),
                child: child,
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow effect
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4A90E2).withOpacity(0.2),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
                // Icon Container
                Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    gradient: AppColors.primaryGradient2,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 0,
                        spreadRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      content.icon,
                      height: 72,
                      width: 72,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Gap(50),

          // Title
          Text(
            content.title,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              foreground: Paint()
                ..shader = const LinearGradient(
                  colors: [
                    Color(0xFF4A90E2),
                    Color(0xFF4DC1CA),
                  ],
                ).createShader(
                  const Rect.fromLTWH(0, 0, 250, 40),
                ),
            ),
          ),

          const Gap(16),

          // Subtitle
          Text(
            content.subtitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2D3D), // Dark premium color
              letterSpacing: 0.2,
            ),
          ),

          const Gap(16),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              content.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B), // Slate gray
                height: 1.5,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.Turqouoise : AppColors.Gray.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
