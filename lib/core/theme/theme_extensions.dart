import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

extension ThemeExtensions on BuildContext {
  /// Returns true if the app is currently in Dark Mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Returns the theme-aware background color for cards/containers
  Color get dynamicCardColor => Theme.of(this).cardColor;

  /// Returns the theme-aware background color for scaffolds
  Color get dynamicScaffoldColor => Theme.of(this).scaffoldBackgroundColor;

  /// Returns theme-aware text colors
  Color get dynamicTextColorPrimary => isDarkMode ? Colors.white : AppColors.Black2;
  Color get dynamicTextColorSecondary => isDarkMode ? Colors.grey.shade400 : AppColors.Gray;
  Color get dynamicBorderColor => isDarkMode ? Colors.white24 : const Color(0xFFD8E4EC);
  Color get dynamicInputColor => isDarkMode ? const Color(0xFF1E293B) : Colors.white;

  /// Returns theme-aware background color
  Color get dynamicBgColor => isDarkMode ? const Color(0xFF0F172A) : AppColors.primaryColor;

  /// Returns theme-aware gradient
  LinearGradient get dynamicBgGradient => isDarkMode
      ? const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : AppColors.primaryGradient1;
}
