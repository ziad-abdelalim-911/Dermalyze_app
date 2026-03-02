import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'first_screen.dart';
import 'fourth_screen.dart';
import 'second_screen.dart';
import 'third_screen.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _controller = PageController();
  int index = 0;

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
              Expanded(
                child: PageView(
                  onPageChanged: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                  controller: _controller,
                  children: [
                    FirstScreen(),
                    SecondScreen(),
                    ThirdScreen(),
                    FourthScreen(),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIndicator(active: index == 0),
                  SizedBox(width: 5),
                  CustomIndicator(active: index == 1),
                  SizedBox(width: 5),
                  CustomIndicator(active: index == 2),
                  SizedBox(width: 5),
                  CustomIndicator(active: index == 3),
                ],
              ),

              SizedBox(height: 35),

              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: InkWell(
                          onTap: () {
                            if (index == 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginView(),
                                ),
                              );
                            } else {
                              _controller.animateToPage(
                                index + 1,
                                duration: Duration(milliseconds: 250),
                                curve: Curves.linear,
                              );
                            }
                          },
                          child: SizedBox(
                            height: 56,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient2,
                                borderRadius: BorderRadius.circular(
                                  16,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      index == 3 ? "Login" : "Next",
                                      style: TextStyle(
                                        fontFamily: "Inter",
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(160),
              Text(
                "Professional Medical Platform • Secure & HIPAA \n Compliant",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.Gray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomIndicator extends StatelessWidget {
  final bool active;

  const CustomIndicator({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: active ? AppColors.SkyBlue : AppColors.Gray2,
      ),
      width: active ? 30 : 10,
      height: 10,
    );
  }
}
