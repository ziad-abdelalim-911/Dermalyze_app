import 'dart:io';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageComparisonCard extends StatelessWidget {
  final File? currentImageFile;
  final String? previousImageUrl;
  final String previousSeverity;
  final String currentSeverity;

  const ImageComparisonCard({
    super.key,
    this.currentImageFile,
    this.previousImageUrl,
    required this.previousSeverity,
    required this.currentSeverity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
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
          Text(
            'Image Comparison',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: context.dynamicTextColorPrimary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Previous Scan
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.camera_alt_outlined,
                            size: 14, color: context.dynamicTextColorSecondary),
                        const SizedBox(width: 4),
                        Text(
                          'Previous Scan',
                          style: TextStyle(
                              fontSize: 12, color: context.dynamicTextColorSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildPreviousImage(context),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.isDarkMode ? Colors.white24 : AppColors.Black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Severity: $previousSeverity',
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Previous Date',
                      style:
                          TextStyle(fontSize: 11, color: context.dynamicTextColorSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Current Scan
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.camera_alt_outlined,
                            size: 14, color: context.dynamicTextColorSecondary),
                        const SizedBox(width: 4),
                        Text(
                          'Current Scan',
                          style: TextStyle(
                              fontSize: 12, color: context.dynamicTextColorSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.Turqouoise, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildCurrentImage(context),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: context.isDarkMode ? Colors.white24 : AppColors.Black,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Severity: $currentSeverity',
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Today',
                      style:
                          TextStyle(fontSize: 11, color: context.dynamicTextColorSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousImage(BuildContext context) {
    if (previousImageUrl != null && previousImageUrl!.isNotEmpty) {
      final fullUrl = previousImageUrl!.startsWith('http')
          ? previousImageUrl!
          : 'https://dermalyze-backend-final-main-production.up.railway.app/$previousImageUrl';
      return CachedNetworkImage(
        imageUrl: fullUrl,
        height: 130,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => _buildPreviousFallback(context),
      );
    }
    return _buildPreviousFallback(context);
  }

  Widget _buildPreviousFallback(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(context.isDarkMode ? 0.35 : 0.75),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.warning_amber_rounded, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentImage(BuildContext context) {
    if (currentImageFile != null) {
      return Image.file(
        currentImageFile!,
        height: 126, // accounts for the border thickness
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _buildCurrentFallback(context),
      );
    }
    return _buildCurrentFallback(context);
  }

  Widget _buildCurrentFallback(BuildContext context) {
    return Container(
      height: 126,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF0FFF0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(context.isDarkMode ? 0.35 : 0.75),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Icon(Icons.check_circle_outline, color: Colors.white, size: 24),
          ),
        ),
      ),
    );
  }
}