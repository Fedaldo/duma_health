import 'package:duma_health/theme/config.dart';
import 'package:flutter/material.dart';

class BgCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {

    Paint paint0 = Paint()
      ..color = ThemeConfig.lightPrimary
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;


    Path path0 = Path();
    path0.moveTo(0,size.height*0.7089691);
    path0.cubicTo(size.width*0.1338000,size.height*0.5222938,size.width*0.1995000,size.height*0.4941624,size.width*0.3010800,size.height*0.4515206);
    path0.cubicTo(size.width*0.5267000,size.height*0.3708505,size.width*0.5134800,size.height*0.3747809,size.width*0.7019600,size.height*0.3243428);
    path0.quadraticBezierTo(size.width*0.8494800,size.height*0.2664046,size.width*0.9991200,size.height*0.1295876);
    path0.lineTo(size.width,0);
    path0.lineTo(0,0);
    path0.quadraticBezierTo(0,size.height*0.1772423,0,size.height*0.7089691);
    path0.close();

    canvas.drawPath(path0, paint0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}
