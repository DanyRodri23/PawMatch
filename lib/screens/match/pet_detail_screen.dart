import 'package:flutter/material.dart';

class PetDetailScreen extends StatelessWidget {
  final Map<String, dynamic> pet;

  const PetDetailScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {

    final images = List<String>.from(pet["images"]);

    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [

          /// 🔥 SCROLL
          SingleChildScrollView(
            child: Column(
              children: [

                /// IMAGE
                SizedBox(
                  height: 500,
                  child: PageView.builder(
                    itemCount: images.length,
                    itemBuilder: (_, i) {
                      return Image.network(
                        images[i],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),
                ),

                /// INFO
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF121212),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "${pet["name"]}, ${pet["age"]}",
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "${pet["breed"]} • ${pet["distance"]}",
                        style: const TextStyle(color: Colors.white70),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Descripción",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        pet["description"],
                        style: const TextStyle(color: Colors.white70),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Personalidad",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 8,
                        children: List.generate(
                          (pet["personality"] as List).length,
                          (i) => Chip(
                            label: Text(pet["personality"][i]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// 🔥 BOTÓN BACK
          Positioned(
            top: 40,
            left: 15,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}