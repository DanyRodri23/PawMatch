import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../chats/chat_detail_page.dart';

class MatchSuccessScreen extends StatefulWidget {
  final String myPet;
  final String otherPet;
  final String image1;
  final String image2;
  final Map<String, dynamic>? matchPet;

  const MatchSuccessScreen({
    super.key,
    this.matchPet,
    required this.myPet,
    required this.otherPet,
    required this.image1,
    required this.image2,
  });

  @override
  State<MatchSuccessScreen> createState() => _MatchSuccessScreenState();
}

class _MatchSuccessScreenState extends State<MatchSuccessScreen>
    with TickerProviderStateMixin {
  late final ConfettiController confetti;
  late final AnimationController intro; // entrada de fotos y textos
  late final AnimationController pulse; // latido del corazón

  late final Animation<double> photos;
  late final Animation<double> heart;
  late final Animation<double> texts;

  @override
  void initState() {
    super.initState();

    confetti = ConfettiController(duration: const Duration(seconds: 3));

    intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    photos = CurvedAnimation(
      parent: intro,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
    );
    heart = CurvedAnimation(
      parent: intro,
      curve: const Interval(0.45, 0.8, curve: Curves.elasticOut),
    );
    texts = CurvedAnimation(
      parent: intro,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      intro.forward();
      confetti.play();
    });
  }

  @override
  void dispose() {
    confetti.dispose();
    intro.dispose();
    pulse.dispose();
    super.dispose();
  }

  void openChat() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailPage(
          name: widget.otherPet,
          image: widget.image2,
          fromMatch: true,
          matchPet: widget.matchPet,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cardW = math.min(w * 0.40, 190.0);
    final cardH = cardW * 1.32;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: Stack(
        children: [
          // Fondo con brillo rosa
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.25),
                  radius: 1.1,
                  colors: [Color(0xFF5A1236), Color(0xFF1A0A14), Color(0xFF0B0B0F)],
                  stops: [0, 0.55, 1],
                ),
              ),
            ),
          ),

          // Huellitas de fondo
          for (final p in const [
            [0.10, 0.08, 34.0, -0.4],
            [0.82, 0.12, 26.0, 0.5],
            [0.06, 0.62, 28.0, 0.3],
            [0.88, 0.58, 38.0, -0.3],
            [0.50, 0.04, 22.0, 0.2],
          ])
            Positioned(
              left: w * p[0],
              top: MediaQuery.of(context).size.height * p[1],
              child: Transform.rotate(
                angle: p[3],
                child: Icon(Icons.pets,
                    size: p[2], color: Colors.white.withValues(alpha: 0.05)),
              ),
            ),

          // Confeti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confetti,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.04,
              numberOfParticles: 14,
              gravity: 0.2,
              maxBlastForce: 22,
              minBlastForce: 8,
              colors: const [
                Colors.pinkAccent,
                Colors.white,
                Color(0xFFFF9CC4),
                Colors.amber,
              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Fotos inclinadas + corazón
                  AnimatedBuilder(
                    animation: Listenable.merge([intro, pulse]),
                    builder: (context, _) {
                      final slide = (1 - photos.value) * 140;
                      final beat = 1 + pulse.value * 0.08;
                      return SizedBox(
                        height: cardH + 30,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Transform.translate(
                              offset: Offset(-cardW * 0.46 - slide, 0),
                              child: Transform.rotate(
                                angle: -0.13,
                                child: _photoCard(widget.image1, cardW, cardH),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(cardW * 0.46 + slide, 0),
                              child: Transform.rotate(
                                angle: 0.13,
                                child: _photoCard(widget.image2, cardW, cardH),
                              ),
                            ),
                            Transform.scale(
                              scale: heart.value.clamp(0.0, 1.4) * beat,
                              child: Container(
                                width: 74,
                                height: 74,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFFF5C9A),
                                      Color(0xFFE91E63),
                                    ],
                                  ),
                                  border: Border.all(
                                      color: const Color(0xFF0B0B0F), width: 5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.pinkAccent
                                          .withValues(alpha: 0.6),
                                      blurRadius: 28,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.favorite_rounded,
                                    color: Colors.white, size: 36),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 34),

                  // Textos
                  FadeTransition(
                    opacity: texts,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.25),
                        end: Offset.zero,
                      ).animate(texts),
                      child: Column(
                        children: [
                          ShaderMask(
                            shaderCallback: (r) => const LinearGradient(
                              colors: [Color(0xFFFFB3D1), Color(0xFFFF4D94)],
                            ).createShader(r),
                            child: const Text(
                              "¡Es un match!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 44,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16.5,
                                height: 1.4,
                              ),
                              children: [
                                TextSpan(
                                  text: widget.myPet,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const TextSpan(text: " y "),
                                TextSpan(
                                  text: widget.otherPet,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const TextSpan(
                                    text: " se gustaron.\n¡Rompe el hielo! 🐾"),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Botones
                  FadeTransition(
                    opacity: texts,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: openChat,
                          child: Container(
                            width: double.infinity,
                            height: 58,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF5C9A), Color(0xFFE91E63)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      Colors.pinkAccent.withValues(alpha: 0.45),
                                  blurRadius: 22,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat_bubble_rounded,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  "Enviar mensaje",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Seguir explorando",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoCard(String url, double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white, width: 3.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFF22222A),
            child: const Icon(Icons.pets, color: Colors.white24, size: 50),
          ),
        ),
      ),
    );
  }
}
