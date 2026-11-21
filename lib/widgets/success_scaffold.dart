import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Pantalla de "éxito" con foto, huellitas flotando y resumen.
class SuccessScaffold extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final List<SuccessChip> chips;
  final String buttonText;
  final Future<void> Function() onContinue;

  const SuccessScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onContinue,
    this.imageUrl,
    this.chips = const [],
  });

  @override
  State<SuccessScaffold> createState() => _SuccessScaffoldState();
}

class SuccessChip {
  final IconData icon;
  final String text;
  const SuccessChip(this.icon, this.text);
}

class _SuccessScaffoldState extends State<SuccessScaffold>
    with TickerProviderStateMixin {
  late final AnimationController _enter;
  late final AnimationController _float;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    _enter = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..forward();
    _float = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
  }

  @override
  void dispose() {
    _enter.dispose();
    _float.dispose();
    super.dispose();
  }

  Animation<double> _interval(double a, double b) => CurvedAnimation(
        parent: _enter,
        curve: Interval(a, b, curve: Curves.easeOutCubic),
      );

  Widget _fadeUp(Animation<double> anim, Widget child) {
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      ),
    );
  }

  Widget _avatar() {
    final url = widget.imageUrl;
    final hasImage = url != null && url.isNotEmpty;

    return Container(
      width: 132,
      height: 132,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.white, width: 5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.pets, size: 56, color: Colors.black38),
            )
          : const Icon(Icons.pets, size: 56, color: Colors.black38),
    );
  }

  Widget _hero() {
    final pop = CurvedAnimation(
      parent: _enter,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );

    // Huellitas decorativas: ángulo, distancia, tamaño
    const paws = [
      [-2.5, 100.0, 22.0],
      [-0.9, 108.0, 16.0],
      [0.5, 104.0, 24.0],
      [2.0, 98.0, 18.0],
      [3.4, 110.0, 14.0],
    ];

    return SizedBox(
      height: 250,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: Listenable.merge([_enter, _float]),
        builder: (context, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Halo verde
              Container(
                width: 220 * _enter.value.clamp(0.0, 1.0),
                height: 220 * _enter.value.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.green.withValues(alpha: 0.18),
                      Colors.green.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),

              // Huellitas flotando
              for (var i = 0; i < paws.length; i++)
                Transform.translate(
                  offset: Offset(
                    math.cos(paws[i][0]) * paws[i][1] * pop.value,
                    math.sin(paws[i][0]) * paws[i][1] * 0.8 * pop.value +
                        math.sin(_float.value * 2 * math.pi + i) * 5,
                  ),
                  child: Opacity(
                    opacity: _interval(0.3, 0.8).value,
                    child: Transform.rotate(
                      angle: paws[i][0],
                      child: Icon(
                        Icons.pets,
                        size: paws[i][2],
                        color: Colors.black.withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                ),

              // Foto + check
              Transform.scale(
                scale: pop.value.clamp(0.0, 1.2),
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      _avatar(),
                      Positioned(
                        right: 2,
                        bottom: 4,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _tap() async {
    if (busy) return;
    setState(() => busy = true);
    await widget.onContinue();
    if (mounted) setState(() => busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _hero(),
                        const SizedBox(height: 8),
                        _fadeUp(
                          _interval(0.45, 0.85),
                          Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _fadeUp(
                          _interval(0.55, 0.95),
                          Text(
                            widget.subtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),
                        ),
                        if (widget.chips.isNotEmpty) ...[
                          const SizedBox(height: 22),
                          _fadeUp(
                            _interval(0.65, 1.0),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 10,
                              runSpacing: 10,
                              children: [
                                for (final c in widget.chips)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(c.icon,
                                            size: 17, color: Colors.black87),
                                        const SizedBox(width: 7),
                                        Text(
                                          c.text,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: busy ? null : _tap,
                  child: busy
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          widget.buttonText,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
