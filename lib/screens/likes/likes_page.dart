import 'package:flutter/material.dart';
import '../../data/app_data.dart';

class LikesPage extends StatelessWidget {
  const LikesPage({super.key});

  @override
  Widget build(BuildContext context) {

    final likes = AppData.likedPets;

    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

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
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Estas mascotas están interesadas en la tuya",
                style: TextStyle(
                  color: Colors.black54,
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
                            size: 80, color: Colors.grey),

                        SizedBox(height: 15),

                        Text(
                          "Aún no tienes likes",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 5),

                        Text(
                          "Sigue explorando para encontrar matches 🐾",
                          style: TextStyle(color: Colors.black54),
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

                      return GestureDetector(
                        onTap: () {
                          // 🔥 después abrimos perfil completo
                        },

                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                          ),

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),

                            child: Stack(
                              children: [

                                /// 🔥 IMAGEN
                                Positioned.fill(
                                  child: Image.network(
                                    pet["images"][0],
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                /// 🔥 GRADIENTE
                                Positioned.fill(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.center,
                                        colors: [
                                          Colors.black54,
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                /// 🔥 CORAZÓN TOP
                                const Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ),

                                /// 🔥 INFO
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  right: 10,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        children: [
                                          Text(
                                            "${pet["name"]}, ${pet["age"]}${pet["ageType"]}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),

                                          const SizedBox(width: 5),

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
                                        pet["breed"],
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),

                                      const SizedBox(height: 3),

                                      Text(
                                        pet["distance"],
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