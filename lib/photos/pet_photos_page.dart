import 'package:flutter/material.dart';
import '../data/pet_profile_data.dart';
import 'photos_manager_page.dart';

class PetPhotosPage extends StatelessWidget {
  const PetPhotosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final saved = PetProfileData.pet["images"];

    return PhotosManagerPage(
      title: "Fotos de tu mascota",
      hint: "Mínimo 4 fotos. La primera es la principal.",
      minimum: 4,
      initial: saved is List ? saved.map((e) => e.toString()).toList() : [],
      onSave: (urls) => PetProfileData.updatePet(images: urls),
    );
  }
}
