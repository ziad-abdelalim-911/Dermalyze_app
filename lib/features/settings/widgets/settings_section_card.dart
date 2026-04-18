import 'package:flutter/material.dart';

class SettingsSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Color? headerColor;
  final Color accentColor;
  final Gradient? headerGradient;

  const SettingsSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.headerColor,
    this.headerGradient,
    this.accentColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: headerColor ?? Colors.transparent,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).cardColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: headerGradient != null
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }
}
