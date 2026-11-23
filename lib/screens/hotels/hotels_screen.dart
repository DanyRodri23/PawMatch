import 'package:flutter/material.dart';

import 'hotels_by_region_screen.dart';

class HotelsScreen extends StatelessWidget {
  const HotelsScreen({super.key});

  static const Color bg = Color(0xFF0B0B0F);
  static const Color card = Color(0xFF16161C);

  static const List<Map<String, dynamic>> provinces = [
    {"name": "San José", "count": 3, "c1": Color(0xFF5B2A86), "c2": Color(0xFF7F53AC)},
    {"name": "Alajuela", "count": 3, "c1": Color(0xFF8E2C5C), "c2": Color(0xFFE0488C)},
    {"name": "Heredia", "count": 3, "c1": Color(0xFF0F4C75), "c2": Color(0xFF3282B8)},
    {"name": "Cartago", "count": 0, "c1": Color(0xFF2B2B33), "c2": Color(0xFF3A3A44)},
    {"name": "Guanacaste", "count": 0, "c1": Color(0xFF2B2B33), "c2": Color(0xFF3A3A44)},
    {"name": "Puntarenas", "count": 0, "c1": Color(0xFF2B2B33), "c2": Color(0xFF3A3A44)},
    {"name": "Limón", "count": 0, "c1": Color(0xFF2B2B33), "c2": Color(0xFF3A3A44)},
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final width = MediaQuery.of(context).size.width;
    final tileW = (width - 40 - 12) / 2;

    return Scaffold(
      backgroundColor: bg,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: bottom + 110),
        children: [
          // Banner
          Container(
            margin: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1B2A4A), Color(0xFF3B1E5A), Color(0xFF6B1E4A)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.purpleAccent.withValues(alpha: 0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Hoteles pet-friendly",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Hospedajes donde tu mascota también es bienvenida.",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 14.5,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.public, color: Colors.white, size: 16),
                            SizedBox(width: 6),
                            Text("Costa Rica",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Text("🏨", style: TextStyle(fontSize: 62)),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(22, 0, 22, 12),
            child: Text(
              "Elige una provincia",
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final p in provinces)
                  _tile(context, p, tileW),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(22, 28, 22, 12),
            child: Text(
              "Próximamente",
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _Soon(Icons.calendar_month_rounded, "Reservar desde la app",
                    "Elige fechas y reserva sin salir de PawMatch."),
                _Soon(Icons.pets_rounded, "Guarderías y cuidadores",
                    "Para cuando viajas y tu mascota se queda."),
                _Soon(Icons.star_rounded, "Reseñas de la comunidad",
                    "Opiniones y fotos de otros dueños."),
                _Soon(Icons.medical_services_rounded, "Veterinarias 24/7",
                    "Emergencias cerca de tu hospedaje."),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, Map<String, dynamic> p, double w) {
    final count = p["count"] as int;
    final active = count > 0;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HotelsByRegionScreen(region: p["name"].toString()),
        ),
      ),
      child: Container(
        width: w,
        height: 130,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [p["c1"] as Color, p["c2"] as Color],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -14,
              bottom: -14,
              child: Icon(
                Icons.hotel_rounded,
                size: 92,
                color: Colors.white.withValues(alpha: active ? 0.16 : 0.07),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p["name"].toString(),
                    style: TextStyle(
                      color: active ? Colors.white : Colors.white70,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.white.withValues(alpha: 0.22)
                          : Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      active ? "$count hoteles" : "Próximamente",
                      style: TextStyle(
                        color: active ? Colors.white : Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Soon extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;
  const _Soon(this.icon, this.title, this.sub);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HotelsScreen.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.purpleAccent.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.purpleAccent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(sub,
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 12.5)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text("Pronto",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 11,
                    fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}
