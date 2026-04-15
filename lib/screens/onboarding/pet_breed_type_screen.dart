import 'package:flutter/material.dart';
import 'pet_vaccines_screen.dart';
import 'pet_breed_select_screen.dart';
import '../../widgets/pet_progress_bar.dart';
import '../../data/pet_profile_data.dart';

class PetBreedTypeScreen extends StatefulWidget {
  final bool isBreedDog;

  const PetBreedTypeScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetBreedTypeScreen> createState() =>
      _PetBreedTypeScreenState();
}

class _PetBreedTypeScreenState
    extends State<PetBreedTypeScreen>
    with SingleTickerProviderStateMixin {
  String? selected;

  late AnimationController
      _controller;

  @override
  void initState() {
    super.initState();

    final isPureBreed =
        PetProfileData.pet["isPureBreed"];

    if (isPureBreed != null) {
      selected =
          isPureBreed
              ? "raza"
              : "mestizo";
    }

    _controller =
        AnimationController(
      vsync: this,
      duration:
          const Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void animateTap() {
    _controller
        .reverse()
        .then(
          (_) =>
              _controller.forward(),
        );
  }

  void selectOption(
      String value) {
    animateTap();

    setState(() {
      selected = value;
    });
  }

  void goNext() {
    if (selected == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Selecciona una opción",
          ),
        ),
      );
      return;
    }

    final isPureBreed =
        selected == "raza";

    PetProfileData.updatePet(
      isPureBreed:
          isPureBreed,
    );

    if (selected == "raza") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const PetBreedSelectScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const PetVaccinesScreen(
            isBreedDog: false,
          ),
        ),
      );
    }
  }

  Widget optionCard({
    required String value,
    required String title,
    required String subtitle,
    required String emoji,
  }) {
    final isSelected =
        selected == value;

    return GestureDetector(
      onTap: () =>
          selectOption(value),
      child: ScaleTransition(
        scale: _controller,
        child:
            AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 250,
          ),
          margin:
              const EdgeInsets.symmetric(
            vertical: 10,
          ),
          padding:
              const EdgeInsets.all(
            20,
          ),
          decoration:
              BoxDecoration(
            color: isSelected
                ? Colors.black
                : Colors.white,
            borderRadius:
                BorderRadius.circular(
              25,
            ),
            border: Border.all(
              color: isSelected
                  ? Colors.black
                  : Colors.grey
                      .shade300,
            ),
            boxShadow: [
              if (isSelected)
                const BoxShadow(
                  color:
                      Colors.black26,
                  blurRadius:
                      15,
                  offset:
                      Offset(
                    0,
                    6,
                  ),
                )
            ],
          ),
          child: Row(
            children: [
              Text(
                emoji,
                style:
                    const TextStyle(
                  fontSize: 28,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(
                        fontSize:
                            18,
                        fontWeight:
                            FontWeight
                                .bold,
                        color: isSelected
                            ? Colors
                                .white
                            : Colors
                                .black,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      subtitle,
                      style:
                          TextStyle(
                        color: isSelected
                            ? Colors
                                .white70
                            : Colors
                                .black54,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons
                      .check_circle,
                  color:
                      Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const PetProgressBar(
              step: 4,
              totalSteps: 9,
            ),

            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 28,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),

                    const Text(
                      "¿Tu mascota es de raza?",
                      style:
                          TextStyle(
                        fontSize:
                            32,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const Text(
                      "Esto nos ayuda a encontrar mejores coincidencias.",
                      style:
                          TextStyle(
                        color: Colors
                            .black54,
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    optionCard(
                      value:
                          "raza",
                      title:
                          "Perro de raza",
                      subtitle:
                          "Raza definida con características únicas",
                      emoji:
                          "🐕",
                    ),

                    optionCard(
                      value:
                          "mestizo",
                      title:
                          "Mestizo / Zaguate",
                      subtitle:
                          "Único, especial y lleno de personalidad",
                      emoji:
                          "🐶",
                    ),

                    const Spacer(),

                    SizedBox(
                      width: double
                          .infinity,
                      height: 60,
                      child:
                          ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors
                                  .black,
                          foregroundColor:
                              Colors
                                  .white,
                          elevation:
                              10,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              30,
                            ),
                          ),
                        ),
                        onPressed:
                            goNext,
                        child:
                            const Text(
                          "Continuar",
                          style:
                              TextStyle(
                            fontSize:
                                18,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}