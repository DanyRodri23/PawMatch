import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/user_profile_data.dart';
import '../../data/pet_profile_data.dart';
import '../match/gallery_viewer_screen.dart';

class OwnerProfileSheet extends StatelessWidget {
  const OwnerProfileSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserProfileData.user;
    final pet = PetProfileData.pet;

    final List<String> userImages =
        List<String>.from(
      user["images"] ?? [],
    );

    final List<String> petImages =
        List<String>.from(
      pet["images"] ?? [],
    );

    final String mainImage =
        userImages.isNotEmpty
            ? userImages[0]
            : "https://i.pravatar.cc/600";

    final String name =
        user["name"] ?? "Usuario";

    final int age =
        user["age"] ?? 18;

    final String gender =
        user["gender"] ?? "-";

    final String city =
        user["location"] ?? "";

    final String bio =
        user["bio"] ??
            "Sin descripción.";

    final String instagram =
        user["instagram"] ??
            "@usuario";

    final bool verified =
        user["verified"] ??
            false;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.65,
      maxChildSize: 0.98,
      builder: (
        context,
        controller,
      ) {
        return Container(
          decoration:
              const BoxDecoration(
            color:
                Color(0xFF050505),
            borderRadius:
                BorderRadius.vertical(
              top:
                  Radius.circular(
                30,
              ),
            ),
          ),
          child:
              SingleChildScrollView(
            controller:
                controller,
            child: Column(
              children: [

                const SizedBox(
                    height: 12),

                Container(
                  width: 55,
                  height: 5,
                  decoration:
                      BoxDecoration(
                    color: Colors
                        .white24,
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                ),

                const SizedBox(
                    height: 18),

                /// HERO
                Stack(
                  children: [

                    SizedBox(
                      height: 340,
                      width:
                          double.infinity,
                      child:
                          _imageWidget(
                        mainImage,
                      ),
                    ),

                    Container(
                      height: 340,
                      decoration:
                          const BoxDecoration(
                        gradient:
                            LinearGradient(
                          begin:
                              Alignment
                                  .topCenter,
                          end:
                              Alignment
                                  .bottomCenter,
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
                                0.92),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      left: 22,
                      right: 22,
                      bottom: 24,
                      child:
                          Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [

                          Row(
                            children: [

                              Expanded(
                                child:
                                    Text(
                                  "$name, $age",
                                  style:
                                      const TextStyle(
                                    color: Colors
                                        .white,
                                    fontSize:
                                        34,
                                    fontWeight:
                                        FontWeight.w900,
                                  ),
                                ),
                              ),

                              if (verified)
                                const Icon(
                                  Icons
                                      .verified,
                                  color:
                                      Colors.blue,
                                  size:
                                      30,
                                ),
                            ],
                          ),

                          const SizedBox(
                              height:
                                  8),

                          Text(
                            "$gender • $city",
                            style:
                                const TextStyle(
                              color: Colors
                                  .white70,
                              fontSize:
                                  16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding:
                      const EdgeInsets
                          .all(20),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [

                      /// BIO
                      _title(
                          "Sobre mí"),

                      const SizedBox(
                          height: 12),

                      _card(
                        bio,
                      ),

                      const SizedBox(
                          height: 26),

                      /// INSTAGRAM
                      _title(
                          "Instagram"),

                      const SizedBox(
                          height: 12),

                      Container(
                        padding:
                            const EdgeInsets.all(
                                18),
                        decoration:
                            _box(),
                        child: Row(
                          children: [

                            const Icon(
                              Icons
                                  .camera_alt,
                              color: Colors
                                  .blue,
                            ),

                            const SizedBox(
                                width:
                                    12),

                            Text(
                              instagram,
                              style:
                                  const TextStyle(
                                color: Colors
                                    .white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          height: 26),

                      /// FOTOS
                      _title("Fotos"),

                      const SizedBox(
                          height: 12),

                      SizedBox(
                        height: 120,
                        child:
                            ListView.builder(
                          scrollDirection:
                              Axis.horizontal,
                          itemCount:
                              userImages
                                  .length,
                          itemBuilder:
                              (_, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            GalleryViewerScreen(
                                      images:
                                          userImages,
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
                                      _imageWidget(
                                    userImages[
                                        index],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(
                          height: 26),

                      /// MASCOTA
                      _title(
                          "Mascota asociada"),

                      const SizedBox(
                          height: 12),

                      Container(
                        padding:
                            const EdgeInsets.all(
                                16),
                        decoration:
                            _box(),
                        child: Row(
                          children: [

                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(
                                      16),
                              child:
                                  SizedBox(
                                width:
                                    62,
                                height:
                                    62,
                                child: petImages
                                        .isNotEmpty
                                    ? _imageWidget(
                                        petImages[
                                            0],
                                      )
                                    : Container(
                                        color:
                                            Colors.white10,
                                      ),
                              ),
                            ),

                            const SizedBox(
                                width:
                                    14),

                            Expanded(
                              child:
                                  Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    pet["name"] ??
                                        "Mascota",
                                    style:
                                        const TextStyle(
                                      color: Colors
                                          .white,
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize:
                                          16,
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                          4),

                                  Text(
                                    "${pet["age"] ?? 0} años • ${pet["breed"] ?? "-"}",
                                    style:
                                        const TextStyle(
                                      color: Colors
                                          .white60,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                          height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
        fontSize: 28,
        fontWeight:
            FontWeight.w900,
      ),
    );
  }

  static Widget _card(
    String text,
  ) {
    return Container(
      width:
          double.infinity,
      padding:
          const EdgeInsets.all(
              18),
      decoration:
          _box(),
      child: Text(
        text,
        style:
            const TextStyle(
          color:
              Colors.white70,
          height: 1.5,
        ),
      ),
    );
  }

  static BoxDecoration _box() {
    return BoxDecoration(
      color:
          Colors.white10,
      borderRadius:
          BorderRadius.circular(
        24,
      ),
    );
  }

  static Widget _imageWidget(
    String path,
  ) {
    if (path.startsWith(
        "http")) {
      return Image.network(
        path,
        fit:
            BoxFit.cover,
        errorBuilder:
            (_, __, ___) {
          return Container(
            color:
                Colors.white10,
            child:
                const Icon(
              Icons.person,
              color:
                  Colors.white30,
              size: 50,
            ),
          );
        },
      );
    }

    if (path.startsWith("http")) {
  return Image.network(
    path,
    fit: BoxFit.cover,
  );
}

    return Container(
      color: Colors.white10,
      child: const Icon(
        Icons.person,
        color: Colors.white30,
        size: 50,
      ),
    );
  }
}

void showOwnerProfileSheet(
  BuildContext context,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled:
        true,
    backgroundColor:
        Colors.transparent,
    builder: (_) =>
        const OwnerProfileSheet(),
  );
}