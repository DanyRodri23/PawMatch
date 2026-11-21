import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pet_age_screen.dart';
import '../../widgets/pet_step_scaffold.dart';
import '../../data/pet_profile_data.dart';

class PetNameScreen extends StatefulWidget {
  final bool isBreedDog;

  const PetNameScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetNameScreen> createState() => _PetNameScreenState();
}

class _PetNameScreenState extends State<PetNameScreen> {
  final TextEditingController petNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    petNameController.text = (PetProfileData.pet["name"] ?? "").toString();
  }

  @override
  void dispose() {
    petNameController.dispose();
    super.dispose();
  }

  String get name => petNameController.text.trim();

  void goNext() {
    if (name.isEmpty) return;

    PetProfileData.updatePet(name: name);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetAgeScreen(isBreedDog: widget.isBreedDog),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PetStepScaffold(
      stepKey: "name",
      showBack: false,
      emoji: "🐶",
      title: "¿Cómo se llama tu mascota?",
      subtitle: "Este será el nombre que verán otros usuarios en PawMatch.",
      onNext: name.isEmpty ? null : goNext,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: petNameController,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            maxLength: 25,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r"[A-Za-zÁÉÍÓÚÜÑáéíóúüñ0-9' \-]"),
              ),
            ],
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => goNext(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              hintText: "Ej: Max, Luna, Toby",
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
              counterText: "",
              filled: true,
              fillColor: Colors.grey.shade100,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Icon(Icons.pets, color: Colors.black87),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 48),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
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
          const SizedBox(height: 18),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            alignment: Alignment.topLeft,
            child: name.isEmpty
                ? const SizedBox(width: double.infinity)
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("🐾", style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            "¡Mucho gusto, $name!",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
