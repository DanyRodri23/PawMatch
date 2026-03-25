import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'location_permission_screen.dart';
import '../../widgets/user_progress_bar.dart';

class ProfilePhotoScreen extends StatefulWidget {
  const ProfilePhotoScreen({super.key});

  @override
  State<ProfilePhotoScreen> createState() => _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends State<ProfilePhotoScreen> {

  Uint8List? imageBytes;

  Future<void> pickImage(ImageSource source) async {

    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile == null) return;

    final bytes = await pickedFile.readAsBytes();

    setState(() {
      imageBytes = bytes;
    });
  }

  void showPicker() {

    showModalBottomSheet(
      context: context,
      builder: (context) {

        return SafeArea(
          child: Wrap(
            children: [

              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text("Tomar foto"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Elegir de galería"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),

            ],
          ),
        );
      },
    );
  }

  void goNext() {

    if (imageBytes == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debes agregar una foto"),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPermissionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            /// BARRA DE PROGRESO
            const UserProgressBar(step: 4),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(28),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 40),

                    const Text(
                      "Agrega tu foto",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Esta foto será visible para otros usuarios.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// FOTO
                    Center(
                      child: GestureDetector(
                        onTap: showPicker,

                        child: Container(
                          width: 160,
                          height: 160,

                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: imageBytes != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.memory(
                                    imageBytes!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.add_a_photo,
                                  size: 50,
                                  color: Colors.black54,
                                ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    /// BOTON CONTINUAR
                    SizedBox(
                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        onPressed: goNext,

                        child: const Text(
                          "Continuar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ),
                    ),

                    const SizedBox(height: 20),

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