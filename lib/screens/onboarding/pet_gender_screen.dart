import 'package:flutter/material.dart';
import 'pet_breed_type_screen.dart';
import '../../helpers/pet_flow_helper.dart';
import '../../widgets/pet_progress_bar.dart';
import '../../data/pet_profile_data.dart';

class PetGenderScreen extends StatefulWidget {
  final bool isBreedDog;

  const PetGenderScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetGenderScreen> createState() =>
      _PetGenderScreenState();
}

class _PetGenderScreenState
    extends State<PetGenderScreen>
    with SingleTickerProviderStateMixin {
  String? selectedGender;

  late AnimationController
      _controller;

  @override
  void initState() {
    super.initState();

    selectedGender =
        PetProfileData.pet["gender"];

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

  void selectGender(
      String gender) {
    animateTap();

    setState(() {
      selectedGender = gender;
    });
  }

  void goNext() {
    if (selectedGender == null) {
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

    PetProfileData.updatePet(
      gender: selectedGender,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PetBreedTypeScreen(
          isBreedDog:
              widget.isBreedDog,
        ),
      ),
    );
  }

  Widget genderCard({
    required String gender,
    required String title,
    required String emoji,
    required String subtitle,
  }) {
    final isSelected =
        selectedGender == gender;

    return GestureDetector(
      onTap: () =>
          selectGender(gender),
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
            PetProgressBar(
              step: 3,
              totalSteps: PetFlowHelper.totalSteps,
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
                      "¿Cuál es el sexo de tu mascota?",
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

                    genderCard(
                      gender:
                          "macho",
                      title:
                          "Macho",
                      emoji: "🐶",
                      subtitle:
                          "Protector, juguetón y fiel",
                    ),

                    genderCard(
                      gender:
                          "hembra",
                      title:
                          "Hembra",
                      emoji: "🐕",
                      subtitle:
                          "Cariñosa, inteligente y elegante",
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