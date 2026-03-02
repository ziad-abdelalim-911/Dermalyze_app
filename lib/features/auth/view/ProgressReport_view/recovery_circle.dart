import 'package:flutter/material.dart';
import 'dart:math';

class RecoveryCircle extends StatelessWidget {
  final int percent;

  const RecoveryCircle({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,

      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(70, 70),
            painter: CirclePainter(percent: percent),
          ),

          const Icon(Icons.trending_up, color: Colors.white, size: 24),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final int percent;

  CirclePainter({required this.percent});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final radius = (size.width / 2) - (bgPaint.strokeWidth / 2);

    /// background

    canvas.drawCircle(center, radius, bgPaint);

    /// progress
    final progressPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * (percent / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
