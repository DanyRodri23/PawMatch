import 'package:flutter/material.dart';

class Pet {
  final String name;
  final int age;
  final String image;
  final double distance;
  final bool hasPedigree;
  final bool hasVaccines;
  final List<String> gallery;

  Pet({
    required this.name,
    required this.age,
    required this.image,
    required this.distance,
    required this.hasPedigree,
    required this.hasVaccines,
    required this.gallery,
  });
}

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pet = ModalRoute.of(context)!.settings.arguments as Pet;
    final gallery = pet.gallery;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            itemCount: gallery.isEmpty ? 1 : gallery.length,
            itemBuilder: (context, index) {
              return Image.network(
                gallery.isEmpty ? pet.image : gallery[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "${pet.name}, ${pet.age}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(width: 8),

                    if (pet.hasPedigree)
                      Icon(Icons.pets, color: Colors.blue),

                    if (pet.hasVaccines)
                      Icon(Icons.verified, color: Colors.blue),
                  ],
                ),

                SizedBox(height: 6),

                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.white70),
                    Text(
                      "${pet.distance} km",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            top: 50,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}