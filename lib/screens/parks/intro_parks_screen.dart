import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'parks_screen.dart';

class IntroParksScreen extends StatelessWidget {
  const IntroParksScreen({super.key});

  Future<void> _finishIntro(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_parks_intro', true);

    /// 🔥 FIX WARNING
    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const ParksScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [

          /// 🌳 IMAGEN FONDO
          Positioned.fill(
            child: Image.network(
              "https://images.unsplash.com/photo-1506744038136-46273834b3fb",
              fit: BoxFit.cover,
            ),
          ),

          /// 🌑 GRADIENTE PRO
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

                  /// 🌳 TÍTULO
                  const Text(
                    "Explora parques 🐾",
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
                    "Encuentra los mejores lugares para pasear con tu mascota cerca de ti.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// 🔘 BOTÓN
                  GestureDetector(
                    onTap: () => _finishIntro(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.green, Colors.teal],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.4),
                            blurRadius: 20,
                          )
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Explorar parques",
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
          ),
        ],
      ),
    );
  }
}