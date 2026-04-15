import 'package:flutter/material.dart';
import 'pet_goal_screen.dart';
import '../../widgets/pet_progress_bar.dart';
import '../../data/pet_profile_data.dart';

class PetPersonalityScreen extends StatefulWidget {
  final bool isBreedDog;

  const PetPersonalityScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetPersonalityScreen> createState() =>
      _PetPersonalityScreenState();
}

class _PetPersonalityScreenState
    extends State<PetPersonalityScreen> {
  final List<String> selectedTraits = [];

  final TextEditingController
      descriptionController =
      TextEditingController();

  bool isPressed = false;

  final List<String> traits = [
    "Juguetón",
    "Cariñoso",
    "Activo",
    "Protector",
    "Tranquilo",
    "Sociable",
    "Curioso",
    "Energético",
    "Amigable",
    "Dormilón",
    "Inteligente",
    "Travieso",
    "Valiente",
    "Leal",
    "Aventurero",
    "Obediente",
    "Independiente",
    "Territorial",
    "Paciente",
    "Alerta",
    "Tímido",
    "Divertido",
    "Explorador",
    "Amoroso",
    "Atlético",
    "Relajado",
    "Extrovertido",
    "Dominante",
    "Sumiso",
    "Cuidadoso",
    "Fiel",
    "Ruidoso",
    "Silencioso",
    "Cazador",
    "Muy sociable",
    "Protector con la familia",
    "Curioso con todo",
    "Amante de la comida",
    "Buen guardián",
    "Amigable con niños",
    "Perezoso",
    "Dependiente",
    "Sensible",
    "Seguro",
    "Intrépido"
  ];

  @override
  void initState() {
    super.initState();

    final savedTraits =
        List<String>.from(
      PetProfileData.pet["traits"] ??
          [],
    );

    selectedTraits.addAll(
        savedTraits);

    descriptionController.text =
        PetProfileData
                .pet[
            "description"] ??
        "";
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  List<String> detectTraitsFromText(
      String text) {
    final lower =
        text.toLowerCase();

    List<String> detected =
        [];

    if (lower.contains("juguet")) {
      detected.add(
          "Juguetón");
    }

    if (lower.contains(
        "tranquilo")) {
      detected.add(
          "Tranquilo");
    }

    if (lower.contains(
        "activo")) {
      detected.add("Activo");
    }

    if (lower.contains(
        "protector")) {
      detected.add(
          "Protector");
    }

    if (lower.contains(
        "amor")) {
      detected.add(
          "Amoroso");
    }

    if (lower.contains(
        "inteligente")) {
      detected.add(
          "Inteligente");
    }

    return detected;
  }

  void goBack() {
    Navigator.pop(context);
  }

  void goNext() {
    final detected =
        detectTraitsFromText(
      descriptionController.text,
    );

    final finalTraits = {
      ...selectedTraits,
      ...detected,
    }.toList();

    if (finalTraits.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Agrega personalidad o escribe una descripción",
          ),
        ),
      );
      return;
    }

    PetProfileData.updatePet(
      traits: finalTraits,
      description:
          descriptionController
              .text
              .trim(),
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration:
            const Duration(
          milliseconds: 500,
        ),
        pageBuilder:
            (_, __, ___) =>
                PetGoalScreen(
          isBreedDog:
              widget.isBreedDog,
        ),
        transitionsBuilder:
            (
          _,
          animation,
          __,
          child,
        ) {
          final fade = Tween(
            begin: 0.0,
            end: 1.0,
          ).animate(animation);

          final scale =
              Tween(
            begin: 0.95,
            end: 1.0,
          ).animate(
            CurvedAnimation(
              parent:
                  animation,
              curve: Curves
                  .easeOutCubic,
            ),
          );

          return FadeTransition(
            opacity: fade,
            child:
                ScaleTransition(
              scale: scale,
              child: child,
            ),
          );
        },
      ),
    );
  }

  void toggleTrait(
      String trait) {
    setState(() {
      if (selectedTraits
          .contains(trait)) {
        selectedTraits.remove(
            trait);
      } else {
        selectedTraits.add(
            trait);
      }
    });
  }

  Widget buildChip(
      String trait) {
    final selected =
        selectedTraits
            .contains(trait);

    return GestureDetector(
      onTap: () =>
          toggleTrait(
              trait),
      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 250,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),
        decoration:
            BoxDecoration(
          color: selected
              ? Colors.black
              : Colors.grey
                  .shade100,
          borderRadius:
              BorderRadius.circular(
            30,
          ),
          border: Border.all(
            color: selected
                ? Colors.black
                : Colors.grey
                    .shade300,
          ),
        ),
        child: Row(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            if (selected)
              const Padding(
                padding:
                    EdgeInsets.only(
                  right: 6,
                ),
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: Colors
                      .white,
                ),
              ),
            Text(
              trait,
              style:
                  TextStyle(
                fontSize: 14,
                fontWeight:
                    FontWeight
                        .w500,
                color: selected
                    ? Colors
                        .white
                    : Colors
                        .black,
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
    return TweenAnimationBuilder(
      duration:
          const Duration(
        milliseconds: 600,
      ),
      tween: Tween<double>(
        begin: 0,
        end: 1,
      ),
      curve:
          Curves.easeOutCubic,
      builder: (
        context,
        value,
        child,
      ) {
        return Opacity(
          opacity: value,
          child:
              Transform.translate(
            offset: Offset(
              0,
              40 *
                  (1 -
                      value),
            ),
            child: child,
          ),
        );
      },
      child: Scaffold(
        backgroundColor:
            Colors.white,
        appBar: AppBar(
          backgroundColor:
              Colors.white,
          elevation: 0,
          leading:
              IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color:
                  Colors.black,
            ),
            onPressed:
                goBack,
          ),
        ),
        body: Column(
          children: [
            const PetProgressBar(
              step: 10,
              totalSteps: 11,
            ),

            Expanded(
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal:
                        24,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Personalidad de tu mascota",
                        style:
                            TextStyle(
                          fontSize:
                              34,
                          fontWeight:
                              FontWeight.bold,
                          letterSpacing:
                              -1,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text(
                        "Selecciona o describe a tu mascota 🐾",
                        style:
                            TextStyle(
                          fontSize:
                              16,
                          color: Colors
                              .black54,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      TextField(
                        controller:
                            descriptionController,
                        decoration:
                            InputDecoration(
                          hintText:
                              "Ej: Es muy juguetón, cariñoso y protector...",
                          filled:
                              true,
                          fillColor:
                              Colors.grey.shade100,
                          border:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),
                            borderSide:
                                BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Expanded(
                        child:
                            SingleChildScrollView(
                          physics:
                              const BouncingScrollPhysics(),
                          child:
                              Wrap(
                            spacing:
                                10,
                            runSpacing:
                                10,
                            children: traits
                                .map(
                                    buildChip)
                                .toList(),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTapDown:
                            (_) => setState(
                                () =>
                                    isPressed =
                                        true),
                        onTapUp:
                            (_) {
                          setState(
                              () =>
                                  isPressed =
                                      false);
                          goNext();
                        },
                        child:
                            AnimatedScale(
                          scale: isPressed
                              ? 0.96
                              : 1,
                          duration:
                              const Duration(
                            milliseconds:
                                120,
                          ),
                          child:
                              Hero(
                            tag:
                                "continueBtn",
                            child:
                                Container(
                              height:
                                  60,
                              decoration:
                                  BoxDecoration(
                                gradient:
                                    const LinearGradient(
                                  colors: [
                                    Colors.black,
                                    Color(
                                      0xFF1C1C1C,
                                    ),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.circular(
                                  30,
                                ),
                              ),
                              child:
                                  const Center(
                                child:
                                    Text(
                                  "Continuar",
                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white,
                                    fontSize:
                                        18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
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
            ),
          ],
        ),
      ),
    );
  }
}