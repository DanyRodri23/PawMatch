import 'package:flutter/material.dart';
import '../../data/pet_profile_data.dart';
import '../../data/user_data.dart';
import '../../services/user_services.dart';
import '../../widgets/success_scaffold.dart';

class PetProfileSuccessScreen extends StatelessWidget {
  const PetProfileSuccessScreen({
    super.key,
  });

  Future<void> goToDashboard(BuildContext context) async {
    // "Verificado" no se activa solo: se otorga cuando se revisen los documentos.
    PetProfileData.updatePet(
      profileCompleted: true,
    );

    try {
      await UserService.saveUserProfile(
        data: UserData.profile,
      );
    } catch (e) {
      debugPrint("Error guardando perfil final: $e");
    }

    if (!context.mounted) {
      return;
    }

    // Vuelve a la pantalla raíz; ProfileGate muestra el dashboard.
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final pet = PetProfileData.pet;

    final name = (pet["name"] ?? "").toString().trim();
    final breed = (pet["breed"] ?? "").toString().trim();
    final images = pet["images"];

    String? photo;
    if (images is List && images.isNotEmpty) {
      photo = images.first.toString();
    }

    return SuccessScaffold(
      title: name.isEmpty ? "¡Perfil creado!" : "¡$name ya es parte de PawMatch!",
      subtitle:
          "Ya puedes explorar y encontrar compañeros ideales para tu mascota.",
      imageUrl: photo,
      chips: [
        if (breed.isNotEmpty) SuccessChip(Icons.pets, breed),
        SuccessChip(
          Icons.verified_outlined,
          pet["verified"] == true ? "Verificado" : "Verificación pendiente",
        ),
      ],
      buttonText: "Empezar a explorar",
      onContinue: () => goToDashboard(context),
    );
  }
}
