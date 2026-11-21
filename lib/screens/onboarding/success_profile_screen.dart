import 'package:flutter/material.dart';
import 'pet_intro_screen.dart';
import '../../services/user_services.dart';
import '../../data/user_data.dart';
import '../../widgets/success_scaffold.dart';

class SuccessProfileScreen extends StatelessWidget {
  const SuccessProfileScreen({
    super.key,
  });

  Future<void> saveAndContinue(BuildContext context) async {
    try {
      await UserService.saveUserProfile(
        data: UserData.profile,
      );
    } catch (e) {
      debugPrint("Error guardando usuario: $e");
    }

    if (!context.mounted) {
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PetIntroScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = UserData.profile;

    final name = (profile["name"] ?? "").toString().trim();
    final location = (profile["location"] ?? "").toString().trim();
    final images = profile["images"];
    final age = profile["age"];

    String? photo;
    if (images is List && images.isNotEmpty) {
      photo = images.first.toString();
    }

    return SuccessScaffold(
      title: name.isEmpty ? "¡Perfil creado!" : "¡Listo, $name!",
      subtitle:
          "Tu perfil está creado.\nAhora presentemos a tu mascota, la verdadera estrella.",
      imageUrl: photo,
      chips: [
        if (age != null) SuccessChip(Icons.cake_outlined, "$age años"),
        if (location.isNotEmpty)
          SuccessChip(Icons.location_on_outlined, location),
      ],
      buttonText: "Agregar a mi mascota",
      onContinue: () => saveAndContinue(context),
    );
  }
}
