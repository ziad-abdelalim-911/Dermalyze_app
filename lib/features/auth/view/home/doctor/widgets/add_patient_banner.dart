import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AddPatientBanner extends StatelessWidget {
  final VoidCallback onTap;

  const AddPatientBanner({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient2,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.SkyBlue.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(
                Icons.person_add_alt_1,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Patient',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Create Patient File',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildDot(),
                      const SizedBox(width: 6),
                      const Text(
                        'Quick Setup',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                      const SizedBox(width: 14),
                      _buildDot(),
                      const SizedBox(width: 6),
                      const Text(
                        'Start Monitoring',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}