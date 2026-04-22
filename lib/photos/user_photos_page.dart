import 'package:flutter/material.dart';
import '../../../data/user_profile_data.dart';

class UserPhotosPage extends StatefulWidget {
  const UserPhotosPage({super.key});

  @override
  State<UserPhotosPage> createState() =>
      _UserPhotosPageState();
}

class _UserPhotosPageState
    extends State<UserPhotosPage> {

  late List images;

  @override
  void initState() {
    super.initState();

    images =
        List.from(
      UserProfileData.user[
              "images"] ??
          [],
    );
  }

  void addPhoto() {
    if (images.length >= 4) return;

    setState(() {
      images.add(
        "https://picsum.photos/500?random=${images.length + 1}",
      );
    });
  }

  void removePhoto(
    int index,
  ) {
    setState(() {
      images.removeAt(index);
    });
  }

  void setMainPhoto(
    int index,
  ) {
    final selected =
        images[index];

    setState(() {
      images.removeAt(index);
      images.insert(0, selected);
    });
  }

  void savePhotos() {
    UserProfileData.updateUser(
      images:
          List<String>.from(
        images,
      ),
    );

    ScaffoldMessenger.of(
            context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Fotos actualizadas 🔥",
        ),
      ),
    );

    Navigator.pop(
        context);
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(
      backgroundColor:
          const Color(
        0xFF050505,
      ),

      appBar: AppBar(
        backgroundColor:
            Colors.transparent,
        elevation: 0,
        title:
            const Text(
          "Fotos del propietario",
          style:
              TextStyle(
            color:
                Colors.white,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(
          18,
        ),
        child: Column(
          children: [

            const Align(
              alignment:
                  Alignment.centerLeft,
              child: Text(
                "La primera foto será la principal.",
                style:
                    TextStyle(
                  color:
                      Colors.white54,
                ),
              ),
            ),

            const SizedBox(
                height: 20),

            Expanded(
              child:
                  GridView.builder(
                itemCount:
                    images.length < 4
                        ? images.length +
                            1
                        : 4,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      2,
                  crossAxisSpacing:
                      14,
                  mainAxisSpacing:
                      14,
                  childAspectRatio:
                      0.82,
                ),
                itemBuilder:
                    (_, index) {

                  if (index ==
                          images.length &&
                      images.length <
                          4) {
                    return GestureDetector(
                      onTap:
                          addPhoto,
                      child:
                          Container(
                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white10,
                          borderRadius:
                              BorderRadius.circular(
                            24,
                          ),
                          border:
                              Border.all(
                            color:
                                Colors.white24,
                          ),
                        ),
                        child:
                            const Center(
                          child:
                              Icon(
                            Icons.add,
                            color:
                                Colors.white,
                            size:
                                40,
                          ),
                        ),
                      ),
                    );
                  }

                  final image =
                      images[index];

                  return Stack(
                    children: [

                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(
                          24,
                        ),
                        child:
                            Image.network(
                          image,
                          width: double
                              .infinity,
                          height: double
                              .infinity,
                          fit: BoxFit
                              .cover,
                        ),
                      ),

                      if (index == 0)
                        Positioned(
                          top: 10,
                          left: 10,
                          child:
                              Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal:
                                  10,
                              vertical:
                                  5,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  Colors.blue,
                              borderRadius:
                                  BorderRadius.circular(
                                20,
                              ),
                            ),
                            child:
                                const Text(
                              "Principal",
                              style:
                                  TextStyle(
                                color:
                                    Colors.white,
                                fontSize:
                                    12,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      Positioned(
                        top: 10,
                        right: 10,
                        child:
                            GestureDetector(
                          onTap: () =>
                              removePhoto(
                            index,
                          ),
                          child:
                              Container(
                            width:
                                34,
                            height:
                                34,
                            decoration:
                                const BoxDecoration(
                              color:
                                  Colors.black54,
                              shape:
                                  BoxShape.circle,
                            ),
                            child:
                                const Icon(
                              Icons.close,
                              color:
                                  Colors.white,
                              size:
                                  18,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 10,
                        right: 10,
                        child:
                            GestureDetector(
                          onTap: () =>
                              setMainPhoto(
                            index,
                          ),
                          child:
                              Container(
                            padding:
                                const EdgeInsets.all(
                              8,
                            ),
                            decoration:
                                const BoxDecoration(
                              color:
                                  Colors.black54,
                              shape:
                                  BoxShape.circle,
                            ),
                            child:
                                const Icon(
                              Icons.star,
                              color:
                                  Colors.amber,
                              size:
                                  18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(
                height: 14),

            SizedBox(
              width:
                  double.infinity,
              height: 56,
              child:
                  ElevatedButton(
                onPressed:
                    savePhotos,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                ),
                child:
                    const Text(
                  "Guardar fotos",
                  style:
                      TextStyle(
                    fontSize:
                        16,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Colors.white,
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