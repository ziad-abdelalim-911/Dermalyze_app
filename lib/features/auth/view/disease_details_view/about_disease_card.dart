import 'package:flutter/material.dart';

class AboutDiseaseCard extends StatelessWidget {
  const AboutDiseaseCard({super.key});

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
          Row(
            children: const [
              Icon(Icons.info_outline, color: Color(0xFF14B8A6)),

              SizedBox(width: 8),

              Text(
                "About Atopic Dermatitis",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Text(
            "Atopic dermatitis is a chronic inflammatory skin condition that causes dry, itchy, and inflamed skin. It's most common in children but can occur at any age. The condition tends to flare periodically and may be accompanied by asthma or hay fever.",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Common Triggers:",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0B4F4A),
                  ),
                ),

                SizedBox(height: 8),

                Text("• Dry skin", style: TextStyle(color: Color(0xFF0B4F4A))),
                Text(
                  "• Irritants (soaps, detergents)",
                  style: TextStyle(color: Color(0xFF0B4F4A)),
                ),
                Text("• Stress", style: TextStyle(color: Color(0xFF0B4F4A))),
                Text(
                  "• Hot and humid weather",
                  style: TextStyle(color: Color(0xFF0B4F4A)),
                ),
                Text(
                  "• Certain foods (dairy, eggs, nuts)",
                  style: TextStyle(color: Color(0xFF0B4F4A)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
