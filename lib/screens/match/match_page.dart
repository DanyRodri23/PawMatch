import 'package:flutter/material.dart';
import 'dart:ui';

import 'match_success_screen.dart';
import '../../data/app_data.dart';
import 'pet_detail_screen.dart';

class MatchPage extends StatefulWidget {
  const MatchPage({super.key});

  @override
  State<MatchPage> createState() => MatchPageState();
}

class MatchPageState extends State<MatchPage>
    with SingleTickerProviderStateMixin {

  int currentIndex = 0;
  int currentPhoto = 0;

  double position = 0;
  double rotation = 0;

  final List<Map<String, dynamic>> pets = [
    {
      "name": "Luna",
      "age": 2,
      "distance": "3 km",
      "images": [
        "https://images.unsplash.com/photo-1558788353-f76d92427f16",
        "https://images.unsplash.com/photo-1548199973-03cce0bbc87b",
      ],
    },
    {
      "name": "Max",
      "age": 3,
      "distance": "5 km",
      "images": [
        "https://images.unsplash.com/photo-1518717758536-85ae29035b6d",
      ],
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
      rotation = 0;
      currentIndex = (currentIndex + 1) % pets.length;
    });
  }

  void swipeRight() {
    AppData.addLike(pet);

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
  }

  void swipeLeft() {
    nextPet();
  }

  void openFilters() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [

          /// 🔥 CARTA ATRÁS
          if (pets.length > 1)
            Transform.scale(
              scale: 0.95,
              child: _buildCard((currentIndex + 1) % pets.length),
            ),

          /// 🔥 CARTA PRINCIPAL
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                position += details.delta.dx;
                rotation = position * 0.001;
              });
            },
            onPanEnd: (_) {
              if (position > 120) {
                swipeRight();
              } else if (position < -120) {
                swipeLeft();
              } else {
                setState(() {
                  position = 0;
                  rotation = 0;
                });
              }
            },
            onTapUp: (details) {
              final width = MediaQuery.of(context).size.width;
              details.localPosition.dx < width / 2
                  ? prevPhoto()
                  : nextPhoto();
            },
            child: Transform.translate(
              offset: Offset(position, 0),
              child: Transform.rotate(
                angle: rotation,
                child: _buildCard(currentIndex),
              ),
            ),
          ),

          /// 🔥 HEADER
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.tune, color: Colors.white),
                          Text(
                            "Para ti",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(Icons.bolt, color: Colors.purple),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// 🔥 BOTONES
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(Icons.close, Colors.red, swipeLeft),
                _actionButton(Icons.star, Colors.blue, () {}),
                _actionButton(Icons.favorite, Colors.green, swipeRight),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 CARD PRO
  Widget _buildCard(int index) {
    final data = pets[index];
    final imgs = List<String>.from(data["images"]);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 30,
            offset: const Offset(0, 20),
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
                imgs[currentPhoto],
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
              top: 10,
              left: 10,
              right: 10,
              child: Row(
                children: List.generate(imgs.length, (i) {
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
              bottom: 30,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Text(
                        "${data["name"]}, ${data["age"]}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.verified,
                          color: Colors.blue, size: 20),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    data["distance"],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔥 BOTÓN DETALLE (FLECHITA)
            Positioned(
              right: 20,
              bottom: 140,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PetDetailScreen(pet: data),
                    ),
                  );
                },
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.2),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// BOTONES
  Widget _actionButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.7),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 20,
            )
          ],
        ),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }
}