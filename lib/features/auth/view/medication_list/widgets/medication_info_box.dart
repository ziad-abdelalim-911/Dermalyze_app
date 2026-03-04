import 'package:flutter/material.dart';

class MedicationInfoBox extends StatelessWidget {

  final String iconPath;
  final String title;
  final String value;

  const MedicationInfoBox({

    super.key,
    required this.iconPath,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(

        color: const Color(0xFFF1F5F9),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Row(

            children: [

              Image.asset(iconPath, width: 18),

              const SizedBox(width: 6),

              Text(
                title,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
