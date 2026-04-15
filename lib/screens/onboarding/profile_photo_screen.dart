import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'location_permission_screen.dart';
import '../../widgets/user_progress_bar.dart';
import '../../data/user_data.dart';

class ProfilePhotoScreen extends StatefulWidget {
  const ProfilePhotoScreen({super.key});

  @override
  State<ProfilePhotoScreen> createState() =>
      _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState
    extends State<ProfilePhotoScreen> {

  List<Uint8List?> images =
      List.generate(4, (_) => null);

  int selectedIndex = 0;

  Future<void> pickImage(
    ImageSource source,
    int index,
  ) async {
    final pickedFile =
        await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );

    if (pickedFile == null) return;

    final bytes =
        await pickedFile.readAsBytes();

    setState(() {
      images[index] = bytes;
    });
  }

  void showPicker(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_camera,
                ),
                title:
                    const Text("Tomar foto"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(
                    ImageSource.camera,
                    index,
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                ),
                title: const Text(
                  "Elegir de galería",
                ),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(
                    ImageSource.gallery,
                    index,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void goNext() {
    final validImages =
        images
            .where(
              (img) => img != null,
            )
            .cast<Uint8List>()
            .toList();

    if (validImages.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Debes agregar al menos una foto",
          ),
        ),
      );

      return;
    }

    UserData.updateProfile(
      images: <dynamic>[
        ...validImages,
      ],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const LocationPermissionScreen(),
      ),
    );
  }

  Widget buildPhotoSlot(int index) {
    return GestureDetector(
      onTap: () => showPicker(index),
      child: Container(
        width: 150,
        height: 170,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius:
              BorderRadius.circular(
            20,
          ),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: images[index] != null
            ? ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
                child: Image.memory(
                  images[index]!,
                  fit: BoxFit.cover,
                ),
              )
            : Column(
                mainAxisAlignment:
                    MainAxisAlignment
                        .center,
                children: [
                  const Icon(
                    Icons.add_a_photo,
                    size: 34,
                    color:
                        Colors.black54,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Foto ${index + 1}",
                    style: const TextStyle(
                      color:
                          Colors.black54,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const UserProgressBar(
              step: 4,
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
                      height: 40,
                    ),
                    const Text(
                      "Agrega tus fotos",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Puedes agregar hasta 4 fotos para mostrar mejor tu perfil.",
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            Colors.black54,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: GridView.builder(
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              2,
                          mainAxisSpacing:
                              14,
                          crossAxisSpacing:
                              14,
                          childAspectRatio:
                              0.88,
                        ),
                        itemBuilder:
                            (
                              context,
                              index,
                            ) {
                          return buildPhotoSlot(
                            index,
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width:
                          double.infinity,
                      height: 55,
                      child:
                          ElevatedButton(
                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              Colors.black,
                          foregroundColor:
                              Colors.white,
                        ),
                        onPressed:
                            goNext,
                        child:
                            const Text(
                          "Continuar",
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
          ],
        ),
      ),
    );
  }
}