import 'dart:io';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class UploadedImageCard extends StatelessWidget {
  final VoidCallback onReupload;
  final File? imageFile; // ✅ الصورة الحقيقية

  const UploadedImageCard({
    super.key,
    required this.onReupload,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Icon(Icons.check_circle_outline,
                  color: AppColors.Turqouoise, size: 20),
              const SizedBox(width: 8),
              Text(
                'Image Uploaded Successfully',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.Black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Image — حقيقي لو موجود، placeholder لو لا
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: imageFile != null
                ? Image.file(
                    imageFile!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4F8),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.SkyBlue,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: AppColors.Gray2,
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          // Re-upload Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: onReupload,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.Gray2, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Re-upload Image',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.Black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}