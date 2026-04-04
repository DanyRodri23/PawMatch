import 'package:flutter/material.dart';
import '../../data/app_data.dart';

class LikesPage extends StatelessWidget {
  const LikesPage({super.key});

  @override
  Widget build(BuildContext context) {

    final likes = AppData.likedPets;

    return Scaffold(
      backgroundColor: Colors.black, // 🔥 DARK MODE

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 TITULO
              const Text(
                "Te dieron like 💛",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // 🔥 blanco
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Estas mascotas están interesadas en la tuya",
                style: TextStyle(
                  color: Colors.white54, // 🔥 gris claro
                ),
              ),

              const SizedBox(height: 20),

              /// 🔥 SI NO HAY LIKES
              if (likes.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [

                        Icon(Icons.favorite_border,
                            size: 80, color: Colors.white38),

                        SizedBox(height: 15),

                        Text(
                          "Aún no tienes likes",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "Sigue explorando para encontrar matches 🐾",
                          style: TextStyle(color: Colors.white54),
                        ),

                      ],
                    ),
                  ),
                )

              /// 🔥 GRID DE LIKES
              else
                Expanded(
                  child: GridView.builder(
                    itemCount: likes.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),

                    itemBuilder: (context, index) {

                      final pet = likes[index];

                      /// 🔥 PROTECCIÓN ANTI-CRASH
                      final images = pet["images"];
                      final imageUrl = (images != null &&
                              images is List &&
                              images.isNotEmpty)
                          ? images[0]
                          : null;

                      return GestureDetector(
                        onTap: () {},

                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.6),
                                blurRadius: 20,
                              )
                            ],
                          ),

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),

                            child: Stack(
                              children: [

                                /// 🔥 IMAGEN SEGURA
                                Positioned.fill(
                                  child: imageUrl != null
                                      ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: Colors.grey[900],
                                        ),
                                ),

                                /// 🔥 GRADIENTE PRO
                                Positioned.fill(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.center,
                                        colors: [
                                          Colors.black87,
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                /// 🔥 CORAZÓN
                                const Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.redAccent,
                                  ),
                                ),

                                /// 🔥 INFO
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  right: 12,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${pet["name"] ?? ""}, ${pet["age"] ?? ""}${pet["ageType"] ?? ""}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          if (pet["pedigree"] == true)
                                            const Icon(
                                              Icons.verified,
                                              color: Colors.blue,
                                              size: 16,
                                            ),
                                        ],
                                      ),

                                      const SizedBox(height: 3),

                                      Text(
                                        pet["breed"] ?? "",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),

                                      const SizedBox(height: 3),

                                      Text(
                                        pet["distance"] ?? "",
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 12,
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
                    },
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }
}