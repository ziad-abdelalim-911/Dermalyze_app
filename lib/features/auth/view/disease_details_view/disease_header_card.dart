import 'package:flutter/material.dart';

class DiseaseHeaderCard extends StatelessWidget {
  const DiseaseHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: const Color(0xFF2DD4BF), width: 1.5),

        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 10),
        ],
      ),

      child: Row(
        children: [
          /// icon
          Container(
            width: 56,
            height: 56,

            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(16),
            ),

            child: Icon(Icons.monitor_heart, color: Theme.of(context).cardColor),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Atopic Dermatitis",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 4),

                const Text(
                  "Also known as Eczema",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    /// Chronic
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Text(
                        "Chronic Condition",
                        style: TextStyle(
                          color: Color(0xFF894B00),
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    /// Manageable
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: const Text(
                        "Manageable",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF193CB8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
