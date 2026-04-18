import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CriticalCareGuidelinesCard extends StatelessWidget {
  const CriticalCareGuidelinesCard({super.key});

  static const List<String> _guidelines = [
    'Monitor patients every 2-4 hours',
    'Document all symptom changes immediately',
    'Ensure emergency contact information is current',
    'Coordinate with specialists for severe cases',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Theme.of(context).cardColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.health_and_safety_outlined,
                  color: const Color(0xFFE05252), size: 20),
              const SizedBox(width: 8),
              Text(
                'Critical Care Guidelines',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.Black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._guidelines.map(
            (g) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ',
                      style: TextStyle(
                          color: Color(0xFFE05252), fontSize: 14)),
                  Expanded(
                    child: Text(
                      g,
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColors.Gray3,
                          height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}