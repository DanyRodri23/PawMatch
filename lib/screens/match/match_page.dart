import 'package:flutter/material.dart';
import 'match_success_screen.dart';
import '../../data/app_data.dart'; // 🔥 IMPORTANTE

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => MatchPageState();
}

class MatchPageState extends State<MatchPage> {

  void openFilters() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Filtros",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("Distancia"),
              Text("Edad"),
              Text("Raza"),
              Text("Sexo"),
            ],
          ),
        );
      },
    );
  }

  int currentIndex = 0;
  int currentPhoto = 0;
  double position = 0;

  final List<Map<String, dynamic>> pets = [
    {
      "name": "Luna",
      "age": 2,
      "ageType": "a",
      "breed": "Golden Retriever",
      "sex": "Hembra",
      "distance": "3 km",
      "goal": "Compañero de juego",
      "description": "Amigable, juguetona y muy cariñosa 🐶",
      "location": "San Rafael, Heredia",
      "pedigree": true,
      "vaccines": true,
      "personality": ["Juguetona", "Amigable", "Cariñosa"],
      "images": [
        "https://images.unsplash.com/photo-1558788353-f76d92427f16",
        "https://images.unsplash.com/photo-1548199973-03cce0bbc87b",
        "https://images.unsplash.com/photo-1517423440428-a5a00ad493e8"
      ],
      "owner": {
        "name": "Daniel",
        "age": 21,
        "image": "https://randomuser.me/api/portraits/men/32.jpg"
      }
    },
    {
      "name": "Max",
      "age": 3,
      "ageType": "a",
      "breed": "Pug",
      "sex": "Macho",
      "distance": "5 km",
      "goal": "Socializar",
      "description": "Tranquilo y amigable",
      "location": "Heredia",
      "pedigree": false,
      "vaccines": true,
      "personality": ["Tranquilo", "Cariñoso"],
      "images": [
        "https://images.unsplash.com/photo-1517423440428-a5a00ad493e8",
        "https://images.unsplash.com/photo-1507146426996-ef05306b995a"
      ],
      "owner": {
        "name": "Carlos",
        "age": 28,
        "image": "https://randomuser.me/api/portraits/men/45.jpg"
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
      currentIndex = (currentIndex + 1) % pets.length;
      currentPhoto = 0;
      position = 0;
    });
  }

  void handleSwipe() {

    if (position > 120) {

      /// ✅ GUARDAR LIKE
      AppData.addLike(pet);

      /// ✅ ANIMACIÓN ANTES DE NAVEGAR
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

      /// PASS
      setState(() => position = -500);

      Future.delayed(const Duration(milliseconds: 200), () {
        nextPet();
      });
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => position = 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),

      body: SafeArea(
        child: GestureDetector(

          onPanUpdate: (details) {
            setState(() {
              position += details.delta.dx;
            });
          },

          onPanEnd: (_) => handleSwipe(),

          /// 🔥 TAP MEJORADO (NO INTERFIERE CON SWIPE)
          onTapUp: (details) {
            final width = MediaQuery.of(context).size.width;

            if (details.localPosition.dx < width / 2) {
              prevPhoto();
            } else {
              nextPhoto();
            }
          },

          child: SingleChildScrollView(
            child: Column(
              children: [

                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  transform: Matrix4.translationValues(position, 0, 0)
                    ..rotateZ(position * 0.002),

                  child: Container(
                    margin: const EdgeInsets.all(15),
                    height: 520,

                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),

                      child: Stack(
                        children: [

                          Positioned.fill(
                            child: Image.network(
                              images[currentPhoto],
                              fit: BoxFit.cover,
                            ),
                          ),

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

                          /// 🔥 VERDE LIKE
                          if (position > 0)
                            Opacity(
                              opacity: (position / 150).clamp(0.0, 0.7),
                              child: Container(color: Colors.green),
                            ),

                          /// 🔥 ROJO PASS
                          if (position < 0)
                            Opacity(
                              opacity: (-position / 150).clamp(0.0, 0.7),
                              child: Container(color: Colors.red),
                            ),

                          /// 🔥 BARRA BIEN (solo 1 activa)
                          Positioned(
                            top: 10,
                            left: 10,
                            right: 10,
                            child: Row(
                              children: List.generate(images.length, (i) {
                                return Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 2),
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: i == currentPhoto
                                          ? Colors.white
                                          : Colors.white30,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),

                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Row(
                                  children: [
                                    Text(
                                      "${pet["name"]}, ${pet["age"]}${pet["ageType"]}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    if (pet["pedigree"])
                                      const Icon(Icons.verified, color: Colors.blue)
                                  ],
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  "${pet["breed"]} • ${pet["distance"]}",
                                  style: const TextStyle(color: Colors.white70),
                                ),

                              ],
                            ),
                          ),

                          if (position > 50)
                            const Positioned(
                              top: 80,
                              left: 40,
                              child: Text("LIKE",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold)),
                            ),

                          if (position < -50)
                            const Positioned(
                              top: 80,
                              right: 40,
                              child: Text("PASS",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                buildInfoSection(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text("¿Qué busca?",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(pet["goal"]),

          const SizedBox(height: 20),

          const Text("Sobre la mascota",
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(pet["description"]),

          const SizedBox(height: 20),

          const Text("Esenciales",
              style: TextStyle(fontWeight: FontWeight.bold)),

          buildRow(Icons.pets, "Raza", pet["breed"]),
          buildRow(Icons.male, "Sexo", pet["sex"]),
          buildRow(Icons.location_on, "Ubicación", pet["location"]),

          const SizedBox(height: 20),

          const Text("Personalidad",
              style: TextStyle(fontWeight: FontWeight.bold)),

          Wrap(
            spacing: 8,
            children: List.generate(
              (pet["personality"] as List).length,
              (i) => Chip(label: Text(pet["personality"][i])),
            ),
          ),

          const SizedBox(height: 20),

          if (pet["vaccines"])
            const Row(
              children: [
                Icon(Icons.health_and_safety, color: Colors.blue),
                SizedBox(width: 6),
                Text("Vacunas verificadas"),
              ],
            ),

          if (pet["pedigree"])
            const Row(
              children: [
                Icon(Icons.verified, color: Colors.blue),
                SizedBox(width: 6),
                Text("Pedigree verificado"),
              ],
            ),

          const SizedBox(height: 25),

          const Text("Dueño",
              style: TextStyle(fontWeight: FontWeight.bold)),

          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage:
                    NetworkImage(pet["owner"]["image"]),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pet["owner"]["name"]),
                  Text("${pet["owner"]["age"]} años"),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text("$title: ",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}