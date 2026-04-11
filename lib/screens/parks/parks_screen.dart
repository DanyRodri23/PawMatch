import 'package:flutter/material.dart';
import '../../data/parks_data.dart';
import 'parks_by_region_screen.dart';

class ParksScreen extends StatelessWidget {
  const ParksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                children: [

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.park_rounded,
                      color: Colors.greenAccent,
                      size: 30,
                    ),
                  ),

                  const SizedBox(width: 14),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Dog Parks",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Explora parques y espacios pet-friendly",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// GLOBAL STATS
              Row(
                children: [

                  Expanded(
                    child: _statCard(
                      title: _getTotalParks().toString(),
                      subtitle: "Parques",
                      icon: Icons.forest,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: _statCard(
                      title: parksData.length.toString(),
                      subtitle: "Países",
                      icon: Icons.public,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// COUNTRY CARDS DINÁMICAS
              ...parksData.keys.map((country) {
                final regionsMap =
                    parksData[country]!["regions"] as Map<String, dynamic>;

                final regionCount = regionsMap.length;

                int totalParks = 0;
                for (final parks in regionsMap.values) {
                  totalParks += (parks as List).length;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 22),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ParksByRegionScreen(
                            country: country,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF151515),
                            Color(0xFF0E0E0E),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.white10,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.greenAccent.withValues(alpha: 0.08),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [

                          Container(
                            width: 68,
                            height: 68,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Icon(
                              Icons.public,
                              color: Colors.greenAccent,
                              size: 34,
                            ),
                          ),

                          const SizedBox(width: 18),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Text(
                                  country,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  "$totalParks parques • $regionCount regiones",
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white38,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 10),

              /// INFO FOOTER
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: const Color(0xFF111111),
                ),
                child: const Row(
                  children: [

                    Icon(
                      Icons.star,
                      color: Colors.orange,
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        "Los parques mejor calificados aparecerán primero para mejorar la experiencia.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.5,
                        ),
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

  static int _getTotalParks() {
    int total = 0;

    for (final country in parksData.values) {
      final regions = country["regions"] as Map<String, dynamic>;

      for (final parks in regions.values) {
        total += (parks as List).length;
      }
    }

    return total;
  }

  static Widget _statCard({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF111111),
      ),
      child: Column(
        children: [

          Icon(
            icon,
            color: Colors.greenAccent,
            size: 28,
          ),

          const SizedBox(height: 14),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}