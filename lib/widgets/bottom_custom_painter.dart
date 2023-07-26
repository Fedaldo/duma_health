import 'package:duma_health/theme/config.dart';
import 'package:flutter/material.dart';

class BottomCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = ThemeConfig.lightPrimary
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path0 = Path();
    path0.moveTo(0, size.height);
    path0.lineTo(0, size.height * 0.2500000);
    path0.quadraticBezierTo(size.width * 0.1869750, size.height * 0.1602500,
        size.width * 0.2494750, size.height * 0.0977500);
    path0.cubicTo(
        size.width * 0.3752125,
        size.height * 0.0007000,
        size.width * 0.3739250,
        size.height * 0.1369500,
        size.width * 0.3754000,
        size.height * 0.2521000);
    path0.cubicTo(
        size.width * 0.3747375,
        size.height * 0.9438500,
        size.width * 0.6243000,
        size.height * 0.9451000,
        size.width * 0.6250000,
        size.height * 0.2500000);
    path0.cubicTo(
        size.width * 0.6255125,
        size.height * 0.1289000,
        size.width * 0.6258000,
        size.height * 0.0043500,
        size.width * 0.7500250,
        size.height * 0.0929500);
    path0.quadraticBezierTo(size.width * 0.8125250, size.height * 0.1554500,
        size.width, size.height * 0.2500000);
    path0.lineTo(size.width, size.height);
    path0.lineTo(0, size.height);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
