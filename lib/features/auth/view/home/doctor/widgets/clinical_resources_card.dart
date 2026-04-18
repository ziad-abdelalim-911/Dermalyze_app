import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ClinicalResourcesCard extends StatelessWidget {
  final VoidCallback onSmartHistory;
  final VoidCallback onMedications;
  final VoidCallback onDiseases;

  const ClinicalResourcesCard({
    super.key,
    required this.onSmartHistory,
    required this.onMedications,
    required this.onDiseases,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.public, color: AppColors.SkyBlue, size: 18),
            const SizedBox(width: 8),
            Text(
              'Clinical Resources & Insights',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // My Smart History
        GestureDetector(
          onTap: onSmartHistory,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient2,
              borderRadius: BorderRadius.circular(16),
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
                    Icons.psychology_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'My Smart History',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'AI-Powered Treatment Insights',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Description
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.SkyBlue.withOpacity(0.07),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Search your patient history to discover which medications delivered the best results for specific diseases.",
            style: TextStyle(
              fontSize: 12,
              color: AppColors.Gray3,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Medications + Diseases Row
        Row(
          children: [
            Expanded(
              child: _buildResourceCard(
                context: context,
                onTap: onMedications,
                icon: Icons.medication_outlined,
                iconColor: AppColors.Turqouoise,
                title: 'Medications Guide',
                subtitle: 'Drug database',
                tag: 'Reference Tool',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildResourceCard(
                context: context,
                onTap: onDiseases,
                icon: Icons.library_books_outlined,
                iconColor: AppColors.SkyBlue,
                title: 'Diseases Library',
                subtitle: 'Reference guide',
                tag: 'Reference Tool',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResourceCard({
    required BuildContext context,
    required VoidCallback onTap,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String tag,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 26),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: AppColors.Gray),
            ),
            const SizedBox(height: 6),
            Text(
              '$tag >',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.SkyBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}