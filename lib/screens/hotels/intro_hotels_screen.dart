import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class IntroHotelsScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const IntroHotelsScreen({
    super.key,
    required this.onFinish,
  });

  @override
  State<IntroHotelsScreen> createState() => _IntroHotelsScreenState();
}

class _IntroHotelsScreenState extends State<IntroHotelsScreen> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.asset(
      "assets/videos/hotels_intro.mp4",
    )..initialize().then((_) {
        setState(() {});
        controller
          ..play()
          ..setLooping(true)
          ..setVolume(0);
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          /// 🎬 VIDEO FULLSCREEN
          if (controller.value.isInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
            ),

          /// 🌑 OVERLAY PREMIUM
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.12),
                    Colors.black.withValues(alpha: 0.22),
                    Colors.black.withValues(alpha: 0.88),
                  ],
                ),
              ),
            ),
          ),

          /// 🏨 CONTENIDO
          Positioned(
            left: 24,
            right: 24,
            bottom: bottomSafe + 105,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ICONO FEATURE
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.blueAccent.withValues(alpha: 0.25),
                    ),
                  ),
                  child: const Icon(
                    Icons.hotel_rounded,
                    color: Colors.blueAccent,
                    size: 30,
                  ),
                ),

                const SizedBox(height: 24),

                /// TITULO
                const Text(
                  "Viaja sin\nlímites",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                    letterSpacing: -1,
                  ),
                ),

                const SizedBox(height: 14),

                /// SUBTITULO
                Text(
                  "Encuentra hoteles pet-friendly y hospédate donde tu mascota también sea bienvenida.",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 28),

                /// BOTON PREMIUM
                GestureDetector(
                  onTap: widget.onFinish,
                  child: Container(
                    height: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF66B2FF),
                          Color(0xFF007AFF),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF007AFF)
                              .withValues(alpha: 0.35),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "Buscar hoteles",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}