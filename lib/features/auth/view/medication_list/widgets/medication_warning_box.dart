import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_assets.dart';

class MedicationWarningBox extends StatelessWidget {

  final String text;

  const MedicationWarningBox({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(

        color: Theme.of(context).cardColor,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: const Color(0xFFEAB308),
        ),
      ),

      child: Row(

        children: [

          Image.asset(
            AppAssets.i_icon,
            width: 20,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF92400E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
