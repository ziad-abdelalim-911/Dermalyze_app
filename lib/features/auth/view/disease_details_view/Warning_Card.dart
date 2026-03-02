import 'package:flutter/material.dart';

class WarningCard extends StatelessWidget {
  const WarningCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.red.withOpacity(.1),
        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: Colors.red.withOpacity(.4)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [

          Row(
            children: [

              Icon(Icons.warning, color: Colors.red),

              SizedBox(width: 8),

              Text(
                "When to Contact Doctor",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 8),

          Text("• Severe itching"),
          Text("• Signs of infection"),
          Text("• Condition worsens"),
          Text("• Skin spreads rapidly"),
        ],
      ),
    );
  }
}
