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
    return TextFormField(
      controller: widget.controller,
      cursorColor: Colors.black,
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
        hintStyle: TextStyle(color: AppColors.Gray,fontSize: 16),
        contentPadding: const EdgeInsets.symmetric(vertical: 18.5,horizontal: 48),
        fillColor: AppColors.primaryColor2,
        suffix:
        widget.isPassword ? GestureDetector(
            onTap: _togglePassword,
            child: Icon(CupertinoIcons.eye)
        ):null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE5E7EB),width: 1),
          borderRadius: BorderRadius.circular(16),
          ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF2563EB),width: 1.3),
          borderRadius: BorderRadius.circular(16),

        ),
        hintText: widget.hintText,
        filled: true,

      ),
    );
  }
}
