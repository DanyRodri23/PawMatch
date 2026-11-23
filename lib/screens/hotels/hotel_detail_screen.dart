import 'package:flutter/material.dart';

import '../../widgets/favorite_button.dart';
import 'package:url_launcher/url_launcher.dart';

class HotelDetailScreen extends StatelessWidget {
  final Map<String, dynamic> hotel;

  const HotelDetailScreen({
    super.key,
    required this.hotel,
  });

  Future<void> _openGoogleMaps() async {
    final query = Uri.encodeComponent(hotel["location"]);
    final url =
        Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openWaze() async {
    final query = Uri.encodeComponent(hotel["location"]);
    final url = Uri.parse("https://waze.com/ul?q=$query&navigate=yes");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List images = hotel["images"] ?? [hotel["image"]];
    final List amenities = hotel["amenities"] ?? [];

    return Scaffold(
      backgroundColor: Colors.black,

      body: CustomScrollView(
        slivers: [

          /// APP BAR / HERO IMAGE
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 320,
            pinned: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FavoriteButton(kind: "hotel", item: hotel, size: 40),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: PageView.builder(
                itemCount: images.length,
                itemBuilder: (_, i) {
                  return Image.network(
                    images[i],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),

          /// CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// NAME
                  Text(
                    hotel["name"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// LOCATION
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white54,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          hotel["location"],
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// PRICE
                  Text(
                    hotel["price"],
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

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
                    hotel["description"] ??
                        "Un excelente hospedaje pet-friendly diseñado para brindar comodidad y seguridad a tu mascota durante su estadía.",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 26),

                  /// AMENITIES
                  if (amenities.isNotEmpty) ...[
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
                      children: amenities.map((amenity) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            amenity,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 30),
                  ],

                  /// MAP BUTTONS
                  Row(
                    children: [

                      Expanded(
                        child: GestureDetector(
                          onTap: _openGoogleMaps,
                          child: Container(
                            height: 56,
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

                      const SizedBox(width: 12),

                      Expanded(
                        child: GestureDetector(
                          onTap: _openWaze,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Center(
                              child: Text(
                                "Waze",
                                style: TextStyle(
                                  color: Colors.black,
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