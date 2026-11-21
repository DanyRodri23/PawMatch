import 'package:flutter/material.dart';
import '../../data/pet_profile_data.dart';
import '../../helpers/pet_badges.dart';
import '../../helpers/profile_completion.dart';
import '../../widgets/pet_badge_row.dart';
import '../../widgets/profile_ring_avatar.dart';
import 'certificates_screen.dart';
import 'edit_pet_profile_page.dart';
import 'edit_user_profile_page.dart';
import 'profile_preview_screen.dart';

/// "Gestionar perfil": mascota, dueño, vista previa y certificados.
class EditProfileProPage extends StatefulWidget {
  const EditProfileProPage({super.key});

  @override
  State<EditProfileProPage> createState() => _EditProfileProPageState();
}

class _EditProfileProPageState extends State<EditProfileProPage> {
  static const Color bg = Color(0xFF0B0B0F);
  static const Color card = Color(0xFF16161C);

  Future<void> open(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    if (mounted) setState(() {});
  }

  void openTarget(ProfileTarget target) {
    switch (target) {
      case ProfileTarget.pet:
        open(const EditPetProfilePage());
        break;
      case ProfileTarget.owner:
        open(const EditUserProfilePage());
        break;
      case ProfileTarget.certificates:
        open(const CertificatesScreen());
        break;
    }
  }

  Widget taskCard(ProfileTask t) {
    return GestureDetector(
      onTap: () => openTarget(t.target),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.pinkAccent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(t.icon, color: Colors.pinkAccent, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    t.subtitle,
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),
            Text(
              "+${t.weight}%",
              style: const TextStyle(
                color: Colors.pinkAccent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? dot,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 118,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.white, size: 26),
                  const Spacer(),
                  if (dot != null)
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: dot == "ok" ? Colors.lightBlueAccent : Colors.amber,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pet = PetProfileData.pet;

    final images = pet["images"] is List ? pet["images"] as List : [];
    final photo = images.isNotEmpty ? images.first.toString() : null;

    final name = (pet["name"] ?? "").toString();
    final age = pet["age"] ?? 0;
    final unit = (pet["ageType"] ?? "años").toString();

    final percent = ProfileCompletion.percent();
    final pending = ProfileCompletion.pending();

    final pedigree = PetBadges.pedigree(pet);
    final vaccine = PetBadges.vaccine(pet);

    String? certDot;
    if (vaccine == "pending" || pedigree == "pending") {
      certDot = "pending";
    } else if (vaccine == "approved" || pedigree == "approved") {
      certDot = "ok";
    }

    return Scaffold(
      backgroundColor: bg,
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
                    "Gestionar perfil",
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
                    Row(
                      children: [
                        ProfileRingAvatar(
                          photoUrl: photo,
                          percent: percent,
                          size: 96,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name.isEmpty ? "Tu mascota" : name,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "$age $unit",
                                style: const TextStyle(color: Colors.white54),
                              ),
                              const SizedBox(height: 8),
                              PetBadgeRow(pet: pet, size: 26),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        tile(
                          icon: Icons.pets,
                          title: "Mascota",
                          subtitle: "Fotos y datos",
                          onTap: () => open(const EditPetProfilePage()),
                        ),
                        const SizedBox(width: 12),
                        tile(
                          icon: Icons.person_rounded,
                          title: "Dueño",
                          subtitle: "Tu información",
                          onTap: () => open(const EditUserProfilePage()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        tile(
                          icon: Icons.remove_red_eye_rounded,
                          title: "Vista previa",
                          subtitle: "Cómo te ven",
                          onTap: () =>
                              open(ProfilePreviewScreen(pet: PetProfileData.pet)),
                        ),
                        const SizedBox(width: 12),
                        tile(
                          icon: Icons.verified_user_rounded,
                          title: "Certificados",
                          subtitle: "Vacunas y pedigrí",
                          dot: certDot,
                          onTap: () => open(const CertificatesScreen()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    if (pending.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "¡Tu perfil está completo!",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      const Text(
                        "Completa tu perfil",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Los perfiles completos reciben más matches.",
                        style: TextStyle(color: Colors.white54),
                      ),
                      const SizedBox(height: 14),
                      for (final t in pending) taskCard(t),
                    ],
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
