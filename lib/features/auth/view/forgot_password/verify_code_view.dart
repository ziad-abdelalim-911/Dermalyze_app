import 'dart:async';

import 'package:dermalyze/features/auth/view/forgot_password/auth_password_repository.dart';
import 'package:dermalyze/features/auth/view/forgot_password/create_new_password_view.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class VerifyCodeView extends StatefulWidget {
  final String email;

  const VerifyCodeView({super.key, required this.email});

  @override
  State<VerifyCodeView> createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  Timer? _timer;
  int _secondsRemaining = 600;
  bool _isVerifying = false;
  bool _isResending = false;
  final _repo = AuthPasswordRepository();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() {
          _secondsRemaining--;
        });
      }
    });
  }

  String get _formattedTime {
    final minutes = (_secondsRemaining ~/ 60).toString().padLeft(
      2,
      '0',
    );
    final seconds = (_secondsRemaining % 60).toString().padLeft(
      2,
      '0',
    );
    return "$minutes:$seconds";
  }

  String get _code => _controllers.map((c) => c.text).join();

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
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
                  // ===== Back =====
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

                  // ===== Icon =====
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== Title =====
                  const Text(
                    "Verify Code",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Enter the 6-digit code we sent to\n${widget.email}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Enter Verification Code",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "We've sent a 6-digit code to your email",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ===== Code Inputs =====
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            6,
                            (index) => _OtpBox(
                              controller: _controllers[index],
                              autoFocus: index == 0,
                              onChanged: (v) {
                                if (v.isNotEmpty && index < 5) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          "Code expires in: $_formattedTime",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ===== Verify Button =====
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isVerifying
                                ? null
                                : () async {
                                    final code = _code;
                                    if (code.length < 6) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content:
                                            Text('Please enter the full 6-digit code'),
                                        backgroundColor: Colors.orange,
                                      ));
                                      return;
                                    }
                                    setState(() => _isVerifying = true);
                                    try {
                                      await _repo.verifyOtp(
                                          email: widget.email, code: code);
                                      if (mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                CreateNewPasswordView(
                                              email: widget.email,
                                              code: code,
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Invalid code: ${e.toString()}'),
                                          backgroundColor:
                                              Colors.red.shade400,
                                        ));
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() => _isVerifying = false);
                                      }
                                    }
                                  },
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
                                      Icons.verified_user,
                                      color: Theme.of(context).cardColor,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      "Verify Code",
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

                        const SizedBox(height: 16),

                        // ===== Resend =====
                        Column(
                          children: [
                            const Text(
                              "Didn't receive the code?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: _isResending
                                  ? null
                                  : () async {
                                      setState(() {
                                        _secondsRemaining = 600;
                                        _isResending = true;
                                      });
                                      _startTimer();
                                      try {
                                        await _repo
                                            .sendResetCode(widget.email);
                                        if (mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text('Code resent ✓'),
                                            backgroundColor:
                                                Color(0xFF4ECDC4),
                                          ));
                                        }
                                      } catch (e) {
                                        // silently fail (timer restarted)
                                      } finally {
                                        if (mounted) {
                                          setState(() => _isResending = false);
                                        }
                                      }
                                    },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh,
                                    size: 18,
                                    color: _secondsRemaining == 0
                                        ? AppColors.primaryBlue
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: _secondsRemaining == 0 && !_isResending
                                        ? () async {
                                            setState(() {
                                              _secondsRemaining = 600;
                                              _isResending = true;
                                            });
                                            _startTimer();
                                            try {
                                              await _repo.sendResetCode(widget.email);
                                            } catch (_) {
                                              // silently ignore
                                            } finally {
                                              if (mounted) setState(() => _isResending = false);
                                            }
                                          }
                                        : null,
                                    child: Text(
                                      "Resend Code",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: _secondsRemaining == 0
                                            ? AppColors.primaryBlue
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Secure verification process • Your data is protected",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
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
}

// ================= OTP BOX =================
class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final bool autoFocus;
  final ValueChanged<String> onChanged;

  const _OtpBox({
    required this.controller,
    required this.autoFocus,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      child: TextField(
        controller: controller,
        autofocus: autoFocus,
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF2563EB),
              width: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}
