import 'package:flutter/material.dart';
import 'hotel_detail_screen.dart';

class HotelsByRegionScreen extends StatelessWidget {
  final String region;

  const HotelsByRegionScreen({
    super.key,
    required this.region,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> hotelsByRegion = {
      "Heredia": [
        {
          "name": "Hotel Canino Heredia",
          "location": "San Rafael, Heredia",
          "price": "₡15,000 / noche",
          "image":
              "https://images.unsplash.com/photo-1566073771259-6a8506099945",
          "images": [
            "https://images.unsplash.com/photo-1566073771259-6a8506099945",
            "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
            "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b",
          ],
          "description":
              "Hotel premium pet-friendly con supervisión 24/7, zonas verdes y atención especializada para tu mascota.",
          "amenities": [
            "Piscina",
            "Pet Spa",
            "24/7",
            "Área de Juego",
          ],
        },
        {
          "name": "Pet Paradise Resort",
          "location": "Belén, Heredia",
          "price": "₡18,000 / noche",
          "image":
              "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
          "images": [
            "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267",
          ],
          "description":
              "Un resort diseñado para mascotas con espacios abiertos y servicio personalizado.",
          "amenities": [
            "Guardería",
            "Veterinario",
            "Cámaras en Vivo",
          ],
        },
        {
          "name": "PawStay Heredia",
          "location": "Barva, Heredia",
          "price": "₡14,000 / noche",
          "image":
              "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b",
          "images": [
            "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b",
          ],
          "description":
              "Hospedaje cómodo y seguro para mascotas con monitoreo constante.",
          "amenities": [
            "24/7",
            "Pet Training",
            "Área Verde",
          ],
        },
      ],

      "San José": [
        {
          "name": "Urban Pet Suites",
          "location": "Escazú, San José",
          "price": "₡22,000 / noche",
          "image":
              "https://images.unsplash.com/photo-1445019980597-93fa8acb246c",
          "images": [
            "https://images.unsplash.com/photo-1445019980597-93fa8acb246c",
          ],
          "description":
              "Hotel pet-friendly de lujo con suites privadas para mascotas.",
          "amenities": [
            "Pet Spa",
            "Luxury Suites",
            "24/7",
          ],
        },
        {
          "name": "Hotel Mascotas Capital",
          "location": "Curridabat, San José",
          "price": "₡19,000 / noche",
          "image":
              "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85",
          "images": [
            "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85",
          ],
          "description":
              "Hospedaje moderno para mascotas en el corazón de San José.",
          "amenities": [
            "Veterinario",
            "Monitoreo",
            "Pet Grooming",
          ],
        },
        {
          "name": "Doggy Stay SJ",
          "location": "Santa Ana, San José",
          "price": "₡20,000 / noche",
          "image":
              "https://images.unsplash.com/photo-1455587734955-081b22074882",
          "images": [
            "https://images.unsplash.com/photo-1455587734955-081b22074882",
          ],
          "description":
              "Ideal para estadías prolongadas con cuidado especializado.",
          "amenities": [
            "Training",
            "Pet Spa",
            "Outdoor Park",
          ],
        },
      ],

      "Alajuela": [
        {
          "name": "Pet Lodge Airport",
          "location": "Río Segundo, Alajuela",
          "price": "₡17,000 / noche",
          "image":
              "https://images.unsplash.com/photo-1578683010236-d716f9a3f461",
          "images": [
            "https://images.unsplash.com/photo-1578683010236-d716f9a3f461",
          ],
          "description":
              "Ubicado cerca del aeropuerto, ideal para viajeros.",
          "amenities": [
            "Airport Nearby",
            "24/7",
            "Pet Pickup",
          ],
        },
        {
          "name": "Happy Tails Hotel",
          "location": "Grecia, Alajuela",
          "price": "₡16,000 / noche",
          "image":
              "https://images.unsplash.com/photo-1551882547-ff40c63fe5fa",
          "images": [
            "https://images.unsplash.com/photo-1551882547-ff40c63fe5fa",
          ],
          "description":
              "Amplios espacios y atención personalizada para cada mascota.",
          "amenities": [
            "Outdoor Park",
            "Pet Spa",
            "Training",
          ],
        },
        {
          "name": "Paw Resort Alajuela",
          "location": "La Garita, Alajuela",
          "price": "₡18,500 / noche",
          "image":
              "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4",
          "images": [
            "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4",
          ],
          "description":
              "Resort pet-friendly con zonas recreativas y premium care.",
          "amenities": [
            "Luxury",
            "Pool",
            "24/7",
          ],
        },
      ],
    };

    final hotels = hotelsByRegion[region] ?? [];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text("Hoteles en $region"),
      ),
      body: hotels.isEmpty
          ? const Center(
              child: Text(
                "Próximamente",
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: hotels.length,
              itemBuilder: (_, i) {
                final hotel = hotels[i];

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(22),
                        ),
                        child: Image.network(
                          hotel["image"],
                          height: 190,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              hotel["name"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              hotel["location"],
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [

                                Text(
                                  hotel["price"],
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => HotelDetailScreen(
                                          hotel: hotel,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(14),
                                    ),
                                    child: const Text(
                                      "Ver más",
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}