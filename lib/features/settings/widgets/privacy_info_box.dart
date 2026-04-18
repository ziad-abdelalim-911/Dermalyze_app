import 'package:flutter/material.dart';

class PrivacyInfoBox extends StatelessWidget {
  final String text;

  const PrivacyInfoBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF5EEAD4)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF065F46),
          height: 1.4,
        ),
      ),
    );
  }
}
