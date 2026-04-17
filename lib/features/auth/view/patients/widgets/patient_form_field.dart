import 'package:flutter/material.dart';

class PatientFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool required;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;

  const PatientFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.required = true,
    this.prefixIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF2C4A5A),
              ),
            ),
            const SizedBox(width: 3),
            if (required)
              const Text('*', style: TextStyle(color: Color(0xFFE05252), fontSize: 13)),
            if (!required)
              const Text(
                ' (Optional)',
                style: TextStyle(fontSize: 12, color: Color(0xFF8A9BAB)),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator ?? (required
              ? (val) => (val == null || val.trim().isEmpty) ? 'This field is required' : null
              : null),
          style: const TextStyle(fontSize: 14, color: Color(0xFF1A2E3B)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF8A9BAB)),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: const Color(0xFF8A9BAB))
                : null,
            filled: true,
            fillColor: const Color(0xFFFAFCFE),
            contentPadding: EdgeInsets.symmetric(
              horizontal: prefixIcon == null ? 14 : 0,
              vertical: maxLines > 1 ? 14 : 0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFD8E4EC), width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFD8E4EC), width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF3A8FA8), width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE05252), width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE05252), width: 1.8),
            ),
          ),
        ),
      ],
    );
  }
}


