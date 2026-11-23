import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Fondo de chat: huellitas, pelotas y huesitos en gris sobre negro.
class PawPattern extends StatelessWidget {
  final Color color;
  final double opacity;
  const PawPattern({
    super.key,
    this.color = Colors.white,
    this.opacity = 0.055,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: _PawPainter(color.withValues(alpha: opacity)),
        size: Size.infinite,
      ),
    );
  }
}

class _PawPainter extends CustomPainter {
  final Color color;
  _PawPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..color = color;
    final line = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    const cell = 78.0;
    final rows = (size.height / cell).ceil() + 1;
    final cols = (size.width / cell).ceil() + 1;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final seed = (r * 31 + c * 17) % 7;
        final dx = (r.isOdd ? cell / 2 : 0) + (seed - 3) * 3.0;
        final dy = ((c * 13 + r * 5) % 5 - 2) * 3.0;
        final center = Offset(c * cell + dx, r * cell + dy);
        final angle = ((seed * 47 + r * 11 + c * 23) % 360) * math.pi / 180;
        final kind = (r * 3 + c * 5 + seed) % 5;

        canvas.save();
        canvas.translate(center.dx, center.dy);
        canvas.rotate(angle);
        if (kind <= 2) {
          _paw(canvas, fill, 1.0);
        } else if (kind == 3) {
          _ball(canvas, line, fill);
        } else {
          _bone(canvas, fill);
        }
        canvas.restore();
      }
    }
  }

  void _paw(Canvas canvas, Paint p, double s) {
    // almohadilla
    final pad = Path()
      ..moveTo(0, -2)
      ..cubicTo(11, -2, 14, 8, 9, 12)
      ..cubicTo(5, 15, -5, 15, -9, 12)
      ..cubicTo(-14, 8, -11, -2, 0, -2)
      ..close();
    canvas.drawPath(pad, p);
    // deditos
    canvas.drawOval(Rect.fromCenter(center: const Offset(-12, -8), width: 7, height: 10), p);
    canvas.drawOval(Rect.fromCenter(center: const Offset(-4.5, -15), width: 7, height: 10), p);
    canvas.drawOval(Rect.fromCenter(center: const Offset(4.5, -15), width: 7, height: 10), p);
    canvas.drawOval(Rect.fromCenter(center: const Offset(12, -8), width: 7, height: 10), p);
  }

  void _ball(Canvas canvas, Paint line, Paint fill) {
    canvas.drawCircle(Offset.zero, 11, line);
    final arc1 = Path()
      ..addArc(Rect.fromCircle(center: const Offset(-13, 0), radius: 11), -0.9, 1.8);
    final arc2 = Path()
      ..addArc(Rect.fromCircle(center: const Offset(13, 0), radius: 11), math.pi - 0.9, 1.8);
    canvas.drawPath(arc1, line);
    canvas.drawPath(arc2, line);
  }

  void _bone(Canvas canvas, Paint p) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: 22, height: 6), const Radius.circular(3)),
      p,
    );
    for (final x in [-12.0, 12.0]) {
      canvas.drawCircle(Offset(x, -3.5), 4, p);
      canvas.drawCircle(Offset(x, 3.5), 4, p);
    }
  }

  @override
  bool shouldRepaint(covariant _PawPainter old) => old.color != color;
}
