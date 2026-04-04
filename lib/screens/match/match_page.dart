import 'package:flutter/material.dart';
import 'match_success_screen.dart';
import '../../data/app_data.dart';
import 'pet_detail_screen.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => MatchPageState();
}

class MatchPageState extends State<MatchPage> {

  int currentIndex = 0;
  int currentPhoto = 0;
  double position = 0;

  final List<Map<String, dynamic>> pets = [
    {
      "name": "Luna",
      "age": 2,
      "breed": "Golden Retriever",
      "distance": "3 km",
      "description": "Amigable, juguetona y muy cariñosa 🐶",
      "images": [
        "https://images.unsplash.com/photo-1558788353-f76d92427f16",
        "https://images.unsplash.com/photo-1548199973-03cce0bbc87b",
      ],
      "owner": {
        "name": "Daniel",
        "image": "https://randomuser.me/api/portraits/men/32.jpg"
      }
    },
  ];

  Map<String, dynamic> get pet => pets[currentIndex];
  List<String> get images => List<String>.from(pet["images"]);

  void nextPhoto() {
    if (currentPhoto < images.length - 1) {
      setState(() => currentPhoto++);
    }
  }

  void prevPhoto() {
    if (currentPhoto > 0) {
      setState(() => currentPhoto--);
    }
  }

  void nextPet() {
    setState(() {
      currentPhoto = 0;
      position = 0;
    });
  }

  void handleSwipe() {

    if (position > 120) {

      AppData.addLike(pet);

      setState(() => position = 500);

      Future.delayed(const Duration(milliseconds: 200), () {
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MatchSuccessScreen(
              myPet: "Max",
              otherPet: pet["name"],
              image1: images[0],
              image2: images[0],
            ),
          ),
        );

        nextPet();
      });

    } else if (position < -120) {

      setState(() => position = -500);

      Future.delayed(const Duration(milliseconds: 200), () {
        nextPet();
      });
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => position = 0);
    });
  }

  void openFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Filtros próximamente 🐾",
            style: TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // 🔥 fondo gris premium

      body: SafeArea(
        child: GestureDetector(

          onPanUpdate: (details) {
            setState(() => position += details.delta.dx);
          },

          onPanEnd: (_) => handleSwipe(),

          onTapUp: (details) {
            final width = MediaQuery.of(context).size.width;
            details.localPosition.dx < width / 2
                ? prevPhoto()
                : nextPhoto();
          },

          child: Stack(
            children: [

              /// 🔥 TARJETA
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: Matrix4.translationValues(position, 0, 0)
                  ..rotateZ(position * 0.0015),

                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 25,
                        offset: const Offset(0, 15),
                      )
                    ],
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Stack(
                      children: [

                        /// IMAGEN FULL
                        Positioned.fill(
                          child: Image.network(
                            images[currentPhoto],
                            fit: BoxFit.cover,
                          ),
                        ),

                        /// GRADIENTE MÁS SUAVE
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                                colors: [
                                  Color(0xCC000000),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                        /// BARRA DE FOTOS (MÁS PREMIUM)
                        Positioned(
                          top: 14,
                          left: 14,
                          right: 14,
                          child: Row(
                            children: List.generate(images.length, (i) {
                              return Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: i == currentPhoto
                                        ? Colors.white
                                        : Colors.white.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        /// INFO BONITA
                        Positioned(
                          bottom: 30,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  Text(
                                    "${pet["name"]}, ${pet["age"]}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(width: 6),

                                  /// 🐾 VERIFICACIÓN
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.pets, size: 14, color: Colors.white),
                                  )
                                ],
                              ),

                              const SizedBox(height: 4),

                              Text(
                                pet["distance"],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// LIKE
                        if (position > 50)
                          Positioned(
                            top: 100,
                            left: 40,
                            child: Transform.rotate(
                              angle: -0.3,
                              child: const Text(
                                "LIKE",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                        /// NOPE
                        if (position < -50)
                          Positioned(
                            top: 100,
                            right: 40,
                            child: Transform.rotate(
                              angle: 0.3,
                              child: const Text(
                                "NOPE",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                        /// BOTÓN DETALLE (GLASS)
                        Positioned(
                          right: 20,
                          bottom: 140,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PetDetailScreen(pet: pet),
                                ),
                              );
                            },
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                              child: const Icon(
                                Icons.keyboard_arrow_up,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}