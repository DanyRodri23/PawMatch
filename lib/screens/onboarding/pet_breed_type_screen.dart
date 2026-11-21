import 'package:flutter/material.dart';
import 'pet_vaccines_screen.dart';
import 'pet_breed_select_screen.dart';
import '../../widgets/pet_step_scaffold.dart';
import '../../data/pet_profile_data.dart';

class PetBreedTypeScreen extends StatefulWidget {
  final bool isBreedDog;

  const PetBreedTypeScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetBreedTypeScreen> createState() => _PetBreedTypeScreenState();
}

class _PetBreedTypeScreenState extends State<PetBreedTypeScreen> {
  String? selected;

  @override
  void initState() {
    super.initState();

    final isPureBreed = PetProfileData.pet["isPureBreed"];
    if (isPureBreed != null) {
      selected = isPureBreed == true ? "raza" : "mestizo";
    }
  }

  String get petName {
    final n = (PetProfileData.pet["name"] ?? "").toString().trim();
    return n.isEmpty ? "tu mascota" : n;
  }

  void goNext() {
    if (selected == null) return;

    final isPureBreed = selected == "raza";

    PetProfileData.updatePet(isPureBreed: isPureBreed);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => isPureBreed
            ? const PetBreedSelectScreen()
            : const PetVaccinesScreen(isBreedDog: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PetStepScaffold(
      stepKey: "breedType",
      emoji: "🦴",
      title: "¿$petName es de raza?",
      subtitle: "Elige la opción que mejor lo describe.",
      onNext: selected == null ? null : goNext,
      child: Column(
        children: [
          PetOptionCard(
            emoji: "🐕",
            title: "Perro de raza",
            subtitle: "Raza definida con características únicas",
            selected: selected == "raza",
            onTap: () => setState(() => selected = "raza"),
          ),
          PetOptionCard(
            emoji: "🐶",
            title: "Mestizo / Zaguate",
            subtitle: "Único, especial y lleno de personalidad",
            selected: selected == "mestizo",
            onTap: () => setState(() => selected = "mestizo"),
          ),
        ],
      ),
    );
  }
}
