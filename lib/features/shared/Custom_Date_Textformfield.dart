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
    return SizedBox(
      width: widget.width ?? double.infinity,
      child: TextFormField(
        controller: widget.controller,
        readOnly: true,
        cursorColor: Colors.grey,
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
          suffixIcon: const Icon(Icons.calendar_today),
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade700),
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
