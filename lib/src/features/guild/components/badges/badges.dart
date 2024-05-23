import 'dart:math';

import 'package:flutter/material.dart';

export 'community.dart';
export 'verified.dart';

class StarburstPainter extends CustomPainter {
  final Color color;
  StarburstPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();
    double radius = size.width / 2;
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    int numPoints = 14;
    double angle = (2 * pi) / numPoints;

    for (int i = 0; i < numPoints; i++) {
      double outerX = centerX + radius * cos(i * angle);
      double outerY = centerY + radius * sin(i * angle);
      double innerX = centerX + radius * 0.86 * cos((i + 0.5) * angle);
      double innerY = centerY + radius * 0.86 * sin((i + 0.5) * angle);

      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}