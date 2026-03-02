import 'package:flutter/material.dart';

class SymptomModel {
  final String name;
  final int percent;

  SymptomModel({
    required this.name,
    required this.percent,
  });
}

class SymptomImprovementCard extends StatelessWidget {
  final List<SymptomModel> symptoms;

  const SymptomImprovementCard({
    super.key,
    required this.symptoms,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Symptom Improvement",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          Column(
            children: symptoms.map((s) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s.name),
                        Text("-${s.percent}%"),
                      ],
                    ),

                    const SizedBox(height: 6),

                    LinearProgressIndicator(
                      value: s.percent / 100,
                      minHeight: 6,
                      color: const Color(0xFF10B981),
                      backgroundColor: Colors.grey[300],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
