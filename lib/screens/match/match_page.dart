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

  final List<Map<String, dynamic>> allPets = [
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

  // ---------------- FILTROS ----------------
  String filterGender = "Todos";
  RangeValues filterAge = const RangeValues(0, 15);
  double filterKm = 100;
  String filterBreed = "Todas";
  String filterGoal = "Todos";
  bool onlyPedigree = false;
  bool onlyVaccinated = false;
  bool onlyVerified = false;

  /// Datos extra de las mascotas de ejemplo (luego vendrán de Firebase).
  static const Map<String, Map<String, dynamic>> _extra = {
    "pet1": {"gender": "Hembra", "breed": "Golden Retriever", "km": 2, "vaccinated": true, "verified": true, "goal": "Reproducción"},
    "pet2": {"gender": "Macho", "breed": "Husky", "km": 5, "vaccinated": true, "verified": true, "goal": "Amistad"},
    "pet3": {"gender": "Macho", "breed": "Labrador", "km": 4, "vaccinated": false, "verified": false, "goal": "Compañero de juego"},
    "pet4": {"gender": "Hembra", "breed": "Poodle", "km": 7, "vaccinated": true, "verified": true, "goal": "Reproducción"},
  };

  static const List<String> _breedOptions = [
    "Todas", "Golden Retriever", "Labrador", "Pastor Alemán", "Poodle",
    "Bulldog", "Chihuahua", "Beagle", "Husky", "Shih Tzu", "Mestizo",
  ];

  static const List<String> _goalOptions = [
    "Todos", "Reproducción", "Amistad", "Compañero de juego", "Paseos",
  ];

  int get activeFilters {
    int n = 0;
    if (filterGender != "Todos") n++;
    if (filterAge.start > 0 || filterAge.end < 15) n++;
    if (filterKm < 100) n++;
    if (filterBreed != "Todas") n++;
    if (filterGoal != "Todos") n++;
    if (onlyPedigree) n++;
    if (onlyVaccinated) n++;
    if (onlyVerified) n++;
    return n;
  }

  bool _passesFilters(Map<String, dynamic> p) {
    final e = _extra[p["id"]] ?? const {};
    final age = (p["age"] as num?)?.toDouble() ?? 0;

    if (filterGender != "Todos" && e["gender"] != filterGender) return false;
    if (age < filterAge.start || age > filterAge.end) return false;
    if (((e["km"] as num?) ?? 0) > filterKm) return false;
    if (filterBreed != "Todas" && e["breed"] != filterBreed) return false;
    if (filterGoal != "Todos" && e["goal"] != filterGoal) return false;
    if (onlyPedigree && p["pedigree"] != true) return false;
    if (onlyVaccinated && e["vaccinated"] != true) return false;
    if (onlyVerified && e["verified"] != true) return false;

    return true;
  }

  List<Map<String, dynamic>> get pets =>
      allPets.where(_passesFilters).toList();

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
    if (pets.isEmpty) return;

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
            matchPet: pet,
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

  void resetFilters() {
    filterGender = "Todos";
    filterAge = const RangeValues(0, 15);
    filterKm = 100;
    filterBreed = "Todas";
    filterGoal = "Todos";
    onlyPedigree = false;
    onlyVaccinated = false;
    onlyVerified = false;
  }

  void openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FilterSheet(
        gender: filterGender,
        age: filterAge,
        km: filterKm,
        breed: filterBreed,
        goal: filterGoal,
        pedigree: onlyPedigree,
        vaccinated: onlyVaccinated,
        verified: onlyVerified,
        breedOptions: _breedOptions,
        goalOptions: _goalOptions,
        onApply: (r) {
          setState(() {
            filterGender = r.gender;
            filterAge = r.age;
            filterKm = r.km;
            filterBreed = r.breed;
            filterGoal = r.goal;
            onlyPedigree = r.pedigree;
            onlyVaccinated = r.vaccinated;
            onlyVerified = r.verified;
            currentIndex = 0;
            currentPhoto = 0;
            position = 0;
            rotation = 0;
          });
        },
      ),
    );
  }

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

    if (pets.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.pets,
                  size: 64,
                  color: Colors.white24,
                ),
                const SizedBox(height: 18),
                const Text(
                  "No hay mascotas con esos filtros",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Prueba ampliando la distancia o la edad.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    setState(resetFilters);
                  },
                  child: const Text("Quitar filtros"),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: openFilters,
                  child: const Text(
                    "Cambiar filtros",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (currentIndex >= pets.length) currentIndex = 0;

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
            bottom: padding.bottom + 8,
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
    final padding =
        MediaQuery.of(context)
            .padding;

    // Medidas según el teléfono (en vez de porcentajes fijos):
    // - headerHeight: barra de arriba (filtro + pestañas)
    // - padding.bottom: incluye la barra de navegación de abajo
    final double headerHeight = padding.top + 82;
    const double actionButtonSize = 62;
    const double cardBottomMargin = 0;
    const double cardTopMargin = 0;
    final double actionsBottom = padding.bottom + 8;
    final double infoBottom =
        actionsBottom + actionButtonSize + 16 - cardBottomMargin;

    // La foto termina un poco debajo del nombre; abajo queda un panel oscuro
    // con nombre, distancia y botones (como Tinder).
    final double photoBottom = infoBottom + 70;

    final data =
        pets[index];

    final imgs =
        List<String>.from(
      data["images"],
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(
        0,
        cardTopMargin,
        0,
        cardBottomMargin,
      ),
      decoration:
          BoxDecoration(
        color: Colors.black,
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
        borderRadius: BorderRadius.zero,
        child: Stack(
          children: [

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: photoBottom,
              child:
                  Image.network(
                imgs[currentPhoto],
                fit:
                    BoxFit.cover,
              ),
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: photoBottom,
              child: Container(
                decoration:
                    const BoxDecoration(
                  gradient:
                      LinearGradient(
                    begin:
                        Alignment
                            .bottomCenter,
                    end: Alignment(
                        0, 0.45),
                    colors: [
                      Colors.black,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: headerHeight,
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
              bottom: infoBottom,
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
              bottom: infoBottom,
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

class _FilterResult {
  final String gender;
  final RangeValues age;
  final double km;
  final String breed;
  final String goal;
  final bool pedigree;
  final bool vaccinated;
  final bool verified;

  const _FilterResult({
    required this.gender,
    required this.age,
    required this.km,
    required this.breed,
    required this.goal,
    required this.pedigree,
    required this.vaccinated,
    required this.verified,
  });
}

/// Hoja "Mis preferencias" para filtrar las mascotas.
class _FilterSheet extends StatefulWidget {
  final String gender;
  final RangeValues age;
  final double km;
  final String breed;
  final String goal;
  final bool pedigree;
  final bool vaccinated;
  final bool verified;
  final List<String> breedOptions;
  final List<String> goalOptions;
  final void Function(_FilterResult) onApply;

  const _FilterSheet({
    required this.gender,
    required this.age,
    required this.km,
    required this.breed,
    required this.goal,
    required this.pedigree,
    required this.vaccinated,
    required this.verified,
    required this.breedOptions,
    required this.goalOptions,
    required this.onApply,
  });

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String gender = widget.gender;
  late RangeValues age = widget.age;
  late double km = widget.km;
  late String breed = widget.breed;
  late String goal = widget.goal;
  late bool pedigree = widget.pedigree;
  late bool vaccinated = widget.vaccinated;
  late bool verified = widget.verified;

  void _apply() {
    widget.onApply(
      _FilterResult(
        gender: gender,
        age: age,
        km: km,
        breed: breed,
        goal: goal,
        pedigree: pedigree,
        vaccinated: vaccinated,
        verified: verified,
      ),
    );
    Navigator.pop(context);
  }

  void _clear() {
    setState(() {
      gender = "Todos";
      age = const RangeValues(0, 15);
      km = 100;
      breed = "Todas";
      goal = "Todos";
      pedigree = false;
      vaccinated = false;
      verified = false;
    });
  }

  Widget _title(String t) => Padding(
        padding: const EdgeInsets.only(top: 26, bottom: 12),
        child: Text(
          t,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? Colors.pinkAccent.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? Colors.pinkAccent : Colors.transparent,
            width: 1.4,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.pinkAccent : Colors.white70,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _switch(String label, IconData icon, bool value,
      ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      activeColor: Colors.pinkAccent,
      secondary: Icon(icon, color: Colors.white54),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.92;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 16, 0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _clear,
                    child: const Text(
                      "Borrar",
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "Mis preferencias",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _apply,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: Colors.pinkAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title("Busco"),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: ["Todos", "Macho", "Hembra"]
                          .map((g) => _chip(g, gender == g,
                              () => setState(() => gender = g)))
                          .toList(),
                    ),

                    _title(
                      "Edad: ${age.start.round()} - ${age.end.round() >= 15 ? "15+" : age.end.round()} años",
                    ),
                    RangeSlider(
                      values: age,
                      min: 0,
                      max: 15,
                      divisions: 15,
                      activeColor: Colors.pinkAccent,
                      inactiveColor: Colors.white12,
                      onChanged: (v) => setState(() => age = v),
                    ),

                    _title(
                      "Distancia máxima: ${km.round() >= 100 ? "Sin límite" : "${km.round()} km"}",
                    ),
                    Slider(
                      value: km,
                      min: 1,
                      max: 100,
                      activeColor: Colors.pinkAccent,
                      inactiveColor: Colors.white12,
                      onChanged: (v) => setState(() => km = v),
                    ),

                    _title("Raza"),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.breedOptions
                          .map((b) => _chip(b, breed == b,
                              () => setState(() => breed = b)))
                          .toList(),
                    ),

                    _title("Qué buscan"),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.goalOptions
                          .map((g) => _chip(g, goal == g,
                              () => setState(() => goal = g)))
                          .toList(),
                    ),

                    _title("Confianza"),
                    _switch("Solo con pedigrí", Icons.workspace_premium,
                        pedigree, (v) => setState(() => pedigree = v)),
                    _switch("Solo vacunados", Icons.vaccines, vaccinated,
                        (v) => setState(() => vaccinated = v)),
                    _switch("Solo verificados", Icons.verified, verified,
                        (v) => setState(() => verified = v)),
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
