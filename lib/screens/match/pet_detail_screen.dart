import '../../widgets/pet_badge_row.dart';
import '../../helpers/pet_badges.dart';
import 'package:flutter/material.dart';
import 'gallery_viewer_screen.dart';
import '../profile/owner_profile_sheet.dart';

class PetDetailScreen extends StatelessWidget {
  final Map<String, dynamic> pet;

  const PetDetailScreen({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    final List images = pet["images"] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                /// HERO IMAGE
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SizedBox(
                      height: 420,
                      width: double.infinity,
                      child: Image.network(
                        images.isNotEmpty ? images[0] : "",
                        fit: BoxFit.cover,
                      ),
                    ),

                    Container(
                      height: 420,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(0, 0, 0, 0.05),
                            Color.fromRGBO(0, 0, 0, 0.95),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 55,
                      left: 18,
                      child: _glassButton(
                        Icons.arrow_back_ios_new,
                        () => Navigator.pop(context),
                      ),
                    ),

                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: -55,
                      child: Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(
                            38,
                            38,
                            38,
                            0.72,
                          ),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${pet["name"]}, ${pet["age"]}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),

                                PetBadgeRow(pet: pet),
                              ],
                            ),

                            const SizedBox(height: 8),

                            Text(
                              pet["breed"] ??
                                  "Raza no especificada",
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.white54,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  pet["distance"] ?? "",
                                  style: const TextStyle(
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 80),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _infoBox(
                              "Género",
                              pet["gender"] ?? "-",
                              Icons.male,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _infoBox(
                              "Busca",
                              pet["goal"] ?? "-",
                              Icons.flag,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _infoBox(
                              "Edad",
                              "${pet["age"]} años",
                              Icons.cake,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _infoBox(
                              "Vacunas",
                              PetBadges.vaccineApproved(pet)
                                  ? "Verificadas"
                                  : (PetBadges.vaccine(pet) == "pending"
                                      ? "En revisión"
                                      : "Sin verificar"),
                              Icons.health_and_safety,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      _title("Personalidad"),

                      const SizedBox(height: 14),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _tag("Alegre"),
                          _tag("Juguetón"),
                          _tag("Activo"),
                          _tag("Sociable"),
                        ],
                      ),

                      const SizedBox(height: 30),

                      _title("Sobre la mascota"),

                      const SizedBox(height: 14),

                      _sectionCard(
                        pet["description"] ??
                            "Sin descripción.",
                      ),

                      const SizedBox(height: 30),

                      _title("Galería"),

                      const SizedBox(height: 14),

                      SizedBox(
                        height: 110,
                        child: ListView.builder(
                          scrollDirection:
                              Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        GalleryViewerScreen(
                                      images: images,
                                      initialIndex: index,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 110,
                                margin:
                                    const EdgeInsets.only(
                                  right: 12,
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(
                                    18,
                                  ),
                                  child: Hero(
                                    tag: "gallery_$index",
                                    child: Image.network(
                                      images[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      _title("Propietario"),

                      const SizedBox(height: 14),

                      GestureDetector(
                        onTap: () {
                          showOwnerProfileSheet(
                              context);
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.all(
                            16,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                const Color.fromRGBO(
                              38,
                              38,
                              38,
                              0.72,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              22,
                            ),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 28,
                                backgroundImage:
                                    NetworkImage(
                                  "https://i.pravatar.cc/300",
                                ),
                              ),

                              const SizedBox(
                                  width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: const [
                                    Text(
                                      "Daniel Rodríguez",
                                      style:
                                          TextStyle(
                                        color: Colors
                                            .white,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),

                                    SizedBox(
                                        height: 4),

                                    Text(
                                      "21 años • Masculino",
                                      style:
                                          TextStyle(
                                        color: Colors
                                            .white60,
                                      ),
                                    ),

                                    SizedBox(
                                        height: 4),

                                    Text(
                                      "Toca para ver perfil",
                                      style:
                                          TextStyle(
                                        color: Colors
                                            .blue,
                                        fontSize:
                                            12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(
                                Icons
                                    .keyboard_arrow_up,
                                color:
                                    Colors.white54,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _glassButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color.fromRGBO(
            25,
            25,
            25,
            0.78,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }

  static Widget _infoBox(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(
          38,
          38,
          38,
          0.72,
        ),
        borderRadius:
            BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.amber),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 21,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget _tag(String text) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(
          38,
          38,
          38,
          0.72,
        ),
        borderRadius:
            BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
        ),
      ),
    );
  }

  static Widget _sectionCard(
    String text,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(
          38,
          38,
          38,
          0.72,
        ),
        borderRadius:
            BorderRadius.circular(22),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          height: 1.6,
        ),
      ),
    );
  }
}