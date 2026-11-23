import 'package:flutter/material.dart';

import '../../data/parks_data.dart';
import 'park_detail_screen.dart';
import 'parks_by_region_screen.dart';

class ParksScreen extends StatelessWidget {
  const ParksScreen({super.key});

  static const Color bg = Color(0xFF0B0B0F);
  static const Color card = Color(0xFF16161C);
  static const Color green = Color(0xFF3DDC84);

  /// Todos los parques en una sola lista, con su región.
  static List<Map<String, dynamic>> _allParks() {
    final out = <Map<String, dynamic>>[];
    for (final country in parksData.values) {
      final regions = country["regions"] as Map<String, dynamic>;
      for (final parks in regions.values) {
        for (final p in (parks as List)) {
          out.add(Map<String, dynamic>.from(p as Map));
        }
      }
    }
    return out;
  }

  static Widget _img(String url, {double? h, double? w}) => Image.network(
        url,
        height: h,
        width: w,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: h,
          width: w,
          color: card,
          child: const Icon(Icons.park_rounded, color: Colors.white24, size: 44),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final all = _allParks();
    final top = [...all]..sort((a, b) => (double.tryParse("${b["rating"]}") ?? 0)
        .compareTo(double.tryParse("${a["rating"]}") ?? 0));
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: bg,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: bottom + 110),
        children: [
          // Encabezado
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 4, 22, 0),
            child: Row(
              children: [
                Icon(Icons.park_rounded, color: green, size: 30),
                SizedBox(width: 10),
                Text(
                  "Dog Parks",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 6, 22, 16),
            child: Text(
              "Encuentra dónde pasear y jugar con tu mascota.",
              style: TextStyle(color: Colors.white54, fontSize: 15),
            ),
          ),

          // Países
          for (final country in parksData.keys)
            Builder(builder: (context) {
              final regions =
                  parksData[country]!["regions"] as Map<String, dynamic>;
              int total = 0;
              String? photo;
              for (final r in regions.values) {
                total += (r as List).length;
                if (photo == null && r.isNotEmpty) {
                  photo = (r.first as Map)["image"]?.toString();
                }
              }
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ParksByRegionScreen(country: country),
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                  height: 190,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: green.withValues(alpha: 0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (photo != null) _img(photo, h: 190),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.05),
                                Colors.black.withValues(alpha: 0.9),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          right: 20,
                          bottom: 18,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      country,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "$total parques · ${regions.length} regiones",
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.arrow_forward_rounded,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

          // Mejor valorados
          if (top.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(22, 14, 22, 12),
              child: Text(
                "Mejor valorados ⭐",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: top.length.clamp(0, 8),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final p = top[i];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ParkDetailScreen(park: p),
                      ),
                    ),
                    child: Container(
                      width: 170,
                      decoration: BoxDecoration(
                        color: card,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(22)),
                            child: _img("${p["image"]}", h: 120, w: 170),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${p["name"]}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded,
                                        color: Colors.amber, size: 16),
                                    const SizedBox(width: 3),
                                    Text("${p["rating"]}",
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13)),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        "${p["size"]}",
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            color: Colors.white38,
                                            fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],

          // Próximamente
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 26, 22, 12),
            child: Text(
              "Próximamente",
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: const [
                _Soon(Icons.near_me_rounded, "Parques cerca de ti",
                    "Con tu ubicación te mostramos los más cercanos."),
                _Soon(Icons.pin_drop_rounded, "Check-in en el parque",
                    "Avisa que llegaste y mira qué mascotas hay."),
                _Soon(Icons.event_rounded, "Eventos en parques",
                    "Quedadas y caminatas de la comunidad."),
                _Soon(Icons.rate_review_rounded, "Reseñas",
                    "Califica los parques y sube fotos."),
              ],
            ),
          ),
        ],
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
        color: ParksScreen.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: ParksScreen.green.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: ParksScreen.green),
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
