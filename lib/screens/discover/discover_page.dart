import 'package:flutter/material.dart';
import 'discover_results_page.dart';

/// Explorar: categorías para encontrar mascotas que buscan lo mismo.
class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  static const Color _bg = Color(0xFF0B0B0F);

  void _open(BuildContext context, String title,
      {String? goal, bool pedigree = false, double? km}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DiscoverResultsPage(
          title: title,
          goal: goal,
          pedigree: pedigree,
          km: km,
        ),
      ),
    );
  }

  Widget _card(
    BuildContext context, {
    required String title,
    required String sub,
    required String emoji,
    required Color color,
    String? goal,
    bool pedigree = false,
    double? km,
  }) {
    return GestureDetector(
      onTap: () => _open(context, title, goal: goal, pedigree: pedigree, km: km),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          color: const Color(0xFF16161C),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              Positioned(
                top: -30,
                left: -10,
                right: -10,
                height: 190,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        color.withValues(alpha: 0.45),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 22,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 70),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 12,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      sub,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20, 12, 20, bottom + 24),
          children: [
            const Text(
              "Explorar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Encuentra mascotas que buscan lo mismo que la tuya.",
              style: TextStyle(color: Colors.white60, fontSize: 15),
            ),
            const SizedBox(height: 22),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.82,
              children: [
                _card(context,
                    title: "Compañero de juego",
                    sub: "Para correr y jugar",
                    emoji: "🎾",
                    color: Colors.blueAccent,
                    goal: "Compañero de juego"),
                _card(context,
                    title: "Nuevos amigos",
                    sub: "Socializar y conocer",
                    emoji: "🐶",
                    color: Colors.orangeAccent,
                    goal: "Amistad"),
                _card(context,
                    title: "Paseos",
                    sub: "Caminatas y parques",
                    emoji: "🦮",
                    color: Colors.greenAccent,
                    goal: "Paseos"),
                _card(context,
                    title: "Reproducción",
                    sub: "Busca pareja con cuidado",
                    emoji: "💞",
                    color: Colors.pinkAccent,
                    goal: "Reproducción"),
                _card(context,
                    title: "Pedigrí verificado",
                    sub: "Revisado por PawMatch",
                    emoji: "🏅",
                    color: Colors.lightBlueAccent,
                    pedigree: true),
                _card(context,
                    title: "Cerca de ti",
                    sub: "A menos de 10 km",
                    emoji: "📍",
                    color: Colors.purpleAccent,
                    km: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
