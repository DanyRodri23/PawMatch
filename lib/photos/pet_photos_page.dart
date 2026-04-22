import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/pet_profile_data.dart';

class PetPhotosPage extends StatefulWidget {
  const PetPhotosPage({super.key});

  @override
  State<PetPhotosPage> createState() =>
      _PetPhotosPageState();
}

class _PetPhotosPageState
    extends State<PetPhotosPage> {

  final picker = ImagePicker();

  late List<String> images;

  @override
  void initState() {
    super.initState();

    images = List<String>.from(
      PetProfileData.pet["images"] ?? [],
    );
  }

  Future<void> addPhoto() async {
    if (images.length >= 8) return;

    final XFile? file =
        await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (file == null) return;

    setState(() {
      images.add(file.path);
    });
  }

  void removePhoto(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  void setMainPhoto(int index) {
    final selected = images[index];

    setState(() {
      images.removeAt(index);
      images.insert(0, selected);
    });
  }

  void savePhotos() {
    PetProfileData.pet["images"] =
        images;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Fotos guardadas 🔥",
        ),
      ),
    );

    Navigator.pop(context);
  }

  Widget imageBox(
    String path,
    int index,
  ) {
    return Stack(
      children: [

        ClipRRect(
          borderRadius:
              BorderRadius.circular(
            22,
          ),
          child: Image.file(
            File(path),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        if (index == 0)
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration:
                  BoxDecoration(
                color: Colors.blue,
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),
              child: const Text(
                "Principal",
                style: TextStyle(
                  color:
                      Colors.white,
                  fontSize: 12,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),

        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () =>
                removePhoto(index),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor:
                  Colors.black54,
              child: Icon(
                Icons.close,
                color:
                    Colors.white,
                size: 18,
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: () =>
                setMainPhoto(index),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor:
                  Colors.black54,
              child: Icon(
                Icons.star,
                color:
                    Colors.amber,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget addBox() {
    return GestureDetector(
      onTap: addPhoto,
      child: Container(
        decoration:
            BoxDecoration(
          color: Colors.white10,
          borderRadius:
              BorderRadius.circular(
            22,
          ),
          border: Border.all(
            color:
                Colors.white24,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 42,
          ),
        ),
      ),
    );
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
          "Fotos Mascota",
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
                    images.length < 8
                        ? images.length +
                            1
                        : 8,
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
                          8) {
                    return addBox();
                  }

                  return imageBox(
                    images[index],
                    index,
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
                    color:
                        Colors.white,
                    fontSize:
                        16,
                    fontWeight:
                        FontWeight.bold,
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