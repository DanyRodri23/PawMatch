import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/pet_profile_data.dart';
import '../../helpers/profile_completion.dart';
import '../../widgets/pet_badge_row.dart';
import '../../widgets/profile_ring_avatar.dart';
import 'edit_profile_pro_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color bg = Color(0xFF0B0B0F);
  static const Color card = Color(0xFF16161C);

  Future<void> openEditor() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileProPage()),
    );

    if (mounted) setState(() {});
  }

  void soon(String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$what: próximamente")),
    );
  }

  Future<void> logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cerrar sesión"),
        content: const Text("¿Seguro que quieres salir de PawMatch?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Cerrar sesión"),
          ),
        ],
      ),
    );

    if (ok == true) {
      await FirebaseAuth.instance.signOut();
    }
  }

  Widget statBox(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuTile(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color color = Colors.white,
    bool arrow = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (arrow)
              const Icon(Icons.chevron_right_rounded, color: Colors.white38),
          ],
        ),
      ),
    );
  }

  Widget premiumBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2A2210), Color(0xFF16161C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.workspace_premium_rounded,
                color: Colors.amber, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PawMatch Premium",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Ver quién te dio like, boosts y más.",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              "Pronto",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
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
    final breed = (pet["breed"] ?? "").toString();
    final location = (pet["location"] ?? "").toString();

    final percent = ProfileCompletion.percent();
    final pending = ProfileCompletion.pending();

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
          child: Column(
            children: [
              ProfileRingAvatar(photoUrl: photo, percent: percent),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      name.isEmpty ? "Tu mascota" : "$name, $age $unit",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  PetBadgeRow(pet: pet, size: 26),
                ],
              ),
              if (breed.isNotEmpty || location.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  [breed, location].where((e) => e.isNotEmpty).join("  •  "),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: openEditor,
                  icon: const Icon(Icons.edit_rounded, size: 20),
                  label: const Text(
                    "Editar perfil",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              if (pending.isNotEmpty) ...[
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: openEditor,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.pinkAccent.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: Colors.pinkAccent.withValues(alpha: 0.30),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(pending.first.icon, color: Colors.pinkAccent),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Siguiente: ${pending.first.title}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                pending.first.subtitle,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded,
                            color: Colors.pinkAccent),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Row(
                children: [
                  statBox("Likes", "${pet["likes"] ?? 0}", Icons.favorite,
                      Colors.pinkAccent),
                  const SizedBox(width: 12),
                  statBox("Matches", "${pet["matches"] ?? 0}",
                      Icons.pets, Colors.amber),
                ],
              ),
              const SizedBox(height: 20),
              premiumBanner(),
              const SizedBox(height: 22),
              menuTile(Icons.settings_rounded, "Configuración",
                  () => soon("Configuración")),
              menuTile(Icons.help_outline_rounded, "Ayuda y soporte",
                  () => soon("Ayuda")),
              menuTile(
                Icons.logout_rounded,
                "Cerrar sesión",
                logout,
                color: Colors.redAccent,
                arrow: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
