import 'package:flutter/material.dart';

class StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  const StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });
}

class StatsGridCard extends StatelessWidget {
  final List<StatItem> stats;

  const StatsGridCard({super.key, required this.stats});

  Widget build(BuildContext context) {
    if (stats.length != 4) return const SizedBox();
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard(stats[0])),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard(stats[1])),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatCard(stats[2])),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard(stats[3])),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(StatItem stat) {
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(stat.icon, color: stat.iconColor, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  stat.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}