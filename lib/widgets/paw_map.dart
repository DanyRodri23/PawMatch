import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Mapa decorativo con una patita como pin (para la pantalla de ubicación).
class PawMap extends StatelessWidget {
  final Animation<double> animation;
  final bool found;

  const PawMap({super.key, required this.animation, this.found = false});

  @override
  Widget build(BuildContext context) {
    final color = found ? Colors.green : Colors.black;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: SizedBox(
        height: 240,
        width: double.infinity,
        child: LayoutBuilder(
          builder: (context, box) {
            final w = box.maxWidth;

            return AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                final t = animation.value;
                final bob = -6 * math.sin(t * 2 * math.pi);

                return Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: _MapPainter()),
                    ),

                    // Ondas en el suelo, bajo el pin
                    ...List.generate(3, (i) {
                      final p = (t + i / 3) % 1.0;
                      final size = 30 + 150 * p;

                      return Positioned(
                        left: w / 2 - size / 2,
                        top: 156 - size * 0.18,
                        child: Container(
                          width: size,
                          height: size * 0.36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: color.withValues(alpha: (1 - p) * 0.45),
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }),

                    // Sombra del pin
                    Positioned(
                      left: w / 2 - 14,
                      top: 152,
                      child: Container(
                        width: 28,
                        height: 9,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // Pin con patita
                    Positioned(
                      left: w / 2 - 30,
                      top: 78 + bob,
                      child: Transform.rotate(
                        angle: -math.pi / 4,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: color.withValues(alpha: 0.35),
                                blurRadius: 16,
                                offset: const Offset(4, 8),
                              ),
                            ],
                          ),
                          child: Transform.rotate(
                            angle: math.pi / 4,
                            child: Icon(
                              found ? Icons.check_rounded : Icons.pets,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Fondo
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFF1F0EA),
    );

    // Parques
    final park = Paint()..color = const Color(0xFFD9EBCB);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.04, h * 0.08, w * 0.26, h * 0.30),
        const Radius.circular(18),
      ),
      park,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.70, h * 0.62, w * 0.26, h * 0.30),
        const Radius.circular(18),
      ),
      park,
    );

    // Río
    final river = Path()
      ..moveTo(-10, h * 0.78)
      ..cubicTo(w * 0.25, h * 0.62, w * 0.45, h * 0.98, w * 0.7, h * 0.80)
      ..cubicTo(w * 0.85, h * 0.70, w * 0.95, h * 0.78, w + 10, h * 0.72);
    canvas.drawPath(
      river,
      Paint()
        ..color = const Color(0xFFCFE5F2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22
        ..strokeCap = StrokeCap.round,
    );

    // Calles
    final road = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final thin = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(-10, h * 0.45), Offset(w + 10, h * 0.40), road);
    canvas.drawLine(Offset(w * 0.34, -10), Offset(w * 0.40, h + 10), road);
    canvas.drawLine(Offset(w * 0.66, -10), Offset(w * 0.60, h + 10), thin);
    canvas.drawLine(Offset(-10, h * 0.15), Offset(w + 10, h * 0.20), thin);

    final curve = Path()
      ..moveTo(w * 0.40, h * 0.40)
      ..quadraticBezierTo(w * 0.62, h * 0.55, w * 0.95, h * 0.50);
    canvas.drawPath(curve, thin);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
