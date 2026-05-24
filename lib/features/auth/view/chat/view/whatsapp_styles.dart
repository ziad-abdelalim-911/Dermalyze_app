import 'package:flutter/material.dart';

class WhatsAppStyles {
  // Light mode colors
  static const Color lightChatBg      = Color(0xFFEEF2F6);
  static const Color sentBubbleLight  = Color(0xFFDCF8C6);
  static const Color recvBubbleLight  = Color(0xFFFFFFFF);

  // Dark mode colors
  static const Color darkChatBg       = Color(0xFF0D1117);
  static const Color sentBubbleDark   = Color(0xFF2B5278);
  static const Color recvBubbleDark   = Color(0xFF1E2D3D);

  static Color getChatBg(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? darkChatBg : lightChatBg;
  }

  static Color getAppSentBubbleColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? sentBubbleDark : sentBubbleLight;
  }

  static Color getAppReceivedBubbleColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? recvBubbleDark : recvBubbleLight;
  }
}

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
      path.moveTo(size.width - 15, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width - 15, 15);
      path.close();
    } else {
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
