
import 'dart:math';

import 'package:flutter/material.dart';

class StampPainter extends CustomPainter {
  String country;
  String city;

  StampPainter({required this.country, required this.city});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;


    // Draw text along top and bottom of the circle
    drawTextAlongPath(canvas, size, country, paint, country.length>20? -pi/1.1:-pi/1.3, country.length>20?pi / 1: pi/2);
    drawTextAlongPath(canvas, size, city, paint, pi /3.5, country.length>20? pi / 1.45: pi/2, true);

    // Draw stars as dividers
    // drawStar(canvas, size, paint, -pi /1.2, size.width / 2 - 30);
    // drawStar(canvas, size, paint, pi /5, size.width / 2 - 30);
  }

  void drawTextAlongPath(Canvas canvas, Size size, String text, Paint paint, double startAngle, double sweepAngle, [bool reverse = false]) {
    TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: country.length>20?6: 8,
      fontWeight: FontWeight.bold,
    );

    final double radius = size.width / 2 - 16;
    final double totalAngle = sweepAngle;
    final double charAngle = totalAngle / text.length;
    double angle = startAngle;

    for (int i = 0; i < text.length; i++) {
      final String char = reverse ? text[text.length - 1 - i] : text[i];
      final TextPainter textPainter = TextPainter(
        text: TextSpan(text: char, style: textStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();

      final double x = size.width / 2 + radius * cos(angle);
      final double y = size.height / 2 + radius * sin(angle);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + (reverse ? pi : 0) + pi / 2);
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();

      angle += charAngle;
    }
  }

  void drawStar(Canvas canvas, Size size, Paint paint, double angle, double radius) {
    const double starRadius = 10;
    final Offset center = Offset(
      size.width / 2 + radius * cos(angle),
      size.height / 2 + radius * sin(angle),
    );
    final Path path = Path();
    for (int i = 0; i < 5; i++) {
      final double starAngle = (pi / 2) + (2 * pi * i / 5);
      final double x = center.dx + starRadius * cos(starAngle);
      final double y = center.dy - starRadius * sin(starAngle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
