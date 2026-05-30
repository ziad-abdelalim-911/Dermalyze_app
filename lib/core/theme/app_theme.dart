import 'package:flutter/material.dart';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.SkyBlue,
      scaffoldBackgroundColor: const Color(0xFFF9FAFC),
      canvasColor: Colors.white, // Used for cards
      cardColor: Colors.white,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      colorScheme: ColorScheme.light(
        primary: AppColors.SkyBlue,
        secondary: AppColors.Turqouoise,
        surface: Colors.white,
        onSurface: Colors.black,
      ),
      dividerColor: Colors.grey.shade200,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.SkyBlue,
      scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
      canvasColor: const Color(0xFF1E293B), // Slate 800 - Used for cards
      cardColor: const Color(0xFF1E293B),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      colorScheme: ColorScheme.dark(
        primary: AppColors.SkyBlue,
        secondary: AppColors.Turqouoise,
        surface: const Color(0xFF1E293B),
        onSurface: Colors.white,
      ),
      dividerColor: Colors.grey.shade800,
    );
  }
}
