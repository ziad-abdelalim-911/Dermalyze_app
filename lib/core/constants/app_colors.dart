import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = Color(0xffF0FDFA);
  static Color primaryColor2 = Color(0xffEFF6FF);
  static Color Gray = Color(0xFF6A7282);
  static Color Gray2 = Color(0xFFD1D5DC);
  static Color Gray3 = Color(0xFF4A5565);

  static Color White = Color(0xFFFFFFFF);
  static Color White2 = Color(0xff4a90e233);

  static Color SkyBlue = Color(0xff4A90E2);
  static Color Turqouoise = Color(0xff4ECDC4);
  static Color Black = Color(0xff1F2937);
  static Color Black2 = Color(0xff101828);
  static Color Black3 = Color(0xff364153);

  static LinearGradient get primaryGradient2 => LinearGradient(
    colors: [SkyBlue, Turqouoise],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get primaryGradient1 => LinearGradient(
    colors: [primaryColor, primaryColor2, White],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static get primaryBlue => null;

  ///Text(
  //   "DERMALYZE",
  //   style: TextStyle(
  //     fontSize: 30,
  //     fontWeight: FontWeight.w400,
  //     letterSpacing: 0.4,
  //     foreground: Paint()
  //       ..shader = LinearGradient(
  //         colors: [
  //           Color(0xFF4A90E2),
  //           Color(0xFF4DC1CA),
  //         ],
  //       ).createShader(
  //         const Rect.fromLTWH(0, 0, 220, 36),
  //       ),
  //   ),
  // ),
}
