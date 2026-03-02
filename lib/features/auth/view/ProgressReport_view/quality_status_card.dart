import 'package:flutter/material.dart';

class QualityStatusCard extends StatelessWidget {
  final String current;
  final String lastMonth;
  final String initial;

  const QualityStatusCard({
    super.key,
    required this.current,
    required this.lastMonth,
    required this.initial,
  });

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
          /// TITLE
          const Text(
            "Quality Status",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          /// CURRENT
          _buildRow(
            title: "Current",
            value: current,
            color: const Color(0xFF22C55E),
            bgColor: const Color(0xFFE7F6EC),
          ),

          const SizedBox(height: 12),

          /// LAST MONTH
          _buildRow(
            title: "Last Month",
            value: lastMonth,
            color: const Color(0xFFF59E0B),
            bgColor: const Color(0xFFFEF3C7),
          ),

          const SizedBox(height: 12),

          /// INITIAL
          _buildRow(
            title: "Initial",
            value: initial,
            color: const Color(0xFFEF4444),
            bgColor: const Color(0xFFFEE2E2),
          ),
        ],
      ),
    );
  }

  /// reusable row
  Widget _buildRow({
    required String title,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
          ),

          child: Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
