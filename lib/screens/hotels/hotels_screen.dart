import 'package:flutter/material.dart';

class HotelsScreen extends StatelessWidget {
  const HotelsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final hotels = [
      {
        "name": "Hotel Pet Paradise",
        "location": "Heredia",
        "price": "₡15,000 / noche",
        "image": "https://images.unsplash.com/photo-1566073771259-6a8506099945"
      },
      {
        "name": "Dog Friendly Resort",
        "location": "Guanacaste",
        "price": "₡20,000 / noche",
        "image": "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b"
      },
      {
        "name": "Pet Hotel Deluxe",
        "location": "San José",
        "price": "₡18,000 / noche",
        "image": "https://images.unsplash.com/photo-1522708323590-d24dbb6b0267"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Column(
          children: [

            const Padding(
              padding: EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Hotels 🏨",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: hotels.length,
                itemBuilder: (_, i) {

                  final hotel = hotels[i];

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF111111),
                    ),

                    child: Row(
                      children: [

                        ClipRRect(
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
                          child: Image.network(
                            hotel["image"]!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  hotel["name"]!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  hotel["location"]!,
                                  style: TextStyle(color: Colors.grey[400]),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  hotel["price"]!,
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white.withValues(alpha: 0.6),
                            size: 16,
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}