import 'package:dermalyze/features/auth/view/ProgressReport_view/recovery_circle.dart';
import 'package:flutter/material.dart';

class ProgressHeaderCard extends StatelessWidget {
  final int recoveryPercent;
  final int improvementPercent;

  const ProgressHeaderCard({
    super.key,
    required this.recoveryPercent,
    required this.improvementPercent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF14B8A6)],
        ),

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: 10),
        ],
      ),

      child: SizedBox(
        height: 120, 

        child: Stack(
          children: [
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Overall Recovery",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "$recoveryPercent%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "+$improvementPercent% improvement from last month",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),

            
            Positioned(
              right: 0,
              top: 0,
              child: RecoveryCircle(percent: recoveryPercent),
            ),
          ],
        ),
      ),
    );
  }
}
