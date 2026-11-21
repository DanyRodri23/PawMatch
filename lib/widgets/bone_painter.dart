import 'package:flutter/material.dart';

/// Dibuja un hueso horizontal (para decorar pantallas de mascotas).
class BonePainter extends CustomPainter {
  final Color color;
  final Color shadowColor;

  const BonePainter({
    this.color = Colors.white,
    this.shadowColor = Colors.black26,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final r = h * 0.22; // radio de las puntas
    final cx = r * 1.25; // centro X de las puntas
    final dy = h * 0.27; // separación vertical de las puntas

    // Cuerpo del hueso
    var path = Path()
      ..addRRect(
        RRect.fromLTRBR(
          cx,
          h * 0.22,
          w - cx,
          h * 0.78,
          Radius.circular(h * 0.12),
        ),
      );

  // Cuatro puntas redondas
    for (final x in [cx, w - cx]) {
      for (final y in [h / 2 - dy, h / 2 + dy]) {
        path = Path.combine(
          PathOperation.union,
          path,
          Path()..addOval(Rect.fromCircle(center: Offset(x, y), radius: r)),
        );
      }
    }

    canvas.drawShadow(path, shadowColor, 4, false);
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(BonePainter old) =>
      old.color != color || old.shadowColor != shadowColor;
}
