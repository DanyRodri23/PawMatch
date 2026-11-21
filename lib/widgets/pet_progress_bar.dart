import 'package:flutter/material.dart';

/// Barra de progreso del registro de la mascota.
/// Siempre se mide sobre la ruta completa (11 pasos); si se salta un paso
/// (mestizo, sin vacunas) la barra simplemente avanza más. Nunca retrocede.
class PetProgressBar extends StatelessWidget {
  final int step;
  final int totalSteps;

  const PetProgressBar({
    super.key,
    required this.step,
    this.totalSteps = 11,
  });

  @override
  Widget build(BuildContext context) {
    final to = (step / totalSteps).clamp(0.0, 1.0);
    final from = ((step - 1) / totalSteps).clamp(0.0, 1.0);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: from, end: to),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            color: Colors.black,
          ),
        );
      },
    );
  }
}
