import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../data/pet_profile_data.dart';
import '../../helpers/pet_badges.dart';
import '../../widgets/document_upload_card.dart';

/// Aquí el dueño sube (o cambia) el carnet de vacunas y el pedigrí.
class CertificatesScreen extends StatefulWidget {
  const CertificatesScreen({super.key});

  @override
  State<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends State<CertificatesScreen> {
  Map get pet => PetProfileData.pet;

  Widget statusChip(String status) {
    late final Color color;
    late final String text;
    late final IconData icon;

    switch (status) {
      case "approved":
        color = const Color(0xFF29B6F6);
        text = "Verificado";
        icon = Icons.verified_rounded;
        break;
      case "pending":
        color = Colors.amber;
        text = "En revisión";
        icon = Icons.hourglass_top_rounded;
        break;
      default:
        color = Colors.white38;
        text = "Sin subir";
        icon = Icons.upload_file_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget section({
    required IconData badgeIcon,
    required Color badgeColor,
    required String title,
    required String description,
    required String status,
    required Widget upload,
    required VoidCallback approveForTesting,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF16161C),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(badgeIcon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              statusChip(status),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          upload,
          if (kDebugMode && status == "pending")
            TextButton.icon(
              onPressed: approveForTesting,
              icon: const Icon(Icons.science_outlined, size: 18),
              label: const Text("Aprobar (solo pruebas)"),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPedigree = PetBadges.canHavePedigree(pet);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: Colors.white10,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    "Certificados",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Gana tus insignias azules",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Sube tus documentos. Cuando PawMatch los revise, "
                      "tu mascota mostrará las insignias a los demás usuarios.",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 22),
                    section(
                      badgeIcon: Icons.vaccines,
                      badgeColor: const Color(0xFF29B6F6),
                      title: "Carnet de vacunas",
                      description:
                          "Una foto clara del carnet, con las fechas visibles.",
                      status: PetBadges.vaccine(pet),
                      approveForTesting: () => setState(
                        PetBadges.approveVaccineForTesting,
                      ),
                      upload: DocumentUploadCard(
                        dark: true,
                        icon: Icons.vaccines_rounded,
                        title: "Subir carnet",
                        hint: "Toma una foto o elígela de tu galería",
                        initialValue: (pet["vaccineCard"] ?? "").toString(),
                        onUploaded: (url) =>
                            setState(() => PetBadges.setVaccineDoc(url)),
                        onRemoved: () =>
                            setState(() => PetBadges.setVaccineDoc("")),
                      ),
                    ),
                    if (canPedigree)
                      section(
                        badgeIcon: Icons.pets,
                        badgeColor: const Color(0xFF1E88E5),
                        title: "Certificado de pedigrí",
                        description:
                            "Demuestra que tu perro es de raza 100% pura.",
                        status: PetBadges.pedigree(pet),
                        approveForTesting: () => setState(
                          PetBadges.approvePedigreeForTesting,
                        ),
                        upload: DocumentUploadCard(
                          dark: true,
                          icon: Icons.workspace_premium_rounded,
                          title: "Subir certificado",
                          hint: "Toma una foto o elígela de tu galería",
                          initialValue:
                              (pet["pedigreeCertificate"] ?? "").toString(),
                          onUploaded: (url) =>
                              setState(() => PetBadges.setPedigreeDoc(url)),
                          onRemoved: () =>
                              setState(() => PetBadges.setPedigreeDoc("")),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.white54),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Los mestizos solo llevan la insignia de vacunas.",
                                style: TextStyle(
                                  color: Colors.white54,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
