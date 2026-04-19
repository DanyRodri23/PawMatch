import 'package:flutter/material.dart';

import '../../data/likes_data.dart';
import '../../data/matches_data.dart';

import 'match_success_screen.dart';
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
      "id": "pet1",
      "name": "Luna",
      "age": 2,
      "distance": "A 2 km de distancia",
      "pedigree": true,
      "likedYou": true,
      "images": [
        "https://images.unsplash.com/photo-1558788353-f76d92427f16",
        "https://images.unsplash.com/photo-1548199973-03cce0bbc87b",
      ],
    },
    {
      "id": "pet2",
      "name": "Max",
      "age": 3,
      "distance": "A 5 km de distancia",
      "pedigree": true,
      "likedYou": false,
      "images": [
        "https://images.unsplash.com/photo-1518717758536-85ae29035b6d",
      ],
    },
    {
      "id": "pet3",
      "name": "Rocky",
      "age": 1,
      "distance": "A 4 km de distancia",
      "pedigree": false,
      "likedYou": true,
      "images": [
        "https://images.unsplash.com/photo-1507146426996-ef05306b995a",
      ],
    },
    {
      "id": "pet4",
      "name": "Nala",
      "age": 4,
      "distance": "A 7 km de distancia",
      "pedigree": true,
      "likedYou": false,
      "images": [
        "https://images.unsplash.com/photo-1518020382113-a7e8fc38eac9",
      ],
    },
  ];

  Map<String, dynamic> get pet =>
      pets[currentIndex];

  List<String> get images =>
      List<String>.from(
        pet["images"],
      );

  void nextPhoto() {
    if (currentPhoto <
        images.length - 1) {
      setState(() {
        currentPhoto++;
      });
    }
  }

  void prevPhoto() {
    if (currentPhoto > 0) {
      setState(() {
        currentPhoto--;
      });
    }
  }

  void nextPet() {
    setState(() {
      currentPhoto = 0;
      position = 0;
      rotation = 0;
      currentIndex =
          (currentIndex + 1) %
              pets.length;
    });
  }

  void swipeRight() {
    final likedYou =
        pet["likedYou"] == true;

    if (likedYou) {
      MatchesData.createMatch(
        pet,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              MatchSuccessScreen(
            myPet: "Max",
            otherPet:
                pet["name"],
            image1:
                images[0],
            image2:
                images[0],
          ),
        ),
      );
    } else {
      LikesData.sendLike(
        pet,
      );
    }

    nextPet();
  }

  void swipeLeft() {
    nextPet();
  }

  void openFilters() {}

  @override
  Widget build(
      BuildContext context) {
    final size =
        MediaQuery.of(context)
            .size;

    final padding =
        MediaQuery.of(context)
            .padding;

    final bool isLike =
        position > 0;

    final double dragOpacity =
        (position.abs() / 140)
            .clamp(
          0.0,
          1.0,
        );

    return Scaffold(
      backgroundColor:
          Colors.black,
      body: Stack(
        children: [

          /// FONDO LIKE / NOPE
          if (position != 0)
            Positioned.fill(
              child: Container(
                color: isLike
                    ? Colors.green
                        .withValues(
                        alpha:
                            dragOpacity,
                      )
                    : Colors.red
                        .withValues(
                        alpha:
                            dragOpacity,
                      ),
              ),
            ),

          if (pets.length > 1)
            Transform.scale(
              scale: 0.95,
              child: _buildCard(
                (currentIndex + 1) %
                    pets.length,
              ),
            ),

          GestureDetector(
            onPanUpdate:
                (details) {
              setState(() {
                position +=
                    details
                        .delta.dx;

                rotation =
                    position *
                        0.001;
              });
            },
            onPanEnd: (_) {
              if (position >
                  120) {
                swipeRight();
              } else if (position <
                  -120) {
                swipeLeft();
              } else {
                setState(() {
                  position = 0;
                  rotation = 0;
                });
              }
            },
            onTapUp:
                (details) {
              final width =
                  size.width;

              if (details
                      .localPosition
                      .dx <
                  width / 2) {
                prevPhoto();
              } else {
                nextPhoto();
              }
            },
            child:
                Transform.translate(
              offset: Offset(
                position,
                0,
              ),
              child:
                  Transform.rotate(
                angle:
                    rotation,
                child:
                    _buildCard(
                  currentIndex,
                ),
              ),
            ),
          ),

          /// TEXTO LIKE / NOPE
          if (position.abs() > 20)
            Positioned(
              top:
                  size.height *
                      0.16,
              left: isLike
                  ? 24
                  : null,
              right: isLike
                  ? null
                  : 24,
              child: Transform.rotate(
                angle: isLike
                    ? -0.25
                    : 0.25,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal:
                        20,
                    vertical:
                        10,
                  ),
                  decoration:
                      BoxDecoration(
                    border:
                        Border.all(
                      color: isLike
                          ? Colors
                              .greenAccent
                          : Colors.redAccent,
                      width: 4,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: Text(
                    isLike
                        ? "LIKE"
                        : "NOPE",
                    style:
                        TextStyle(
                      color: isLike
                          ? Colors
                              .greenAccent
                          : Colors.redAccent,
                      fontSize:
                          34,
                      fontWeight:
                          FontWeight.bold,
                      letterSpacing:
                          2,
                    ),
                  ),
                ),
              ),
            ),

          Positioned(
            bottom:
                padding.bottom +
                    size.height *
                        0.01,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceEvenly,
              children: [
                _actionButton(
                  Icons.close,
                  Colors.red,
                  swipeLeft,
                ),
                _actionButton(
                  Icons.star,
                  Colors.blue,
                  () {},
                ),
                _actionButton(
                  Icons.favorite,
                  Colors.green,
                  swipeRight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
      int index) {
    final size =
        MediaQuery.of(context)
            .size;

    final data =
        pets[index];

    final imgs =
        List<String>.from(
      data["images"],
    );

    return Container(
      margin:
          EdgeInsets.symmetric(
        horizontal: 12,
        vertical:
            size.height *
                0.04,
      ),
      decoration:
          BoxDecoration(
        borderRadius:
            BorderRadius.circular(
          30,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
              alpha: 0.6,
            ),
            blurRadius: 30,
            offset:
                const Offset(
              0,
              20,
            ),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(
          30,
        ),
        child: Stack(
          children: [

            Positioned.fill(
              child:
                  Image.network(
                imgs[currentPhoto],
                fit:
                    BoxFit.cover,
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration:
                    const BoxDecoration(
                  gradient:
                      LinearGradient(
                    begin:
                        Alignment
                            .bottomCenter,
                    end: Alignment
                        .center,
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top:
                  size.height *
                      0.09,
              left: 16,
              right: 16,
              child: Row(
                children:
                    List.generate(
                  imgs.length,
                  (i) {
                    final isActive =
                        i ==
                            currentPhoto;

                    return Expanded(
                      child:
                          AnimatedContainer(
                        duration:
                            const Duration(
                          milliseconds:
                              300,
                        ),
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal:
                              3,
                        ),
                        height:
                            3,
                        decoration:
                            BoxDecoration(
                          color: isActive
                              ? Colors
                                  .white
                              : Colors.white
                                  .withValues(
                                  alpha:
                                      0.3,
                                ),
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            Positioned(
              bottom:
                  size.height *
                      0.22,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [

                  Row(
                    children: [
                      Text(
                        "${data["name"]}, ${data["age"]}",
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize:
                              28,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        width: 6,
                      ),

                      if (data["pedigree"] ==
                          true)
                        const Icon(
                          Icons
                              .verified,
                          color:
                              Colors.blue,
                          size: 20,
                        ),
                    ],
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons
                            .location_on,
                        color:
                            Colors.white70,
                        size: 16,
                      ),

                      const SizedBox(
                        width: 4,
                      ),

                      Text(
                        data["distance"],
                        style:
                            const TextStyle(
                          color:
                              Colors.white70,
                          fontSize:
                              15,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Wrap(
                    spacing: 8,
                    children: [
                      _tag(
                        "Juguetón",
                      ),
                      _tag(
                        "Amigable",
                      ),
                      _tag(
                        "Energético",
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Positioned(
              right: 20,
              bottom:
                  size.height *
                      0.22,
              child:
                  GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PetDetailScreen(
                        pet: data,
                      ),
                    ),
                  );
                },
                child:
                    Container(
                  width: 55,
                  height: 55,
                  decoration:
                      BoxDecoration(
                    color: Colors.black
                        .withValues(
                      alpha: 0.6,
                    ),
                    shape:
                        BoxShape.circle,
                  ),
                  child:
                      const Icon(
                    Icons
                        .keyboard_arrow_up,
                    color:
                        Colors.white,
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

  Widget _actionButton(
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 62,
        height: 62,
        decoration:
            BoxDecoration(
          shape:
              BoxShape.circle,
          color: Colors.black
              .withValues(
            alpha: 0.7,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  color.withValues(
                alpha: 0.4,
              ),
              blurRadius: 20,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: 34,
        ),
      ),
    );
  }

  Widget _tag(
    String text,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration:
          BoxDecoration(
        color: Colors.black
            .withValues(
          alpha: 0.6,
        ),
        borderRadius:
            BorderRadius.circular(
          20,
        ),
      ),
      child: Text(
        text,
        style:
            const TextStyle(
          color:
              Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}