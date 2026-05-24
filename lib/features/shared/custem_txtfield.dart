import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustemTxtfield extends StatefulWidget {
  const CustemTxtfield({
    super.key,
    required this.hintText,
    required this.isPassword,
    required this.controller,
    this.prefixIcon
  });

  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final Widget? prefixIcon;



  @override
  State<CustemTxtfield> createState() => _CustemTxtfieldState();
}

class _CustemTxtfieldState extends State<CustemTxtfield> {
  late bool _obscureText;

  @override
  void initState(){
    super.initState();
    _obscureText = widget.isPassword;
  }
  void _togglePassword(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }



  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputBg = isDark ? const Color(0xFF1E293B) : AppColors.primaryColor2;
    final textColor = isDark ? Colors.white : AppColors.Black;
    final hintColor = isDark ? Colors.grey.shade400 : AppColors.Gray;
    final borderColor = isDark ? Colors.white24 : const Color(0xFFE5E7EB);
    final focusBorderColor = isDark ? AppColors.SkyBlue : const Color(0xFF2563EB);

    return TextFormField(
      controller: widget.controller,
      cursorColor: textColor,
      style: TextStyle(color: textColor, fontSize: 16),
      validator: (v){
        if(v!.isEmpty){
          return 'please fill ${widget.hintText}';
        }
        return null;
      },
      obscureText: _obscureText,
      decoration: InputDecoration(
        prefixIcon: Padding(padding:const EdgeInsets.symmetric(horizontal: 12),
          child: widget.prefixIcon,
        ),
        hintStyle: TextStyle(color: hintColor, fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(vertical: 18.5,horizontal: 48),
        fillColor: inputBg,
        suffix:
        widget.isPassword ? GestureDetector(
            onTap: _togglePassword,
            child: Icon(CupertinoIcons.eye, color: hintColor)
        ):null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(16),
          ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusBorderColor, width: 1.3),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.2),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        hintText: widget.hintText,
        filled: true,
      ),
    );
  }
}
