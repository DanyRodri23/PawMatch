import 'package:flutter/material.dart';

import '../../data/favorites_data.dart';
import '../hotels/hotel_detail_screen.dart';
import '../parks/park_detail_screen.dart';

/// Parques y hoteles que guardaste.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  static const Color bg = Color(0xFF0B0B0F);
  static const Color card = Color(0xFF16161C);

  @override
  void initState() {
    super.initState();
    FavoritesData.load();
  }

  Widget section(String title, String kind, IconData icon, Color color) {
    final list = FavoritesData.byKind(kind);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 12),
          child: Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w800)),
        ),
        if (list.isEmpty)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Aún no tienes favoritos. Toca el ❤️ en un lugar para guardarlo.",
                    style: TextStyle(color: Colors.white54, fontSize: 13.5),
                  ),
                ),
              ],
            ),
          )
        else
          for (final e in list)
            GestureDetector(
              onTap: () {
                final d = Map<String, dynamic>.from(e["data"] as Map);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => kind == "park"
                        ? ParkDetailScreen(park: d)
                        : HotelDetailScreen(hotel: d),
                  ),
                );
              },
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
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(22)),
                      child: SizedBox(
                        width: 96,
                        height: 96,
                        child: Image.network(
                          "${e["data"]["image"] ?? ""}",
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: bg, child: Icon(icon, color: color)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${e["data"]["name"]}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)),
                            const SizedBox(height: 4),
                            Text("${e["data"]["location"] ?? ""}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.favorite_rounded,
                          color: Colors.pinkAccent),
                      onPressed: () => FavoritesData.toggle(
                          kind, Map<String, dynamic>.from(e["data"] as Map)),
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: Colors.white,
        title: const Text("Mis favoritos"),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: FavoritesData.version,
        builder: (_, __, ___) => ListView(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 30),
          children: [
            section("Parques", "park", Icons.park_rounded,
                const Color(0xFF3DDC84)),
            section("Hoteles", "hotel", Icons.hotel_rounded,
                Colors.purpleAccent),
          ],
        ),
      ),
    );
  }
}
