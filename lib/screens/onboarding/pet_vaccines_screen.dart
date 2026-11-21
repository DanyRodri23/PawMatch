import 'package:flutter/material.dart';
import 'pet_photos_screen.dart';
import 'pet_vaccine_card_screen.dart';
import '../../widgets/pet_step_scaffold.dart';
import '../../data/pet_profile_data.dart';

class PetVaccinesScreen extends StatefulWidget {
  final bool isBreedDog;

  const PetVaccinesScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetVaccinesScreen> createState() => _PetVaccinesScreenState();
}

class _PetVaccinesScreenState extends State<PetVaccinesScreen> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();

    final vaccinated = PetProfileData.pet["vaccinated"];
    if (vaccinated == true) {
      selectedOption = "si";
    }
  }

  String get petName {
    final n = (PetProfileData.pet["name"] ?? "").toString().trim();
    return n.isEmpty ? "tu mascota" : n;
  }

  void goNext() {
    if (selectedOption == null) return;

    final vaccinated = selectedOption == "si";

    PetProfileData.updatePet(vaccinated: vaccinated);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => vaccinated
            ? PetVaccineCardScreen(isBreedDog: widget.isBreedDog)
            : PetPhotosScreen(
                isBreedDog: widget.isBreedDog,
                fromVaccineCard: false,
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PetStepScaffold(
      stepKey: "vaccines",
      emoji: "💉",
      title: "¿Tiene vacunas $petName?",
      subtitle: "Las mascotas con vacunas generan más confianza.",
      onNext: selectedOption == null ? null : goNext,
      child: Column(
        children: [
          PetOptionCard(
            icon: Icons.verified_rounded,
            title: "Sí tiene vacunas",
            subtitle: "Cuenta con control veterinario",
            selected: selectedOption == "si",
            onTap: () => setState(() => selectedOption = "si"),
          ),
          PetOptionCard(
            icon: Icons.schedule_rounded,
            title: "Aún no tiene vacunas",
            subtitle: "Se puede completar después",
            selected: selectedOption == "no",
            onTap: () => setState(() => selectedOption = "no"),
          ),
        ],
      ),
    );
  }
}
