import 'package:flutter/material.dart';
import '../helpers/pet_flow_helper.dart';
import 'pet_progress_bar.dart';

/// Base de todas las pantallas del registro de la mascota:
/// barra de progreso arriba, encabezado, contenido y botón abajo.
class PetStepScaffold extends StatelessWidget {
  final String stepKey;
  final String emoji;
  final String title;
  final String subtitle;
  final Widget child;
  final String buttonText;
  final VoidCallback? onNext;
  final bool loading;
  final bool showBack;
  final bool scrollable;
  final Widget? footer;

  const PetStepScaffold({
    super.key,
    required this.stepKey,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.child,
    this.buttonText = "Continuar",
    this.onNext,
    this.loading = false,
    this.showBack = true,
    this.scrollable = true,
    this.footer,
  });

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 24, 0),
      child: Row(
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: showBack
                ? IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                    ),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                    onPressed: () => Navigator.maybePop(context),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PetProgressBar(
              step: PetFlowHelper.getStep(stepKey),
              totalSteps: PetFlowHelper.totalSteps,
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
      builder: (context, v, c) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 14 * (1 - v)), child: c),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _button() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: loading ? null : onNext,
        child: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              )
            : Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: scrollable
                  ? SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(24, 26, 24, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _header(),
                          const SizedBox(height: 26),
                          child,
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(24, 26, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _header(),
                          const SizedBox(height: 20),
                          Expanded(child: child),
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (footer != null) ...[
                    footer!,
                    const SizedBox(height: 8),
                  ],
                  _button(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta de opción (una sola selección).
class PetOptionCard extends StatelessWidget {
  final String? emoji;
  final IconData? icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const PetOptionCard({
    super.key,
    this.emoji,
    this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? Colors.black : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.14)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(17),
              ),
              child: emoji != null
                  ? Text(emoji!, style: const TextStyle(fontSize: 28))
                  : Icon(
                      icon,
                      size: 28,
                      color: selected ? Colors.white : Colors.black87,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: selected ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? Colors.white : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
