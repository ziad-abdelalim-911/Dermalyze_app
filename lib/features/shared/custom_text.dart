import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.color,
    this.size,
    this.weight,
    this.align,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final Color? color;
  final double? size;
  final FontWeight? weight;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: size ?? 14,
        color: color ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.Black2),
        fontWeight: weight ?? FontWeight.w400,
      ),
    );
  }
}
