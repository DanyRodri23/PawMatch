import 'package:flutter/material.dart';

/// Novedades de PawMatch. Por ahora son ejemplos de lo que vendrá
/// (ofertas de veterinarias, adopciones, eventos, parques...).
class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsItem {
  final String category;
  final String title;
  final String subtitle;
  final String detail;
  final String image;
  final String place;
  final IconData icon;
  final Color color;

  const _NewsItem({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.image,
    required this.place,
    required this.icon,
    required this.color,
  });
}

class _NewsScreenState extends State<NewsScreen> {
  static const Color bg = Color(0xFF0B0B0F);
  static const Color card = Color(0xFF16161C);

  static const List<String> categories = [
    "Todo",
    "Ofertas",
    "Adopción",
    "Eventos",
    "Salud",
    "Parques",
  ];

  static const List<_NewsItem> items = [
    _NewsItem(
      category: "Ofertas",
      title: "15% de descuento en consulta veterinaria",
      subtitle: "Solo esta semana",
      detail:
          "Las veterinarias aliadas publicarán aquí sus promociones para que las uses con tu perfil PawMatch.",
      image: "https://images.unsplash.com/photo-1583511655826-05700d52f4d9",
      place: "Heredia",
      icon: Icons.local_offer_rounded,
      color: Color(0xFFFF4D94),
    ),
    _NewsItem(
      category: "Adopción",
      title: "Jornada de adopción",
      subtitle: "Domingo · 10:00 a.m.",
      detail:
          "Trabajaremos con refugios y asociaciones para que puedas conocer mascotas que buscan un hogar.",
      image: "https://images.unsplash.com/photo-1601758228041-f3b2795255f1",
      place: "Parque Central",
      icon: Icons.favorite_rounded,
      color: Color(0xFFFF8A4D),
    ),
    _NewsItem(
      category: "Parques",
      title: "Nuevo parque canino",
      subtitle: "Zona exclusiva para mascotas",
      detail:
          "Te avisaremos cuando se abra un parque nuevo cerca de ti, con fotos y cómo llegar.",
      image: "https://images.unsplash.com/photo-1598133894008-61f7fdb8cc3a",
      place: "San José",
      icon: Icons.park_rounded,
      color: Color(0xFF3DDC84),
    ),
    _NewsItem(
      category: "Eventos",
      title: "Caminata canina",
      subtitle: "Sábado · 7:00 a.m.",
      detail:
          "Eventos y encuentros de la comunidad para pasear y conocer a otros dueños.",
      image: "https://images.unsplash.com/photo-1507146426996-ef05306b995a",
      place: "La Sabana",
      icon: Icons.directions_walk_rounded,
      color: Color(0xFF4DA3FF),
    ),
    _NewsItem(
      category: "Salud",
      title: "Campaña de vacunación",
      subtitle: "Vacunas a precio especial",
      detail:
          "Campañas de vacunación y desparasitación para mantener a tu mascota al día.",
      image: "https://images.unsplash.com/photo-1548199973-03cce0bbc87b",
      place: "Alajuela",
      icon: Icons.vaccines_rounded,
      color: Color(0xFFB36BFF),
    ),
  ];

  String selected = "Todo";

  void openItem(_NewsItem n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF121217),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(30)),
                child: Image.network(
                  n.image,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(height: 220, color: card),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _pill(n.category, n.color),
                    const SizedBox(height: 12),
                    Text(
                      n.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      n.detail,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15.5,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.hourglass_top_rounded,
                              color: Colors.amber, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Próximamente: esta sección mostrará novedades reales de tu zona.",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13.5),
                            ),
                          ),
                        ],
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

  Widget _pill(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12.5,
            fontWeight: FontWeight.w800,
          ),
        ),
      );

  Widget _image(String url, double h) => Image.network(
        url,
        height: h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: h,
          color: card,
          child: const Icon(Icons.pets, color: Colors.white24, size: 50),
        ),
      );

  Widget featured(_NewsItem n) {
    return GestureDetector(
      onTap: () => openItem(n),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 4, 20, 18),
        height: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: n.color.withValues(alpha: 0.25),
              blurRadius: 26,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _image(n.image, 270),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.black.withValues(alpha: 0.92),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: _pill("Destacado · ${n.category}", n.color),
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      n.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.place_rounded,
                            color: Colors.white70, size: 16),
                        const SizedBox(width: 4),
                        Text(n.place,
                            style: const TextStyle(color: Colors.white70)),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(n.subtitle,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white70)),
                        ),
                      ],
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

  Widget row(_NewsItem n) {
    return GestureDetector(
      onTap: () => openItem(n),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(22)),
              child: SizedBox(
                width: 112,
                height: 112,
                child: Image.network(
                  n.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: bg),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(n.icon, color: n.color, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          n.category,
                          style: TextStyle(
                            color: n.color,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      n.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "${n.place} · ${n.subtitle}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = selected == "Todo"
        ? items
        : items.where((e) => e.category == selected).toList();
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: bg,
      body: ListView(
        padding: EdgeInsets.only(bottom: bottom + 110),
        physics: const BouncingScrollPhysics(),
        children: [
          // Aviso
          Container(
            margin: const EdgeInsets.fromLTRB(20, 6, 20, 14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.pinkAccent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(18),
              border:
                  Border.all(color: Colors.pinkAccent.withValues(alpha: 0.3)),
            ),
            child: const Row(
              children: [
                Text("🐾", style: TextStyle(fontSize: 22)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Próximamente: ofertas de veterinarias, jornadas de adopción, eventos y nuevos parques cerca de ti.",
                    style: TextStyle(
                        color: Colors.white70, fontSize: 13.5, height: 1.35),
                  ),
                ),
              ],
            ),
          ),

          // Categorías
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final c = categories[i];
                final on = c == selected;
                return GestureDetector(
                  onTap: () => setState(() => selected = c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: on ? Colors.pinkAccent : const Color(0xFF22222A),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      c,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: on ? FontWeight.w800 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),

          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: Text(
                  "Aún no hay novedades en esta categoría.",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            )
          else ...[
            featured(list.first),
            for (final n in list.skip(1)) row(n),
          ],
        ],
      ),
    );
  }
}
