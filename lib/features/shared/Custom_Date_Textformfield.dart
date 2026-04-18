import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDateTextformfield extends StatefulWidget {
  const CustomDateTextformfield({
    super.key,
    this.width,
    required this.hint,
    required this.controller,
    required this.validatorText,
  });

  final double? width;
  final String hint;
  final String validatorText;
  final TextEditingController controller;

  @override
  State<CustomDateTextformfield> createState() =>
      _CustomDateTextformfieldState();
}

class _CustomDateTextformfieldState
    extends State<CustomDateTextformfield> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.Black;
    final hintColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return SizedBox(
      width: widget.width ?? double.infinity,
      child: TextFormField(
        controller: widget.controller,
        readOnly: true,
        cursorColor: Colors.grey,
        style: TextStyle(color: textColor, fontSize: 14),
        validator: (v) {
          if (v == null || v.isEmpty) {
            return widget.validatorText;
          }
          return null;
        },
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          hintText: widget.hint,
          hintStyle: TextStyle(color: hintColor, fontSize: 14),
          suffixIcon: Icon(Icons.calendar_today, color: hintColor),
          fillColor: inputBg,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: isDark ? Colors.white24 : AppColors.Gray2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.SkyBlue),
          ),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            widget.controller.text =
                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          }
        },
      ),
    );
  }
}
