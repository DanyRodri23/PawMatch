import 'package:flutter/material.dart';
import 'pet_age_screen.dart';
import '../../widgets/pet_progress_bar.dart';
import '../../data/pet_profile_data.dart';

class PetNameScreen extends StatefulWidget {
  final bool isBreedDog;

  const PetNameScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetNameScreen> createState() =>
      _PetNameScreenState();
}

class _PetNameScreenState
    extends State<PetNameScreen> {
  final TextEditingController
      petNameController =
          TextEditingController();

  @override
  void initState() {
    super.initState();

    petNameController.text =
        PetProfileData.pet["name"] ?? "";
  }

  @override
  void dispose() {
    petNameController.dispose();
    super.dispose();
  }

  void goNext() {
    final petName =
        petNameController.text.trim();

    if (petName.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Escribe el nombre de tu mascota",
          ),
        ),
      );
      return;
    }

    /// GUARDAR DATA
    PetProfileData.updatePet(
      name: petName,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PetAgeScreen(
          isBreedDog:
              widget.isBreedDog,
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
              step: 1,
              totalSteps: 9,
            ),

            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.all(
                  28,
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
                      "¿Cómo se llama tu mascota? 🐶",
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
                      "Este será el nombre que verán otros usuarios en PawMatch.",
                      style:
                          TextStyle(
                        fontSize:
                            16,
                        color: Colors
                            .black54,
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),

                    TextField(
                      controller:
                          petNameController,
                      style:
                          const TextStyle(
                        fontSize:
                            20,
                        fontWeight:
                            FontWeight
                                .w500,
                      ),
                      decoration:
                          InputDecoration(
                        hintText:
                            "Nombre de tu mascota",
                        filled:
                            true,
                        fillColor: Colors
                            .grey
                            .shade100,
                        border:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                          borderSide:
                              BorderSide.none,
                        ),
                        focusedBorder:
                            OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),
                          borderSide:
                              const BorderSide(
                            color:
                                Colors.black,
                            width:
                                2,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

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
                                  .black,
                          foregroundColor:
                              Colors
                                  .white,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              18,
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
                      height: 20,
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