import 'dart:ui';
import 'package:flutter/material.dart';

class FadePainter extends CustomPainter {
  final double height; 
  final Alignment begin;
  final Alignment end;
  final bool reverse;  // new param

  FadePainter({
    required this.height,
    required this.begin,
    required this.end,
    this.reverse = false,  // default false (normal fade)
  });

  @override
  void paint(Canvas canvas, Size size) {
    final List<Color> colors = reverse
      ? [
          Color.fromARGB(255, 0, 0, 0),    // opaque at start (top)
          Color.fromARGB(0, 65, 65, 65),   // semi-transparent
          Color.fromARGB(0, 255, 255, 255),// transparent at end (bottom)
        ]
      : [
          Color.fromARGB(0, 255, 255, 255),  
          Color.fromARGB(0, 65, 65, 65), 
          Color.fromARGB(255, 0, 0, 0), 
        ];

    final Paint paint = Paint()
      ..shader = LinearGradient(
        begin: begin,
        end: end,
        colors: colors,
        stops: [0.0, 0.5, 1.0], 
      ).createShader(
          Rect.fromLTWH(0, size.height * height, size.width, size.height * (1 - height)));

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}