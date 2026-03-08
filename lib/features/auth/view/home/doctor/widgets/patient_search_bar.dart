import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PatientSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const PatientSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(fontSize: 14, color: AppColors.Black),
      decoration: InputDecoration(
        hintText: 'Search patients by name or diagnosis',
        hintStyle: TextStyle(fontSize: 13, color: AppColors.Gray),
        prefixIcon: Icon(Icons.search, color: AppColors.Gray, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.Gray2, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.Gray2, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.SkyBlue, width: 1.8),
        ),
      ),
    );
  }
}