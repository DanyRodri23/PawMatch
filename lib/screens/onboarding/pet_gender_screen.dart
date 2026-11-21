import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pet_breed_type_screen.dart';
import '../../widgets/pet_step_scaffold.dart';
import '../../data/pet_profile_data.dart';

class PetGenderScreen extends StatefulWidget {
  final bool isBreedDog;

  const PetGenderScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetGenderScreen> createState() => _PetGenderScreenState();
}

class _PetGenderScreenState extends State<PetGenderScreen> {
  /// Siempre "Macho" o "Hembra" (igual que en el perfil y los filtros).
  String? selected;

  @override
  void initState() {
    super.initState();

    final saved = (PetProfileData.pet["gender"] ?? "").toString().toLowerCase();
    if (saved == "macho") selected = "Macho";
    if (saved == "hembra") selected = "Hembra";
  }

  String get petName {
    final n = (PetProfileData.pet["name"] ?? "").toString().trim();
    return n.isEmpty ? "tu mascota" : n;
  }

  void goNext() {
    if (selected == null) return;

    PetProfileData.updatePet(gender: selected);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetBreedTypeScreen(isBreedDog: widget.isBreedDog),
      ),
    );
  }

  Widget genderCard(String value, IconData icon, String text, Color tint) {
    final isSelected = selected == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => selected = value);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey.shade300,
              width: 1.5,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.22),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.14)
                      : tint.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 44,
                  color: isSelected ? Colors.white : tint,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                size: 22,
                color: isSelected ? Colors.white : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PetStepScaffold(
      stepKey: "gender",
      emoji: "🐕",
      title: "¿$petName es macho o hembra?",
      subtitle: "Así encontramos compañeros ideales para él o ella.",
      onNext: selected == null ? null : goNext,
      child: Row(
        children: [
          genderCard("Macho", Icons.male_rounded, "Macho", Colors.blue),
          const SizedBox(width: 14),
          genderCard("Hembra", Icons.female_rounded, "Hembra", Colors.pink),
        ],
      ),
    );
  }
}
