import 'package:flutter/material.dart';

class WhatsAppStyles {
  // --- Colors (Blue Identity) ---
  static const Color lightSentBubble = Color(0xFFE3F2FD); // Very light blue
  static const Color darkSentBubble = Color(0xFF1565C0);   // Deeper blue
  
  static const Color lightReceivedBubble = Colors.white;
  static const Color darkReceivedBubble = Color(0xFF1E293B);

  static const Color lightChatBg = Color(0xFFF0F4F8); // Very light grey-blue
  static const Color darkChatBg = Color(0xFF0F172A);

  // --- Helpers ---
  static Color getSentBubbleColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark 
        ? const Color(0xFF005C4B).withOpacity(0.8) // WhatsApp dark sent green but let's use blue
        : const Color(0xFFE7FFDB); // WhatsApp light sent green
  }
  
  // Actually, user wants Blue identity. Let's stick to blue-ish variants.
  static Color getAppSentBubbleColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF1E3A8A) : const Color(0xFFDBEAFE);
  }

  static Color getAppReceivedBubbleColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF1E293B) : Colors.white;
  }
}

/// A CustomPainter to draw the WhatsApp bubble "nip" (the triangle tip).
class BubblePainter extends CustomPainter {
  final Color color;
  final bool isMe;

  BubblePainter({required this.color, required this.isMe});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    if (isMe) {
      // Right side tip (Sent message)
      path.moveTo(size.width - 15, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width - 15, 15);
      path.close();
    } else {
      // Left side tip (Received message)
      path.moveTo(15, 0);
      path.lineTo(0, 0);
      path.lineTo(15, 15);
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
