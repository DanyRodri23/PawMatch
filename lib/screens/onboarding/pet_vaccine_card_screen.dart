import 'package:flutter/material.dart';
import 'pet_photos_screen.dart';
import '../../widgets/pet_step_scaffold.dart';
import '../../widgets/document_upload_card.dart';
import '../../data/pet_profile_data.dart';
import '../../helpers/pet_badges.dart';

class PetVaccineCardScreen extends StatefulWidget {
  final bool isBreedDog;

  const PetVaccineCardScreen({
    super.key,
    required this.isBreedDog,
  });

  @override
  State<PetVaccineCardScreen> createState() => _PetVaccineCardScreenState();
}

class _PetVaccineCardScreenState extends State<PetVaccineCardScreen> {
  String card = "";

  @override
  void initState() {
    super.initState();
    card = (PetProfileData.pet["vaccineCard"] ?? "").toString();
  }

  void goNext() {
    PetBadges.setVaccineDoc(card);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetPhotosScreen(isBreedDog: widget.isBreedDog),
      ),
    );
  }

  Widget infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.black87),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PetStepScaffold(
      stepKey: "vaccineCard",
      emoji: "📋",
      title: "Carnet de vacunas",
      subtitle: "Sube una foto del carnet para verificar su salud.",
      buttonText: card.isEmpty ? "Subir después" : "Continuar",
      onNext: goNext,
      child: Column(
        children: [
          DocumentUploadCard(
            icon: Icons.vaccines_rounded,
            title: "Subir carnet",
            hint: "Asegúrate de que se lean las fechas",
            initialValue: card,
            onUploaded: (url) => setState(() => card = url),
            onRemoved: () => setState(() => card = ""),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                infoRow(
                  Icons.lock_outline,
                  "Solo PawMatch ve el documento. Nunca se comparte con otros usuarios.",
                ),
                infoRow(
                  Icons.verified_outlined,
                  "Al aprobarlo, tu mascota mostrará la insignia de vacunada.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
