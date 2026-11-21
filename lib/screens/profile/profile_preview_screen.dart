import '../../helpers/pet_badges.dart';
import 'package:flutter/material.dart';
import '../../data/user_profile_data.dart';
import '../match/gallery_viewer_screen.dart';
import '../profile/preview_owner_sheet.dart';

class ProfilePreviewScreen extends StatelessWidget {
  final Map<String, dynamic> pet;

  const ProfilePreviewScreen({
    super.key,
    required this.pet,
  });

  @override
  Widget build(BuildContext context) {
    /// ===============================
    /// PET DATA (EN VIVO)
    /// ===============================
    final List petImages =
        pet["images"] ?? [];

    final String petImage =
        petImages.isNotEmpty
            ? petImages[0]
            : "https://placedog.net/600";

    final String petName =
        pet["name"] ??
            "Tu Mascota";

    final int petAge =
        pet["age"] ?? 1;

    final String breed =
        pet["breed"] ??
            "Raza no especificada";

    final String gender =
        pet["gender"] ?? "-";

    final String looking =
        pet["lookingFor"] ??
            "-";

    final String description =
        pet["description"] ??
            "Sin descripción.";

    final bool vaccinated = PetBadges.vaccineApproved(pet);

    final bool pedigree = PetBadges.pedigreeApproved(pet);

    final List traits =
        pet["traits"] ?? [];

    /// ===============================
    /// USER DATA (EN VIVO)
    /// ===============================
        final user =
            UserProfileData.user;

        final List userImages =
            user["images"] ?? [];

        final String userImage =
            userImages.isNotEmpty
                ? userImages[0]
                : "";

        final String userName =
            user["name"] ??
                "Usuario";

        final String city =
            user["location"] ??
                "Costa Rica";

        final bool verified =
            user["verified"] ??
                false;

    return Scaffold(
      backgroundColor:
          const Color(
        0xFF000000,
      ),

      body: Stack(
        children: [

          SingleChildScrollView(
            child: Column(
              children: [

                /// HERO IMAGE
                Stack(
                  clipBehavior:
                      Clip.none,
                  children: [

                    SizedBox(
                      height: 420,
                      width:
                          double.infinity,
                      child:
                          Image.network(
                        petImage,
                        fit:
                            BoxFit.cover,
                      ),
                    ),

                    Container(
                      height: 420,
                      decoration:
                          const BoxDecoration(
                        gradient:
                            LinearGradient(
                          begin:
                              Alignment.topCenter,
                          end:
                              Alignment.bottomCenter,
                          colors: [
                            Color.fromRGBO(
                                0,
                                0,
                                0,
                                0.05),
                            Color.fromRGBO(
                                0,
                                0,
                                0,
                                0.95),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      top: 55,
                      left: 18,
                      child:
                          _glassButton(
                        Icons
                            .arrow_back_ios_new,
                        () =>
                            Navigator.pop(
                          context,
                        ),
                      ),
                    ),

                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: -55,
                      child:
                          Container(
                        padding:
                            const EdgeInsets.all(
                          22,
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
                            28,
                          ),
                          border:
                              Border.all(
                            color:
                                const Color.fromRGBO(
                              255,
                              255,
                              255,
                              0.05,
                            ),
                          ),
                          boxShadow:
                              const [
                            BoxShadow(
                              color:
                                  Color.fromRGBO(
                                0,
                                0,
                                0,
                                0.55,
                              ),
                              blurRadius:
                                  35,
                              offset:
                                  Offset(
                                0,
                                15,
                              ),
                            ),
                          ],
                        ),
                        child:
                            Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: [

                                Expanded(
                                  child:
                                      Text(
                                    "$petName, $petAge",
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white,
                                      fontSize:
                                          30,
                                      fontWeight:
                                          FontWeight.w800,
                                    ),
                                  ),
                                ),

                                if (pedigree)
                                  _certBadge(
                                    Icons.pets,
                                    Colors.blue,
                                  ),

                                if (vaccinated)
                                  const SizedBox(
                                    width: 8,
                                  ),

                                if (vaccinated)
                                  _certBadge(
                                    Icons.vaccines,
                                    Colors.lightBlueAccent,
                                  ),

                                if (verified)
                                  const SizedBox(
                                    width: 8,
                                  ),

                                if (verified)
                                  _certBadge(
                                    Icons.verified,
                                    Colors.blue,
                                  ),
                              ],
                            ),

                            const SizedBox(
                                height: 8),

                            Text(
                              breed,
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white70,
                                fontSize:
                                    15,
                              ),
                            ),

                            const SizedBox(
                                height: 16),

                            Row(
                              children: [

                                const Icon(
                                  Icons.location_on,
                                  color:
                                      Colors.white54,
                                  size:
                                      17,
                                ),

                                const SizedBox(
                                  width: 6,
                                ),

                                Text(
                                  city,
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white54,
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

                const SizedBox(
                    height: 80),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      /// INFO
                      Row(
                        children: [

                          Expanded(
                            child:
                                _infoBox(
                              "Género",
                              gender,
                              Icons.male,
                            ),
                          ),

                          const SizedBox(
                              width:
                                  12),

                          Expanded(
                            child:
                                _infoBox(
                              "Busca",
                              looking,
                              Icons.flag,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height:
                              12),

                      Row(
                        children: [

                          Expanded(
                            child:
                                _infoBox(
                              "Edad",
                              "$petAge años",
                              Icons.cake,
                            ),
                          ),

                          const SizedBox(
                              width:
                                  12),

                          Expanded(
                            child:
                                _infoBox(
                              "Vacunas",
                              vaccinated
                                  ? "Al día"
                                  : "No",
                              Icons
                                  .health_and_safety,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height:
                              30),

                      _title(
                        "Personalidad",
                      ),

                      const SizedBox(
                          height:
                              14),

                      Wrap(
                        spacing:
                            10,
                        runSpacing:
                            10,
                        children: traits
                            .map<Widget>(
                              (e) =>
                                  _tag(
                                e.toString(),
                              ),
                            )
                            .toList(),
                      ),

                      const SizedBox(
                          height:
                              30),

                      _title(
                        "Sobre la mascota",
                      ),

                      const SizedBox(
                          height:
                              14),

                      _sectionCard(
                        description,
                      ),

                      const SizedBox(
                          height:
                              30),

                      /// GALERIA
                      if (petImages
                          .length >
                          1) ...[
                        _title(
                          "Galería",
                        ),

                        const SizedBox(
                            height:
                                14),

                        SizedBox(
                          height:
                              110,
                          child:
                              ListView.builder(
                            scrollDirection:
                                Axis.horizontal,
                            itemCount:
                                petImages.length,
                            itemBuilder:
                                (_, index) {
                              return GestureDetector(
                                onTap:
                                    () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) =>
                                              GalleryViewerScreen(
                                        images:
                                            petImages,
                                        initialIndex:
                                            index,
                                      ),
                                    ),
                                  );
                                },
                                child:
                                    Container(
                                  width:
                                      110,
                                  margin:
                                      const EdgeInsets.only(
                                    right:
                                        12,
                                  ),
                                  child:
                                      ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(
                                      18,
                                    ),
                                    child:
                                        Image.network(
                                      petImages[
                                          index],
                                      fit:
                                          BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(
                            height:
                                30),
                      ],

                      /// OWNER
                      /// /// OWNER (PREVIEW REAL - SIN ERRORES)
                        _title(
                          "Propietario",
                        ),

                        const SizedBox(height: 14),

                        GestureDetector(
                          onTap: () {
                            showPreviewOwnerSheet(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
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
                            child: Row(
                              children: [

                              CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.grey.shade800,
                                backgroundImage: userImage.startsWith("http")
                                    ? NetworkImage(userImage)
                                    : null,
                                child: userImage.startsWith("http")
                                    ? null
                                    : const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                              ),
                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Text(
                                        userName,
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.white,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        "Toca para ver perfil",
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.blue,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Icon(
                                  Icons.keyboard_arrow_up,
                                  color: Colors.white54,
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
        decoration:
            BoxDecoration(
          shape:
              BoxShape.circle,
          color:
              const Color.fromRGBO(
            25,
            25,
            25,
            0.78,
          ),
          border:
              Border.all(
            color:
                const Color.fromRGBO(
              255,
              255,
              255,
              0.08,
            ),
          ),
        ),
        child: Icon(
          icon,
          color:
              Colors.white,
        ),
      ),
    );
  }

  static Widget _certBadge(
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 38,
      height: 38,
      decoration:
          BoxDecoration(
        color:
            color.withValues(
          alpha: 0.15,
        ),
        shape:
            BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  static Widget _infoBox(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(
        18,
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
      child: Column(
        children: [

          Icon(
            icon,
            color:
                Colors.amber,
          ),

          const SizedBox(
              height: 10),

          Text(
            title,
            style:
                const TextStyle(
              color:
                  Colors.white54,
              fontSize: 12,
            ),
          ),

          const SizedBox(
              height: 5),

          Text(
            value,
            textAlign:
                TextAlign.center,
            style:
                const TextStyle(
              color:
                  Colors.white,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _title(
    String text,
  ) {
    return Text(
      text,
      style:
          const TextStyle(
        color:
            Colors.white,
        fontSize: 21,
        fontWeight:
            FontWeight.bold,
      ),
    );
  }

  static Widget _tag(
    String text,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
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
          30,
        ),
      ),
      child: Text(
        text,
        style:
            const TextStyle(
          color:
              Colors.white70,
        ),
      ),
    );
  }

  static Widget _sectionCard(
    String text,
  ) {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
        18,
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
      child: Text(
        text,
        style:
            const TextStyle(
          color:
              Colors.white70,
          height: 1.6,
        ),
      ),
    );
  }
}