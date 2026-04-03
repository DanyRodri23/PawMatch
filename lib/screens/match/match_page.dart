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

  /// 🔥 FILTROS (YA FUNCIONA CON DASHBOARD)
  void openFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Filtros",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Distancia", style: TextStyle(color: Colors.white70)),
              Text("Edad", style: TextStyle(color: Colors.white70)),
              Text("Raza", style: TextStyle(color: Colors.white70)),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

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
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5), // ✅ FIX
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      )
                    ],
                  ),

                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Stack(
                      children: [

                        /// IMAGEN
                        Positioned.fill(
                          child: Image.network(
                            images[currentPhoto],
                            fit: BoxFit.cover,
                          ),
                        ),

                        /// GRADIENTE
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

                        /// BARRA DE FOTOS
                        Positioned(
                          top: 12,
                          left: 12,
                          right: 12,
                          child: Row(
                            children: List.generate(images.length, (i) {
                              return Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: i == currentPhoto
                                        ? Colors.white
                                        : Colors.white24,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                        /// INFO
                        Positioned(
                          bottom: 25,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                "${pet["name"]}, ${pet["age"]}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                ),
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
                                  fontSize: 40,
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
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                        /// BOTÓN DETALLE
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
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6), // ✅ FIX
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.2), // ✅ FIX
                                    blurRadius: 10,
                                  )
                                ],
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