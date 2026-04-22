import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/user_profile_data.dart';
import '../../data/pet_profile_data.dart';
import '../match/gallery_viewer_screen.dart';

class PreviewOwnerSheet extends StatelessWidget {
  const PreviewOwnerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final user = UserProfileData.user;
    final pet = PetProfileData.pet;

    final List userImages =
        user["images"] ?? [];

    final List petImages =
        pet["images"] ?? [];

    final String name =
        user["name"] ?? "Usuario";

    final int age =
        user["age"] ?? 18;

    final String gender =
        user["gender"] ?? "-";

    final String city =
        user["location"] ??
            "Costa Rica";

    final String bio =
        user["bio"] ??
            "Sin descripción.";

    final String instagram =
        user["instagram"] ?? "";

    final bool verified =
        user["verified"] ??
            false;

    final String mainImage =
        userImages.isNotEmpty
            ? userImages[0]
            : "https://i.pravatar.cc/500";

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.60,
      maxChildSize: 0.98,
      builder:
          (context, controller) {
        return Container(
          decoration:
              const BoxDecoration(
            color:
                Color(0xFF050505),
            borderRadius:
                BorderRadius.vertical(
              top: Radius.circular(
                  30),
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
                    color:
                        Colors.white24,
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
                      height: 330,
                      width: double.infinity,
                      child:
                          _imageWidget(
                        mainImage,
                      ),
                    ),

                    Container(
                      height: 330,
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
                                0.92),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 22,
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
                                  "$name, $age",
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
                                    fontSize:
                                        30,
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
                                      28,
                                ),
                            ],
                          ),

                          const SizedBox(
                              height:
                                  6),

                          Text(
                            "$gender • $city",
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
                    ),
                  ],
                ),

                Padding(
                  padding:
                      const EdgeInsets.all(
                    20,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      _title(
                          "Sobre mí"),

                      const SizedBox(
                          height: 12),

                      _card(
                        bio,
                      ),

                      const SizedBox(
                          height: 24),

                      if (instagram
                          .isNotEmpty) ...[

                        _title(
                            "Instagram"),

                        const SizedBox(
                            height:
                                12),

                        _miniCard(
                          Icons
                              .camera_alt,
                          instagram,
                        ),

                        const SizedBox(
                            height:
                                24),
                      ],

                      if (userImages
                          .length >
                          1) ...[

                        _title(
                            "Fotos"),

                        const SizedBox(
                            height:
                                12),

                        SizedBox(
                          height:
                              110,
                          child:
                              ListView.builder(
                            scrollDirection:
                                Axis.horizontal,
                            itemCount:
                                userImages
                                    .length,
                            itemBuilder:
                                (_, i) {
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
                                            userImages,
                                        initialIndex:
                                            i,
                                      ),
                                    ),
                                  );
                                },
                                child:
                                    Container(
                                  width:
                                      105,
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
                                          i],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(
                            height:
                                24),
                      ],

                      _title(
                          "Mascota asociada"),

                      const SizedBox(
                          height: 12),

                      Container(
                        padding:
                            const EdgeInsets.all(
                          14,
                        ),
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
                                      color:
                                          Colors.white,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                          4),

                                  Text(
                                    "${pet["age"] ?? 0} años • ${pet["breed"] ?? "-"}",
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white60,
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
        fontSize: 24,
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
        18,
      ),
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

  static Widget _miniCard(
    IconData icon,
    String text,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(
        16,
      ),
      decoration:
          _box(),
      child: Row(
        children: [

          Icon(
            icon,
            color:
                Colors.blue,
          ),

          const SizedBox(
              width: 12),

          Text(
            text,
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

  static BoxDecoration _box() {
    return BoxDecoration(
      color:
          Colors.white10,
      borderRadius:
          BorderRadius.circular(
        22,
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
      );
    }

    return Image.file(
      File(path),
      fit:
          BoxFit.cover,
    );
  }
}

void showPreviewOwnerSheet(
  BuildContext context,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled:
        true,
    backgroundColor:
        Colors.transparent,
    builder: (_) =>
        const PreviewOwnerSheet(),
  );
}