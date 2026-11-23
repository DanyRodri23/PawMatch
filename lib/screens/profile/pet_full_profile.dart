import '../../helpers/age_helper.dart';
import '../../widgets/pet_badge_row.dart';
import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import '../../data/likes_data.dart';
import '../../data/matches_data.dart';

enum ProfileMode {
  discover,
  likes,
  match,
}

class PetFullProfile extends StatelessWidget {
  final Map<String, dynamic> pet;
  final ProfileMode mode;

  const PetFullProfile({
    super.key,
    required this.pet,
    this.mode = ProfileMode.discover,
  });

  @override
  Widget build(BuildContext context) {
    final image = (pet["images"] != null &&
            pet["images"] is List &&
            pet["images"].isNotEmpty)
        ? pet["images"][0]
        : "";

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          /// SCROLL
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HERO IMAGE
                Stack(
                  children: [
                    SizedBox(
                      height: 430,
                      width: double.infinity,
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Container(
                      height: 430,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 55,
                      left: 18,
                      child: _glassButton(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.pop(context),
                      ),
                    ),

                    Positioned(
                      bottom: 24,
                      left: 20,
                      right: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${pet["name"]}, ${AgeHelper.shortOf(pet)}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    PetBadgeRow(pet: pet),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  pet["breed"] ?? "",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 120),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      /// CHIPS
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _chip(Icons.location_on,
                              pet["distance"] ?? ""),
                          _chip(Icons.flag,
                              pet["goal"] ?? ""),
                          _chip(Icons.pets,
                              pet["gender"] ?? ""),
                        ],
                      ),

                      const SizedBox(height: 28),

                      /// BIO
                      _sectionTitle("Biografía"),
                      _sectionCard(
                        pet["bio"] ??
                            "Esta mascota aún no tiene biografía.",
                      ),

                      const SizedBox(height: 20),

                      /// HEALTH
                      _sectionTitle("Salud y Verificación"),
                      _sectionCard(
                        "Vacunas: ${pet["vaccines"] ?? "Verificadas"}\n"
                        "Pedigrí: ${pet["pedigree"] == true ? "Sí" : "No"}",
                      ),

                      const SizedBox(height: 20),

                      /// OWNER
                      _sectionTitle("Dueño"),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white10,
                          ),
                        ),
                        child: Row(
                          children: [

                            const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white12,
                              child: Icon(Icons.person),
                            ),

                            const SizedBox(width: 14),

                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pet["owner"] ?? "Dueño",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  "Propietario verificado",
                                  style: TextStyle(
                                    color: Colors.white54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// BOTTOM CTA
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: _buildBottomButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    switch (mode) {
      case ProfileMode.likes:
        return _actionButton(
          "❤️ Like Back",
          Colors.pinkAccent,
          () {
            LikesData.sendLike(pet);

            MatchesData.createMatch(pet);

            LikesData.removeReceivedLike(pet);

            AppData.likedPets.remove(pet);

            Navigator.pop(context);
          },
        );

      case ProfileMode.match:
        return _actionButton(
          "💬 Message",
          Colors.greenAccent,
          () {
            Navigator.pop(context);
          },
        );

      default:
        return _actionButton(
          "❤️ Like",
          Colors.pinkAccent,
          () {
            AppData.addLike(pet);
            Navigator.pop(context);
          },
        );
    }
  }

  static Widget _actionButton(
    String text,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: 20,
            )
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _glassButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  static Widget _chip(IconData icon, String text) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.greenAccent, size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  static Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget _sectionCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          height: 1.5,
        ),
      ),
    );
  }
}