import 'package:flutter/material.dart';

class AffectedAreasCard extends StatelessWidget {
  const AffectedAreasCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 10),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Affected Areas",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              areaChip("Hands & Wrists", Colors.red),
              areaChip("Inner Elbows", Colors.red),
              areaChip("Neck", Colors.orange),
              areaChip("Behind Knees", Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget areaChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(.5)),
      ),

      child: Text(text, style: TextStyle(color: Color(0xFF82181A))),
    );
  }
}
