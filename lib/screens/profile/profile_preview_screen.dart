import 'package:flutter/material.dart';
import '../match/pet_detail_screen.dart';

/// Vista previa de tu mascota: es la misma pantalla que ven los demás.
class ProfilePreviewScreen extends StatelessWidget {
  final Map<String, dynamic> pet;

  const ProfilePreviewScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return PetDetailScreen(pet: pet, preview: true);
  }
}
