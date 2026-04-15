import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'pet_name_screen.dart';

class PetIntroScreen extends StatefulWidget {
  const PetIntroScreen({
    super.key,
  });

  @override
  State<PetIntroScreen> createState() =>
      _PetIntroScreenState();
}

class _PetIntroScreenState
    extends State<PetIntroScreen> {
  late VideoPlayerController
      _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        VideoPlayerController.asset(
      "assets/videos/pet_intro.mp4",
    )
          ..initialize().then(
            (_) {
              setState(() {});
            },
          );

    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startPetProfile() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const PetNameScreen(
          isBreedDog: false,
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child:
                _controller
                        .value
                        .isInitialized
                    ? FittedBox(
                        fit:
                            BoxFit.cover,
                        child:
                            SizedBox(
                          width:
                              _controller
                                  .value
                                  .size
                                  .width,
                          height:
                              _controller
                                  .value
                                  .size
                                  .height,
                          child:
                              VideoPlayer(
                            _controller,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors
                            .black,
                      ),
          ),

          Container(
            decoration:
                const BoxDecoration(
              gradient:
                  LinearGradient(
                begin:
                    Alignment
                        .topCenter,
                end: Alignment
                    .bottomCenter,
                colors: [
                  Color.fromRGBO(
                    0,
                    0,
                    0,
                    0.35,
                  ),
                  Color.fromRGBO(
                    0,
                    0,
                    0,
                    0.55,
                  ),
                ],
              ),
            ),
          ),

          Center(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                30,
              ),
              child: BackdropFilter(
                filter:
                    ImageFilter.blur(
                  sigmaX: 14,
                  sigmaY: 14,
                ),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(
                    horizontal:
                        25,
                  ),
                  padding:
                      const EdgeInsets.all(
                    28,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        const Color.fromRGBO(
                      255,
                      255,
                      255,
                      0.18,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),
                    border:
                        Border.all(
                      color:
                          const Color.fromRGBO(
                        255,
                        255,
                        255,
                        0.35,
                      ),
                      width:
                          1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors
                            .black
                            .withValues(
                          alpha:
                              0.25,
                        ),
                        blurRadius:
                            25,
                        offset:
                            const Offset(
                          0,
                          12,
                        ),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize
                            .min,
                    children: [
                      const Text(
                        "Perfil de tu mascota 🐶",
                        textAlign:
                            TextAlign
                                .center,
                        style:
                            TextStyle(
                          fontSize:
                              32,
                          fontWeight:
                              FontWeight
                                  .bold,
                          color:
                              Colors
                                  .white,
                        ),
                      ),
                      const SizedBox(
                        height:
                            15,
                      ),
                      const Text(
                        "Ahora agregaremos la información de tu mascota para encontrar el match perfecto.",
                        textAlign:
                            TextAlign
                                .center,
                        style:
                            TextStyle(
                          fontSize:
                              18,
                          color:
                              Colors
                                  .white,
                          height:
                              1.4,
                        ),
                      ),
                      const SizedBox(
                        height:
                            25,
                      ),
                      SizedBox(
                        width: double
                            .infinity,
                        height: 55,
                        child:
                            ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors
                                    .white,
                            foregroundColor:
                                Colors
                                    .black,
                            elevation:
                                0,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                30,
                              ),
                            ),
                          ),
                          onPressed:
                              startPetProfile,
                          child:
                              const Text(
                            "Comenzar",
                            style:
                                TextStyle(
                              fontSize:
                                  18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}