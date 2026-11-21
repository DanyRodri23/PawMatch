import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pet_profile_success_screen.dart';
import '../../widgets/pet_step_scaffold.dart';
import '../../data/pet_profile_data.dart';

class PetGoalScreen extends StatefulWidget {
  final bool isBreedDog;

  const PetGoalScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetGoalScreen> createState() => _PetGoalScreenState();
}

class _PetGoalScreenState extends State<PetGoalScreen> {
  String? selectedGoal;

  final List<Map<String, String>> goals = [
    {"emoji": "🐶", "text": "Compañero de juego"},
    {"emoji": "🐾", "text": "Socializar mascotas"},
    {"emoji": "🚶", "text": "Compañero de paseo"},
    {"emoji": "❤️", "text": "Reproducción"},
    {"emoji": "🌳", "text": "Actividades"},
    {"emoji": "🐕", "text": "Nuevos amigos"},
  ];

  @override
  void initState() {
    super.initState();
    selectedGoal = PetProfileData.pet["lookingFor"];
  }

  String get petName {
    final n = (PetProfileData.pet["name"] ?? "").toString().trim();
    return n.isEmpty ? "tu mascota" : n;
  }

  void goNext() {
    if (selectedGoal == null) return;

    PetProfileData.updatePet(lookingFor: selectedGoal);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PetProfileSuccessScreen(),
      ),
    );
  }

  Widget goalCard(Map<String, String> goal) {
    final text = goal["text"]!;
    final selected = selectedGoal == text;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => selectedGoal = text);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? Colors.black : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            if (selected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(goal["emoji"]!, style: const TextStyle(fontSize: 34)),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(
              height: 22,
              child: selected
                  ? const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 16,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PetStepScaffold(
      stepKey: "goal",
      emoji: "💞",
      title: "¿Qué busca $petName?",
      subtitle: "Elige lo que más se parezca a lo que quieres encontrar.",
      buttonText: "Finalizar",
      onNext: selectedGoal == null ? null : goNext,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.15,
        children: [for (final g in goals) goalCard(g)],
      ),
    );
  }
}
