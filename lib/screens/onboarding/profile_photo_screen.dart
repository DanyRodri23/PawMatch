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

  final List<Uint8List?> previews =
      List.generate(4, (_) => null);

  final List<String?> imageUrls =
      List.generate(4, (_) => null);

  final List<bool> loading =
      List.generate(4, (_) => false);

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
      previews[index] = bytes;
      loading[index] = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    if (!mounted) return;

    setState(() {
      imageUrls[index] =
          pickedFile.path;
      loading[index] = false;
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
                title: const Text(
                  "Tomar foto",
                ),
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
        imageUrls
            .where(
              (img) => img != null,
            )
            .cast<String>()
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
      images: validImages,
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
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius:
              BorderRadius.circular(
            20,
          ),
          border: Border.all(
            color:
                Colors.grey.shade300,
          ),
        ),
        child: Stack(
          children: [

            Positioned.fill(
              child: previews[index] != null
                  ? ClipRRect(
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                      child: Image.memory(
                        previews[index]!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
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
                          style:
                              const TextStyle(
                            color:
                                Colors.black54,
                          ),
                        ),
                      ],
                    ),
            ),

            if (loading[index])
              Positioned.fill(
                child: Container(
                  decoration:
                      BoxDecoration(
                    color: Colors.black
                        .withValues(
                      alpha: 0.45,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: const Center(
                    child:
                        CircularProgressIndicator(
                      color:
                          Colors.white,
                    ),
                  ),
                ),
              ),

            if (imageUrls[index] != null &&
                !loading[index])
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.all(
                    4,
                  ),
                  decoration:
                      const BoxDecoration(
                    color:
                        Colors.green,
                    shape:
                        BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 14,
                    color:
                        Colors.white,
                  ),
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
                      CrossAxisAlignment.start,
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
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.88,
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
                            ElevatedButton.styleFrom(
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