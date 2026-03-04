import 'package:flutter/material.dart';

class MedicationWhenBox extends StatelessWidget {

  final String value;

  const MedicationWhenBox({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color: const Color(0xFFE8F0FE),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Text(
            "When to take:",
            style: TextStyle(
              color: Color(0xFF1D4ED8),
            ),
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1D4ED8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
