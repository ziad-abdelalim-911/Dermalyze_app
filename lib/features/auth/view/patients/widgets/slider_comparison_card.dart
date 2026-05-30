import 'dart:io';
import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SliderComparisonCard extends StatefulWidget {
  final File? currentImageFile;
  final String? previousImageUrl;
  final String previousSeverity;
  final String currentSeverity;

  const SliderComparisonCard({
    super.key,
    this.currentImageFile,
    this.previousImageUrl,
    required this.previousSeverity,
    required this.currentSeverity,
  });

  @override
  State<SliderComparisonCard> createState() => _SliderComparisonCardState();
}

class _SliderComparisonCardState extends State<SliderComparisonCard> {
  double _sliderValue = 0.5;

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
            'Slider Comparison',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: context.dynamicTextColorPrimary,
            ),
          ),
          const SizedBox(height: 14),
          // Comparison Box
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 180,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final dividerX = width * _sliderValue;
                  return GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        _sliderValue =
                            (_sliderValue + details.delta.dx / width)
                                .clamp(0.0, 1.0);
                      });
                    },
                    child: Stack(
                      children: [
                        // Previous
                        SizedBox(
                          width: width,
                          height: 180,
                          child: _buildPreviousImage(context),
                        ),
                        // Current - clipped
                        ClipRect(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            widthFactor: _sliderValue,
                            child: SizedBox(
                              width: width,
                              height: 180,
                              child: _buildCurrentImage(context, width),
                            ),
                          ),
                        ),
                        // Labels
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Previous',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 11),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Current',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 11),
                            ),
                          ),
                        ),
                        // Divider Line
                        Positioned(
                          left: dividerX - 1,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 2,
                            color: AppColors.SkyBlue,
                          ),
                        ),
                        // Drag Handle
                        Positioned(
                          left: dividerX - 16,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.SkyBlue,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.compare_arrows,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Drag or click to compare',
              style: TextStyle(fontSize: 12, color: context.dynamicTextColorSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousImage(BuildContext context) {
    if (widget.previousImageUrl != null && widget.previousImageUrl!.isNotEmpty) {
      final fullUrl = widget.previousImageUrl!.startsWith('http')
          ? widget.previousImageUrl!
          : 'https://dermalyze-backend-final-main-production.up.railway.app/${widget.previousImageUrl}';
      return CachedNetworkImage(
        imageUrl: fullUrl,
        width: double.infinity,
        height: 180,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => _buildPreviousFallback(context),
      );
    }
    return _buildPreviousFallback(context);
  }

  Widget _buildPreviousFallback(BuildContext context) {
    return Container(
      color: context.isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFF5F5F5),
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(context.isDarkMode ? 0.35 : 0.75),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
                const SizedBox(height: 4),
                Text(
                  widget.previousSeverity,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentImage(BuildContext context, double width) {
    if (widget.currentImageFile != null) {
      return Image.file(
        widget.currentImageFile!,
        width: width,
        height: 180,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _buildCurrentFallback(context, width),
      );
    }
    return _buildCurrentFallback(context, width);
  }

  Widget _buildCurrentFallback(BuildContext context, double width) {
    return Container(
      width: width,
      color: context.isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF0FFF0),
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(context.isDarkMode ? 0.35 : 0.75),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
                const SizedBox(height: 4),
                Text(
                  widget.currentSeverity,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}