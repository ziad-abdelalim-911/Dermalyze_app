import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class DoctorsReviewCard extends StatelessWidget {
  final TextEditingController reviewController;
  final VoidCallback? onSave;

  const DoctorsReviewCard({
    super.key,
    required this.reviewController,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
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
          // Header
          Row(
            children: [
              Icon(Icons.show_chart, color: AppColors.Turqouoise, size: 20),
              const SizedBox(width: 8),
              Text(
                "Doctor's Review",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.Black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Text Area
          TextFormField(
            controller: reviewController,
            maxLines: 5,
            style: TextStyle(fontSize: 14, color: AppColors.Black),
            decoration: InputDecoration(
              hintText: 'Add your review notes here...',
              hintStyle: TextStyle(fontSize: 13, color: AppColors.Gray),
              filled: true,
              fillColor: const Color(0xFFFAFCFE),
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.Gray2, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.Gray2, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.SkyBlue, width: 1.8),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Save Button
          SizedBox(
            height: 44,
            child: OutlinedButton.icon(
              onPressed: onSave,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.SkyBlue, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              icon: Icon(Icons.save_outlined, size: 18, color: AppColors.SkyBlue),
              label: Text(
                'Save Notes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.SkyBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
