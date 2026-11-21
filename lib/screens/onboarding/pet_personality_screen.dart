import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pet_goal_screen.dart';
import '../../widgets/pet_step_scaffold.dart';
import '../../data/pet_profile_data.dart';

class PetPersonalityScreen extends StatefulWidget {
  final bool isBreedDog;

  const PetPersonalityScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetPersonalityScreen> createState() => _PetPersonalityScreenState();
}

class _PetPersonalityScreenState extends State<PetPersonalityScreen> {
  final List<String> selectedTraits = [];
  final TextEditingController descriptionController = TextEditingController();

  final List<String> traits = [
    "Juguetón", "Cariñoso", "Activo", "Protector", "Tranquilo", "Sociable",
    "Curioso", "Energético", "Amigable", "Dormilón", "Inteligente", "Travieso",
    "Valiente", "Leal", "Aventurero", "Obediente", "Independiente",
    "Territorial", "Paciente", "Alerta", "Tímido", "Divertido", "Explorador",
    "Amoroso", "Atlético", "Relajado", "Extrovertido", "Dominante", "Sumiso",
    "Cuidadoso", "Fiel", "Ruidoso", "Silencioso", "Cazador", "Muy sociable",
    "Protector con la familia", "Curioso con todo", "Amante de la comida",
    "Buen guardián", "Amigable con niños", "Perezoso", "Dependiente",
    "Sensible", "Seguro", "Intrépido",
  ];

  @override
  void initState() {
    super.initState();

    selectedTraits.addAll(List<String>.from(PetProfileData.pet["traits"] ?? []));
    descriptionController.text =
        (PetProfileData.pet["description"] ?? "").toString();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  String get petName {
    final n = (PetProfileData.pet["name"] ?? "").toString().trim();
    return n.isEmpty ? "tu mascota" : n;
  }

  List<String> detectTraitsFromText(String text) {
    final lower = text.toLowerCase();
    final detected = <String>[];

    if (lower.contains("juguet")) detected.add("Juguetón");
    if (lower.contains("tranquilo")) detected.add("Tranquilo");
    if (lower.contains("activo")) detected.add("Activo");
    if (lower.contains("protector")) detected.add("Protector");
    if (lower.contains("amor")) detected.add("Amoroso");
    if (lower.contains("inteligente")) detected.add("Inteligente");

    return detected;
  }

  bool get canContinue =>
      selectedTraits.isNotEmpty || descriptionController.text.trim().isNotEmpty;

  void goNext() {
    final detected = detectTraitsFromText(descriptionController.text);

    final finalTraits = {...selectedTraits, ...detected}.toList();

    if (finalTraits.isEmpty) return;

    PetProfileData.updatePet(
      traits: finalTraits,
      description: descriptionController.text.trim(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetGoalScreen(isBreedDog: widget.isBreedDog),
      ),
    );
  }

  void toggleTrait(String trait) {
    HapticFeedback.selectionClick();

    setState(() {
      if (selectedTraits.contains(trait)) {
        selectedTraits.remove(trait);
      } else {
        selectedTraits.add(trait);
      }
    });
  }

  Widget buildChip(String trait) {
    final selected = selectedTraits.contains(trait);

    return GestureDetector(
      onTap: () => toggleTrait(trait),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? Colors.black : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(Icons.check, size: 15, color: Colors.white),
              ),
            Text(
              trait,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PetStepScaffold(
      stepKey: "personality",
      emoji: "✨",
      title: "¿Cómo es $petName?",
      subtitle: "Elige las palabras que mejor lo describen.",
      onNext: canContinue ? goNext : null,
      footer: Text(
        selectedTraits.isEmpty
            ? "Elige varias o escribe una descripción"
            : "${selectedTraits.length} seleccionadas",
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [for (final t in traits) buildChip(t)],
          ),
          const SizedBox(height: 28),
          const Text(
            "Cuéntanos más (opcional)",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: descriptionController,
            maxLines: 4,
            maxLength: 200,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: "Ej: Le encanta correr en el parque y jugar con la pelota...",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
