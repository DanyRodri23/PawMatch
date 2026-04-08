import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'hotels_screen.dart';

class IntroHotelsScreen extends StatelessWidget {
  const IntroHotelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [

          /// 🌄 IMAGEN DE FONDO
          Positioned.fill(
            child: Image.network(
              "https://images.unsplash.com/photo-1566073771259-6a8506099945",
              fit: BoxFit.cover,
            ),
          ),

          /// 🌑 OVERLAY MÁS PRO
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.85),
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
          ),

          /// 📱 CONTENIDO
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Spacer(),

                  /// 🏨 TÍTULO
                  const Text(
                    "Pet-Friendly Hotels 🏨",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// 📄 DESCRIPCIÓN
                  const Text(
                    "Encuentra hoteles ideales para ti y tu mascota.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 🔘 BOTÓN
                  GestureDetector(
                    onTap: () async {

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('seenHotelsIntro', true);

                      /// 🔥 FIX WARNING
                      if (!context.mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HotelsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withValues(alpha: 0.4),
                            blurRadius: 20,
                          )
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Explorar hoteles",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}