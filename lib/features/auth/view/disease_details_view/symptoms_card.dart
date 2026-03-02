import 'package:flutter/material.dart';

class SymptomsCard extends StatelessWidget {
  const SymptomsCard({super.key});

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
            "Current Symptoms",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          symptom("Itching", .6, Colors.orange),
          symptom("Redness", .4, Colors.deepOrange),
          symptom("Dryness", .8, Colors.red),
        ],
      ),
    );
  }

  Widget symptom(String name, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name),

          const SizedBox(height: 6),

          LinearProgressIndicator(
            value: value,
            color: color,
            backgroundColor: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }
}
