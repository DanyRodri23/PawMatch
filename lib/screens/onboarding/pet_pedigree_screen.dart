import 'package:flutter/material.dart';
import 'pet_vaccines_screen.dart';
import '../../widgets/pet_step_scaffold.dart';
import '../../widgets/document_upload_card.dart';
import '../../data/pet_profile_data.dart';
import '../../helpers/pet_badges.dart';

class PetPedigreeScreen extends StatefulWidget {
  const PetPedigreeScreen({super.key});

  @override
  State<PetPedigreeScreen> createState() => _PetPedigreeScreenState();
}

class _PetPedigreeScreenState extends State<PetPedigreeScreen> {
  String certificate = "";

  @override
  void initState() {
    super.initState();
    certificate = (PetProfileData.pet["pedigreeCertificate"] ?? "").toString();
  }

  void goNext() {
    // Queda "en revisión": la insignia azul llega cuando PawMatch lo apruebe.
    PetBadges.setPedigreeDoc(certificate);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PetVaccinesScreen(isBreedDog: true),
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
      stepKey: "pedigree",
      emoji: "🏅",
      title: "Certificado de pedigrí",
      subtitle: "Sube una foto del certificado para verificar que es de raza.",
      buttonText: certificate.isEmpty ? "Subir después" : "Continuar",
      onNext: goNext,
      child: Column(
        children: [
          DocumentUploadCard(
            icon: Icons.workspace_premium_rounded,
            title: "Subir certificado",
            hint: "Toma una foto o elígela de tu galería",
            initialValue: certificate,
            onUploaded: (url) => setState(() => certificate = url),
            onRemoved: () => setState(() => certificate = ""),
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
                  "Cuando lo revisemos, tu mascota mostrará un check azul de pedigrí.",
                ),
                infoRow(
                  Icons.schedule_rounded,
                  "Si no lo tienes a la mano, puedes subirlo después desde su perfil.",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
