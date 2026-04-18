import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SliderComparisonCard extends StatefulWidget {
  const SliderComparisonCard({super.key});

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
              color: AppColors.Black,
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
                        // Previous (Red)
                        Container(
                          color: const Color(0xFFF5F5F5),
                          child: Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFCDD2),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        // Current (Green) - clipped
                        ClipRect(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            widthFactor: _sliderValue,
                            child: Container(
                              width: width,
                              color: const Color(0xFFF0FFF0),
                              child: Center(
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFC8F5C8),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Labels
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Previous',
                              style: TextStyle(
                                  color: Theme.of(context).cardColor, fontSize: 11),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Current',
                              style: TextStyle(
                                  color: Theme.of(context).cardColor, fontSize: 11),
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
                              ),
                              child: Icon(
                                Icons.compare_arrows,
                                color: Theme.of(context).cardColor,
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
              style: TextStyle(fontSize: 12, color: AppColors.Gray),
            ),
          ),
        ],
      ),
    );
  }
}