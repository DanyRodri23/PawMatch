import 'package:flutter/material.dart';
import 'pet_personality_screen.dart';
import '../../widgets/pet_progress_bar.dart';
import '../../data/pet_profile_data.dart';
import 'package:pawmatch/helpers/pet_flow_helper.dart';

class PetPhotosScreen extends StatefulWidget {
  final bool isBreedDog;
  final bool fromVaccineCard;

  const PetPhotosScreen({
    super.key,
    required this.isBreedDog,
    this.fromVaccineCard = false,
  });

  @override
  State<PetPhotosScreen> createState() =>
      _PetPhotosScreenState();
}

class _PetPhotosScreenState
    extends State<PetPhotosScreen> {
  List<String?> photos =
      List.filled(6, null);

  @override
  void initState() {
    super.initState();

    final savedImages =
        List<String>.from(
      PetProfileData.pet["images"] ??
          [],
    );

    for (int i = 0;
        i < savedImages.length &&
            i < 6;
        i++) {
      photos[i] = savedImages[i];
    }
  }

  void goNext() {
    final validPhotos = photos
        .whereType<String>()
        .toList();

    if (validPhotos.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Agrega al menos una foto",
          ),
        ),
      );
      return;
    }

    PetProfileData.updatePet(
      images: validPhotos,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PetPersonalityScreen(
          isBreedDog:
              widget.isBreedDog,
        ),
      ),
    );
  }

  void goBack() {
    Navigator.pop(context);
  }

  void simulatePhotoPick(
      int index) {
    setState(() {
      photos[index] =
          "https://placedog.net/500?id=${index + 10}";
    });
  }

  Widget photoBox(int index) {
    final isMain =
        index == 0;

    return GestureDetector(
      onTap: () =>
          simulatePhotoPick(
              index),
      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 200,
        ),
        decoration:
            BoxDecoration(
          borderRadius:
              BorderRadius.circular(
            22,
          ),
          gradient:
              LinearGradient(
            colors: [
              Colors.grey
                  .shade100,
              Colors.grey
                  .shade200,
            ],
          ),
          border: Border.all(
            color: isMain
                ? Colors.black
                : Colors.grey
                    .shade300,
            width:
                isMain ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors
                  .black
                  .withValues(
                alpha: 0.06,
              ),
              blurRadius:
                  15,
              offset:
                  const Offset(
                0,
                6,
              ),
            )
          ],
        ),
        child: Stack(
          children: [
            if (photos[index] !=
                null)
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  22,
                ),
                child:
                    Image.network(
                  photos[index]!,
                  fit:
                      BoxFit.cover,
                  width: double
                      .infinity,
                  height: double
                      .infinity,
                ),
              )
            else
              const Center(
                child: Icon(
                  Icons
                      .add_a_photo_rounded,
                  size: 32,
                  color: Colors
                      .black54,
                ),
              ),

            if (isMain)
              Positioned(
                top: 8,
                left: 8,
                child:
                    Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal:
                        8,
                    vertical: 4,
                  ),
                  decoration:
                      BoxDecoration(
                    color: Colors
                        .black,
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                  child:
                      const Text(
                    "Principal",
                    style:
                        TextStyle(
                      color: Colors
                          .white,
                      fontSize:
                          10,
                      fontWeight:
                          FontWeight
                              .w600,
                    ),
                  ),
                ),
              ),
          ],
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

      body: Column(
        children: [

          /// 🔥 HEADER PRO
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: goBack,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors
                          .grey.shade100,
                      shape:
                          BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: PetProgressBar(
                    step: PetFlowHelper.getStep("photos"),
                    totalSteps: PetFlowHelper.totalSteps,
                  
                  ),
                ),
              ],  
            ),
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
                    height: 30,
                  ),

                  const Text(
                    "Fotos de tu mascota",
                    style:
                        TextStyle(
                      fontSize:
                          34,
                      fontWeight:
                          FontWeight
                              .bold,
                      letterSpacing:
                          -1,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    "Agrega fotos increíbles para destacar 🐾",
                    style:
                        TextStyle(
                      fontSize:
                          16,
                      color: Colors
                          .black54,
                    ),
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  Expanded(
                    child:
                        GridView.builder(
                      itemCount: 6,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            3,
                        crossAxisSpacing:
                            14,
                        mainAxisSpacing:
                            14,
                      ),
                      itemBuilder:
                          (
                        context,
                        index,
                      ) {
                        return photoBox(
                            index);
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

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
                            8,
                        shadowColor:
                            Colors
                                .black26,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            25,
                          ),
                        ),
                      ),
                      onPressed:
                          goNext,
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Continuar",
                            style:
                                TextStyle(
                              fontSize:
                                  18,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                              width:
                                  8),
                          Icon(Icons
                              .arrow_forward_rounded)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}