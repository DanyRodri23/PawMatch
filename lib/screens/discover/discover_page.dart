import 'package:flutter/material.dart';
import 'dart:ui';
import 'discover_results_page.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  Widget categoryCard(
    BuildContext context,
    String title,
    String emoji,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiscoverResultsPage(
              goal: title,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// 🔥 ICONO
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.2),
                  ),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),

                const SizedBox(height: 12),

                /// 🔥 TEXTO
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              /// 🔥 TITULO
              const Text(
                "Descubre",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "¿Qué busca tu mascota?",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,

                  children: [

                    categoryCard(context, "Compañero de juego", "🐾", Colors.blue),
                    categoryCard(context, "Socializar", "🐕", Colors.orange),
                    categoryCard(context, "Compañero de paseo", "🦮", Colors.green),
                    categoryCard(context, "Actividades", "🎾", Colors.purple),
                    categoryCard(context, "Nuevos amigos", "🐶", Colors.pink),
                    categoryCard(context, "Reproducción", "❤️", Colors.red),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}