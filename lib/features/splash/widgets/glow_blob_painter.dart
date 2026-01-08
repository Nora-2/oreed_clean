
/*------------------------ خلفية Blobs أنيقة ------------------------*/
import 'dart:math' as math;

import 'package:flutter/material.dart';

class GlowBlobsPainter extends CustomPainter {
  final double progress;
  final Color base;
  final Color alt;

  GlowBlobsPainter({
    required this.progress,
    required this.base,
    required this.alt,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // مواقع متحركة ناعمة
    final p1 = Offset(
      size.width * (0.22 + 0.06 * math.sin(progress * 2 * math.pi)),
      size.height * (0.28 + 0.03 * math.cos(progress * 2 * math.pi)),
    );
    final p2 = Offset(
      size.width * (0.78 + 0.05 * math.cos(progress * 2 * math.pi)),
      size.height * (0.68 + 0.05 * math.sin(progress * 2 * math.pi)),
    );
    final p3 = Offset(
      size.width * (0.50 + 0.04 * math.sin(progress * 2 * math.pi + 1.2)),
      size.height * (0.10 + 0.02 * math.cos(progress * 2 * math.pi + .6)),
    );

    Paint blob(Color c, Offset o, double r, double op) => Paint()
      ..shader = RadialGradient(
        colors: [c.withOpacity(op), c.withOpacity(0)],
      ).createShader(Rect.fromCircle(center: o, radius: r));

    canvas.drawCircle(
      p1,
      size.shortestSide * .40,
      blob(base, p1, size.shortestSide * .40, .30),
    );
    canvas.drawCircle(
      p2,
      size.shortestSide * .46,
      blob(alt, p2, size.shortestSide * .46, .28),
    );
    canvas.drawCircle(
      p3,
      size.shortestSide * .30,
      blob(const Color(0xFF60A5FA), p3, size.shortestSide * .30, .18),
    );
  }

  @override
  bool shouldRepaint(covariant GlowBlobsPainter old) =>
      old.progress != progress || old.base != base || old.alt != alt;
}
