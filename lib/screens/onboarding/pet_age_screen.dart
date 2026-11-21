import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pet_gender_screen.dart';
import '../../widgets/pet_step_scaffold.dart';
import '../../data/pet_profile_data.dart';

class PetAgeScreen extends StatefulWidget {
  final bool isBreedDog;

  const PetAgeScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetAgeScreen> createState() => _PetAgeScreenState();
}

class _PetAgeScreenState extends State<PetAgeScreen> {
  int age = 1;
  String unit = "años";

  @override
  void initState() {
    super.initState();

    final saved = PetProfileData.pet["age"];
    if (saved is int && saved > 0) age = saved;

    final savedUnit = (PetProfileData.pet["ageType"] ?? "años").toString();
    unit = savedUnit == "meses" ? "meses" : "años";
  }

  int get maxAge => unit == "años" ? 30 : 36;

  String get petName {
    final n = (PetProfileData.pet["name"] ?? "").toString().trim();
    return n.isEmpty ? "tu mascota" : n;
  }

  String get message {
    if (unit == "meses" || age <= 1) return "🐶 Un cachorrito lleno de energía";
    if (age <= 5) return "🐕 En su mejor etapa";
    if (age <= 10) return "🐾 Adulto y con mucha experiencia";
    return "🦴 Un veterano lleno de amor";
  }

  void change(int delta) {
    final next = age + delta;
    if (next < 1 || next > maxAge) return;

    HapticFeedback.selectionClick();
    setState(() => age = next);
  }

  void setUnit(String value) {
    HapticFeedback.selectionClick();
    setState(() {
      unit = value;
      if (age > maxAge) age = maxAge;
    });
  }

  void goNext() {
    PetProfileData.updatePet(age: age, ageType: unit);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetGenderScreen(isBreedDog: widget.isBreedDog),
      ),
    );
  }

  Widget roundButton(IconData icon, VoidCallback onTap, bool enabled) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          color: enabled ? Colors.black : Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 30,
          color: enabled ? Colors.white : Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget unitOption(String value) {
    final selected = unit == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setUnit(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: selected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Text(
            value == "años" ? "Años" : "Meses",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = unit == "años"
        ? (age == 1 ? "año" : "años")
        : (age == 1 ? "mes" : "meses");

    return PetStepScaffold(
      stepKey: "age",
      emoji: "🎂",
      title: "¿Qué edad tiene $petName?",
      subtitle: "Usa los botones para ajustar su edad.",
      onNext: goNext,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                roundButton(Icons.remove_rounded, () => change(-1), age > 1),
                Column(
                  children: [
                    Text(
                      "$age",
                      style: const TextStyle(
                        fontSize: 76,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                        letterSpacing: -2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                roundButton(Icons.add_rounded, () => change(1), age < maxAge),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                unitOption("años"),
                unitOption("meses"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
