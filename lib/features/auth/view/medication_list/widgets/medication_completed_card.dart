import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../medication_model.dart';

class MedicationCompletedCard extends StatelessWidget {

  final MedicationModel medication;

  const MedicationCompletedCard({
    super.key,
    required this.medication,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: Theme.of(context).cardColor,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
          ),
        ],
      ),

      child: Row(

        children: [

          Container(

            width: 48,
            height: 48,

            decoration: BoxDecoration(

              color: Theme.of(context).cardColor,

              borderRadius: BorderRadius.circular(12),
            ),

            child: Center(
              child: Image.asset(
                AppAssets.medication_icon,
                width: 24,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  medication.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  medication.dose,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Container(

            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(20),
            ),

            child: const Text(
              "Completed",
              style: TextStyle(
                color: Color(0xFF065F46),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
