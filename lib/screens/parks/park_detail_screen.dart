import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ParkDetailScreen extends StatelessWidget {
  final Map<String, dynamic> park;

  const ParkDetailScreen({
    super.key,
    required this.park,
  });

  Future<void> _openGoogleMaps() async {
    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=${park["location"]}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openWaze() async {
    final Uri url = Uri.parse(
      "https://waze.com/ul?q=${park["location"]}",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final amenities = [
      "Zona Cercada",
      "Agua Disponible",
      "Área de Juegos",
      "Pet Friendly",
      "Bancas",
      "Sombras",
    ];

    return Scaffold(
      backgroundColor: Colors.black,

      body: CustomScrollView(
        slivers: [

          /// HERO IMAGE
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                park["image"],
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// TITLE
                  Text(
                    park["name"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      const Icon(
                        Icons.location_on,
                        color: Colors.greenAccent,
                        size: 18,
                      ),

                      const SizedBox(width: 6),

                      Expanded(
                        child: Text(
                          park["location"],
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        park["rating"],
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 20),

                      Text(
                        "Tamaño: ${park["size"]}",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  /// DESCRIPTION
                  const Text(
                    "Descripción",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Un parque ideal para disfrutar con tu mascota. Cuenta con áreas verdes amplias, zonas seguras y espacios diseñados para socialización y recreación.",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// AMENITIES
                  const Text(
                    "Amenidades",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: amenities.map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          item,
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  /// MAP BUTTONS
                  Row(
                    children: [

                      Expanded(
                        child: GestureDetector(
                          onTap: _openGoogleMaps,
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Center(
                              child: Text(
                                "Google Maps",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: GestureDetector(
                          onTap: _openWaze,
                          child: Container(
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Center(
                              child: Text(
                                "Waze",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}