import '../../helpers/age_helper.dart';
import '../../widgets/pet_badge_row.dart';
import 'package:flutter/material.dart';

import '../../data/discover_prefs.dart';
import '../../data/likes_data.dart';
import '../../data/matches_data.dart';
import '../../data/pet_options.dart';
import '../../data/pet_profile_data.dart';
import '../../data/sample_pets.dart';

import 'match_success_screen.dart';
import 'pet_detail_screen.dart';

class MatchPage extends StatefulWidget {
  final ValueChanged<int>? onFiltersChanged;

  final String? initialGoal;
  final bool initialPedigree;
  final double? initialKm;

  const MatchPage({
    super.key,
    this.onFiltersChanged,
    this.initialGoal,
    this.initialPedigree = false,
    this.initialKm,
  });

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

  void _loadPrefs() {
    filterGender = DiscoverPrefs.gender;
    filterAge = RangeValues(DiscoverPrefs.ageMin, DiscoverPrefs.ageMax);
    filterKm = DiscoverPrefs.km;
  }

  void _onPrefsChanged() {
    if (!mounted) return;
    setState(() {
      _loadPrefs();
      currentIndex = 0;
      currentPhoto = 0;
      position = 0;
      rotation = 0;
    });
    widget.onFiltersChanged?.call(activeFilters);
  }

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    if (widget.initialGoal != null) filterGoal = widget.initialGoal!;
    if (widget.initialPedigree) onlyPedigree = true;
    if (widget.initialKm != null) filterKm = widget.initialKm!;
    DiscoverPrefs.version.addListener(_onPrefsChanged);
  }

  @override
  void dispose() {
    DiscoverPrefs.version.removeListener(_onPrefsChanged);
    super.dispose();
  }

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

  /// Mascotas a las que ya les diste me gusta / match: no vuelven a salir.
  static final Set<String> _acted = {};

  List<Map<String, dynamic>> get pets => allPets
      .where((p) => !_acted.contains(p["id"]) && _passesFilters(p))
      .toList();

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
    if (pets.isEmpty) return;

    // Guardamos la mascota ANTES de pasar a la siguiente.
    final liked = Map<String, dynamic>.from(pet);
    final likedImages = List<String>.from(liked["images"] as List);
    final likedImage = likedImages.isNotEmpty ? likedImages.first : "";

    final myImages = PetProfileData.pet["images"];
    final myImage = (myImages is List && myImages.isNotEmpty)
        ? myImages.first.toString()
        : likedImage;
    final myName = (PetProfileData.pet["name"] ?? "").toString();

    if (liked["likedYou"] == true) {
      MatchesData.createMatch(liked);
    } else {
      LikesData.sendLike(liked);
    }

    // La mascota sale del mazo (ya no vuelve a aparecer).
    setState(() {
      _acted.add(liked["id"].toString());
      currentPhoto = 0;
      position = 0;
      rotation = 0;
      final n = pets.length;
      if (n == 0 || currentIndex >= n) currentIndex = 0;
    });

    if (liked["likedYou"] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MatchSuccessScreen(
            matchPet: liked,
            myPet: myName.isEmpty ? "Tu mascota" : myName,
            otherPet: liked["name"],
            image1: myImage,
            image2: likedImage,
          ),
        ),
      );
    }
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
            DiscoverPrefs.gender = r.gender;
            DiscoverPrefs.ageMin = r.age.start;
            DiscoverPrefs.ageMax = r.age.end;
            DiscoverPrefs.km = r.km;
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
          widget.onFiltersChanged?.call(activeFilters);
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
                  "No hay más mascotas por ahora",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Prueba ampliando la distancia, la edad o la raza.",
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
                    widget.onFiltersChanged?.call(0);
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

          /// FONDO LIKE / NOPE (brillo suave desde el borde)
          if (position != 0)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: isLike
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      end: isLike
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      colors: [
                        (isLike
                                ? const Color(0xFF2EE59D)
                                : const Color(0xFFFF4D5E))
                            .withValues(alpha: dragOpacity * 0.55),
                        Colors.transparent,
                      ],
                    ),
                  ),
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
                        0.0014;
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

          /// SELLO LIKE / NOPE
          if (position.abs() > 20)
            Positioned(
              top: size.height * 0.15,
              left: isLike ? 22 : null,
              right: isLike ? null : 22,
              child: IgnorePointer(
                child: Opacity(
                  opacity: ((position.abs() - 20) / 90).clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: 0.8 + dragOpacity * 0.25,
                    child: Transform.rotate(
                      angle: isLike ? -0.22 : 0.22,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isLike
                                ? const Color(0xFF2EE59D)
                                : const Color(0xFFFF4D5E),
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (isLike
                                      ? const Color(0xFF2EE59D)
                                      : const Color(0xFFFF4D5E))
                                  .withValues(alpha: 0.55),
                              blurRadius: 26,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLike
                                  ? Icons.favorite_rounded
                                  : Icons.close_rounded,
                              color: isLike
                                  ? const Color(0xFF2EE59D)
                                  : const Color(0xFFFF4D5E),
                              size: 34,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isLike ? "ME GUSTA" : "NO",
                              style: TextStyle(
                                color: isLike
                                    ? const Color(0xFF2EE59D)
                                    : const Color(0xFFFF4D5E),
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: padding.bottom + 8,
            left: 14,
            right: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _circleBtn(Icons.replay_rounded, Colors.amber, 48, prevPet),
                _circleBtn(Icons.close_rounded, Colors.white, 64, swipeLeft,
                    iconSize: 34),
                _circleBtn(Icons.star_rounded, Colors.lightBlueAccent, 50,
                    () => _soon("Super Like")),
                _circleBtn(Icons.favorite_rounded, Colors.pinkAccent, 64,
                    swipeRight,
                    iconSize: 32),
                _circleBtn(Icons.send_rounded, Colors.lightBlueAccent, 48,
                    () => _soon("Mensaje antes del match")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleBtn(
    IconData icon,
    Color color,
    double size,
    VoidCallback onTap, {
    double? iconSize,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.38),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 16,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: iconSize ?? size * 0.5),
      ),
    );
  }

  void prevPet() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        currentPhoto = 0;
        position = 0;
        rotation = 0;
      });
    }
  }

  void _soon(String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$what: próximamente"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Widget _buildCard(int index) {
    final padding = MediaQuery.of(context).padding;
    const double bigBtn = 64;
    final double actionsBottom = padding.bottom + 8;
    final double infoBottom = actionsBottom + bigBtn + 18;

    final data = pets[index];
    final imgs = List<String>.from(data["images"]);
    final int photo =
        index == currentIndex ? currentPhoto.clamp(0, imgs.length - 1).toInt() : 0;
    final extra = _extra[data["id"]] ?? const {};
    final breed = extra["breed"] as String?;
    final goal = extra["goal"] as String?;

    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          index == currentIndex
              ? Hero(
                  tag: "petphoto_${data["id"] ?? data["name"]}",
                  child: Image.network(
                    imgs[photo],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(color: const Color(0xFF16161C)),
                  ),
                )
              : Image.network(
                  imgs[photo],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFF16161C)),
                ),

          // Sombra arriba (para leer la barra) y abajo (para leer el texto)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: padding.top + 150,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x99000000), Colors.transparent],
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment(0, 0.1),
                  colors: [Color(0xE6000000), Colors.transparent],
                ),
              ),
            ),
          ),

          // Rayitas de fotos: cortas y centradas, debajo de las pestañas
          if (imgs.length > 1)
            Positioned(
              top: padding.top + 74,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(imgs.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    width: i == photo ? 20 : 12,
                    height: 4,
                    decoration: BoxDecoration(
                      color: i == photo
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                }),
              ),
            ),

          // Información
          Positioned(
            bottom: infoBottom,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "${data["name"]}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          if (data["hideAge"] != true &&
                              AgeHelper.shortOf(data).isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                AgeHelper.shortOf(data),
                                maxLines: 1,
                                softWrap: false,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          PetBadgeRow(pet: SamplePets.full(data), size: 24),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        PetDetailScreen.open(
                          context,
                          data,
                          heroTag: "petphoto_${data["id"] ?? data["name"]}",
                          initialPhoto: currentPhoto,
                          onNope: swipeLeft,
                          onLike: swipeRight,
                        );
                      },
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.35),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: Colors.black,
                          size: 34,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      data["distance"] ?? "",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (breed != null) _tag(breed, hot: true),
                    if (goal != null) _tag(goal, hot: true),
                    _tag("Juguetón"),
                    _tag("Amigable"),
                    _tag("Energético"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String text, {bool hot = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: hot
            ? const Color(0xFFF6B8E6)
            : Colors.black.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: hot ? Colors.black : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
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

  Future<void> _pickBreed() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BreedPicker(selected: breed),
    );
    if (result != null) setState(() => breed = result);
  }

  static const Color _card = Color(0xFF1C1C21);
  static const Color _pill = Color(0xFF2A2A30);

  Widget _title(String t, {String? hint}) => Padding(
        padding: const EdgeInsets.only(top: 26, bottom: 10, left: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (hint != null) ...[
              const SizedBox(height: 4),
              Text(
                hint,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ],
        ),
      );

  Widget _box({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(22),
        ),
        child: child,
      );

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.pinkAccent : _pill,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _switch(String label, String sub, IconData icon, bool value,
      ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      activeThumbColor: Colors.white,
      activeTrackColor: Colors.pinkAccent,
      secondary: Icon(icon, color: Colors.lightBlueAccent),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        sub,
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      ),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _pillText(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: _pill,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          t,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      );

  Widget _sentence(String t) => Text(
        t,
        style: const TextStyle(color: Colors.white, fontSize: 17),
      );

  Widget _sliderTheme(Widget slider) => SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 3,
          activeTrackColor: Colors.pinkAccent,
          inactiveTrackColor: Colors.white24,
          thumbColor: Colors.white,
          overlayColor: Colors.pinkAccent.withValues(alpha: 0.15),
          rangeThumbShape: const RoundRangeSliderThumbShape(
            enabledThumbRadius: 12,
          ),
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
        ),
        child: slider,
      );

  Widget _valueRow(String label, String value) => Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white60, fontSize: 15),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.94;
    final ageEnd = age.end.round() >= 15 ? "15+" : "${age.end.round()}";
    final ageText = "${age.start.round()}-$ageEnd años";
    final kmText = km.round() >= 100 ? "sin límite" : "${km.round()} km";
    final genderText = gender == "Todos"
        ? "Machos y hembras"
        : (gender == "Macho" ? "Machos" : "Hembras");

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: Color(0xFF101013),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
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
              padding: const EdgeInsets.fromLTRB(14, 12, 18, 0),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _clear,
                    child: const Text(
                      "Borrar",
                      style: TextStyle(color: Colors.white54, fontSize: 15),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "Mis preferencias",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _apply,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded,
                          color: Colors.black, size: 28),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _sentence("Busco"),
                        _pillText(genderText),
                        _sentence("de"),
                        _pillText(ageText),
                        _sentence("a una distancia máxima de"),
                        _pillText(kmText),
                      ],
                    ),

                    _title("Lo básico"),
                    _box(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Sexo",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: ["Todos", "Macho", "Hembra"]
                                .map((g) => _chip(g, gender == g,
                                    () => setState(() => gender = g)))
                                .toList(),
                          ),
                          const Divider(color: Colors.white12, height: 34),
                          _valueRow("Rango de edad", ageText),
                          _sliderTheme(
                            RangeSlider(
                              values: age,
                              min: 0,
                              max: 15,
                              divisions: 15,
                              onChanged: (v) => setState(() => age = v),
                            ),
                          ),
                          const Divider(color: Colors.white12, height: 22),
                          _valueRow("Distancia máxima", kmText),
                          _sliderTheme(
                            Slider(
                              value: km,
                              min: 1,
                              max: 100,
                              onChanged: (v) => setState(() => km = v),
                            ),
                          ),
                        ],
                      ),
                    ),

                    _title(
                      "Raza",
                      hint: "Elige una raza o toca \"Ver todas\" para buscar.",
                    ),
                    _box(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ...widget.breedOptions.map((b) => _chip(
                              b, breed == b, () => setState(() => breed = b))),
                          if (breed != "Todas" &&
                              !widget.breedOptions.contains(breed))
                            _chip(breed, true, () {}),
                          GestureDetector(
                            onTap: _pickBreed,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.pinkAccent),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.search_rounded,
                                      color: Colors.pinkAccent, size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    "Ver todas",
                                    style: TextStyle(
                                      color: Colors.pinkAccent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    _title("Qué buscan"),
                    _box(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: widget.goalOptions
                            .map((g) => _chip(g, goal == g,
                                () => setState(() => goal = g)))
                            .toList(),
                      ),
                    ),

                    _title(
                      "Confianza",
                      hint: "Solo cuenta lo que PawMatch ya revisó.",
                    ),
                    _box(
                      child: Column(
                        children: [
                          _switch(
                            "Solo con pedigrí",
                            "Pedigrí aprobado por PawMatch",
                            Icons.pets,
                            pedigree,
                            (v) => setState(() => pedigree = v),
                          ),
                          const Divider(color: Colors.white12, height: 1),
                          _switch(
                            "Solo vacunados",
                            "Carnet de vacunas aprobado",
                            Icons.vaccines,
                            vaccinated,
                            (v) => setState(() => vaccinated = v),
                          ),
                          const Divider(color: Colors.white12, height: 1),
                          _switch(
                            "Solo dueños verificados",
                            "Dueños con identidad verificada",
                            Icons.verified,
                            verified,
                            (v) => setState(() => verified = v),
                          ),
                        ],
                      ),
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


class _BreedPicker extends StatefulWidget {
  final String selected;
  const _BreedPicker({required this.selected});

  @override
  State<_BreedPicker> createState() => _BreedPickerState();
}

class _BreedPickerState extends State<_BreedPicker> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height * 0.85;
    final kb = MediaQuery.of(context).viewInsets.bottom;
    final q = query.trim().toLowerCase();
    final list = <String>[
      "Todas",
      ...PetOptions.breeds.where((b) => q.isEmpty || b.toLowerCase().contains(q)),
    ];

    return Padding(
      padding: EdgeInsets.only(bottom: kb),
      child: Container(
        height: h,
        decoration: const BoxDecoration(
          color: Color(0xFF101013),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
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
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Todas las razas",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (v) => setState(() => query = v),
                decoration: InputDecoration(
                  hintText: "Buscar raza...",
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon:
                      const Icon(Icons.search_rounded, color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF1C1C21),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: list.length == 1 && q.isNotEmpty
                  ? const Center(
                      child: Text("No encontramos esa raza",
                          style: TextStyle(color: Colors.white54)),
                    )
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (_, i) {
                        final b = list[i];
                        final sel = b == widget.selected;
                        return ListTile(
                          title: Text(
                            b,
                            style: TextStyle(
                              color: sel ? Colors.pinkAccent : Colors.white,
                              fontWeight:
                                  sel ? FontWeight.w800 : FontWeight.w500,
                            ),
                          ),
                          trailing: sel
                              ? const Icon(Icons.check_rounded,
                                  color: Colors.pinkAccent)
                              : null,
                          onTap: () => Navigator.pop(context, b),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
