import 'package:flutter/material.dart';
import 'package:pawmatch/screens/onboarding/pet_gender_screen.dart';
import '../../helpers/pet_flow_helper.dart';
import '../../widgets/pet_progress_bar.dart';
import '../../data/pet_profile_data.dart';

class PetAgeScreen extends StatefulWidget {
  final bool isBreedDog;

  const PetAgeScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetAgeScreen> createState() =>
      _PetAgeScreenState();
}

class _PetAgeScreenState
    extends State<PetAgeScreen>
    with SingleTickerProviderStateMixin {
  int age = 1;
  String selectedUnit = "años";

  late AnimationController
      _controller;

  @override
  void initState() {
    super.initState();

    age =
        PetProfileData.pet["age"] ??
            1;

    selectedUnit =
        PetProfileData
                .pet["ageType"] ??
            "años";

    _controller =
        AnimationController(
      vsync: this,
      duration:
          const Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.9,
      upperBound: 1.0,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void animatePress() {
    _controller
        .reverse()
        .then(
          (_) =>
              _controller.forward(),
        );
  }

  void increase() {
    animatePress();

    setState(() {
      age++;
    });
  }

  void decrease() {
    if (age > 0) {
      animatePress();

      setState(() {
        age--;
      });
    }
  }

  String getPetMessage() {
    if (age <= 1) {
      return "🐶 Es un bebé aún";
    }

    if (age <= 5) {
      return "🐕 En su mejor etapa";
    }

    if (age <= 10) {
      return "🐾 Lleno de energía";
    }

    return "🦴 Un veterano lleno de amor";
  }

  void goNext() {
    if (age == 0) return;

    PetProfileData.updatePet(
      age: age,
      ageType: selectedUnit,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PetGenderScreen(
          isBreedDog:
              widget.isBreedDog,
        ),
      ),
    );
  }

  Widget unitSelector(
      String text) {
    final isSelected =
        selectedUnit == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUnit = text;
        });
      },
      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 250,
        ),
        padding:
            const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 28,
        ),
        decoration:
            BoxDecoration(
          color: isSelected
              ? Colors.black
              : Colors.white,
          borderRadius:
              BorderRadius.circular(
            30,
          ),
          border: Border.all(
            color:
                Colors.grey.shade300,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.black,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget counterButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: ScaleTransition(
        scale: _controller,
        child: Container(
          width: 55,
          height: 55,
          decoration:
              BoxDecoration(
            color:
                Colors.grey.shade100,
            shape:
                BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color:
                    Colors.black12,
                blurRadius: 6,
                offset:
                    Offset(0, 3),
              )
            ],
          ),
          child: Icon(
            icon,
            size: 28,
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
              step: 2,
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
                  children: [
                    const SizedBox(
                      height: 40,
                    ),

                    const Align(
                      alignment:
                          Alignment
                              .centerLeft,
                      child: Text(
                        "¿Qué edad tiene tu mascota?",
                        style:
                            TextStyle(
                          fontSize:
                              32,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    const Align(
                      alignment:
                          Alignment
                              .centerLeft,
                      child: Text(
                        "Esto nos ayuda a encontrar mascotas compatibles.",
                        style:
                            TextStyle(
                          color: Colors
                              .black54,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 60,
                    ),

                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 40,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors
                            .grey
                            .shade50,
                        borderRadius:
                            BorderRadius.circular(
                          30,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors
                                .black12,
                            blurRadius:
                                20,
                            offset:
                                Offset(
                              0,
                              10,
                            ),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              counterButton(
                                Icons.remove,
                                decrease,
                              ),

                              const SizedBox(
                                width: 25,
                              ),

                              AnimatedSwitcher(
                                duration:
                                    const Duration(
                                  milliseconds:
                                      300,
                                ),
                                transitionBuilder:
                                    (
                                  child,
                                  animation,
                                ) =>
                                        ScaleTransition(
                                  scale:
                                      animation,
                                  child:
                                      child,
                                ),
                                child:
                                    Text(
                                  "$age",
                                  key: ValueKey(
                                    age,
                                  ),
                                  style:
                                      const TextStyle(
                                    fontSize:
                                        70,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 25,
                              ),

                              counterButton(
                                Icons.add,
                                increase,
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          AnimatedSwitcher(
                            duration:
                                const Duration(
                              milliseconds:
                                  300,
                            ),
                            child: Text(
                              getPetMessage(),
                              key:
                                  ValueKey(
                                age,
                              ),
                              style:
                                  const TextStyle(
                                fontSize:
                                    16,
                                color: Colors
                                    .black54,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                            children: [
                              unitSelector(
                                  "años"),
                              const SizedBox(
                                width: 15,
                              ),
                              unitSelector(
                                  "meses"),
                            ],
                          ),
                        ],
                      ),
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