import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../data/pet_options.dart';
import '../../data/pet_profile_data.dart';
import '../../helpers/profile_completion.dart';
import '../../widgets/pet_badge_row.dart';
import '../../widgets/profile_ring_avatar.dart';
import 'certificates_screen.dart';
import '../../photos/pet_photos_page.dart';
import 'edit_pet_profile_page.dart';
import 'edit_user_profile_page.dart';
import 'profile_preview_screen.dart';
import '../match/pet_detail_screen.dart';
import 'settings_screen.dart';
import 'favorites_screen.dart';
import '../../data/favorites_data.dart';
import '../../data/user_profile_data.dart';
import '../../helpers/age_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const Color bg = Color(0xFF0B0B0F);
  static const Color card = Color(0xFF16161C);
  static const Color chip = Color(0xFF22222A);

  Future<void> openPage(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    if (mounted) setState(() {});
  }

  void editPet() => openPage(const EditPetProfilePage());
  void editPhotos() => openPage(const PetPhotosPage());

  void openTarget(ProfileTarget t) {
    switch (t) {
      case ProfileTarget.pet:
        editPet();
        break;
      case ProfileTarget.owner:
        openPage(const EditUserProfilePage());
        break;
      case ProfileTarget.certificates:
        openCertificates();
        break;
    }
  }

  /// Hoja de edición de UNA sola sección (sin pasar por otra pantalla).
  void _sectionSheet({
    required String title,
    required String emoji,
    required Widget Function(StateSetter setSheet) body,
    required VoidCallback onSave,
    String saveText = "Guardar",
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(ctx).size.height * 0.85,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF121217),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 16, 22, 8),
                    child: Row(
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 26)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(22, 8, 22, 8),
                      child: body(setSheet),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: () {
                          onSave();
                          Navigator.pop(ctx);
                          if (mounted) setState(() {});
                        },
                        child: Text(
                          saveText,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void editDescription() {
    final c = TextEditingController(
      text: (PetProfileData.pet["description"] ?? "").toString(),
    );
    _sectionSheet(
      title: "Sobre mí",
      emoji: "🐾",
      body: (_) => TextField(
        controller: c,
        maxLines: 5,
        maxLength: 200,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Cuenta cómo es tu mascota, qué le gusta…",
          hintStyle: const TextStyle(color: Colors.white38),
          filled: true,
          fillColor: Colors.white10,
          counterStyle: const TextStyle(color: Colors.white38),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      onSave: () => PetProfileData.updatePet(description: c.text.trim()),
    );
  }

  void editTraits() {
    final selected = PetProfileData.pet["traits"] is List
        ? List<String>.from(PetProfileData.pet["traits"])
        : <String>[];
    _sectionSheet(
      title: "Personalidad",
      emoji: "🐶",
      body: (setSheet) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${selected.length} elegidas · mínimo 3",
            style: const TextStyle(color: Colors.white54),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PetOptions.traits.map((t) {
              final on = selected.contains(t);
              return GestureDetector(
                onTap: () => setSheet(() {
                  on ? selected.remove(t) : selected.add(t);
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: on ? Colors.pinkAccent : chip,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    t,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      onSave: () => PetProfileData.updatePet(traits: selected),
    );
  }

  void editGoal() {
    String current = (PetProfileData.pet["lookingFor"] ?? "").toString();
    _sectionSheet(
      title: "Qué busco",
      emoji: "🎾",
      body: (setSheet) => Column(
        children: PetOptions.goals.map((g) {
          final on = current == g["text"];
          return GestureDetector(
            onTap: () => setSheet(() => current = g["text"]!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: on
                    ? Colors.pinkAccent.withValues(alpha: 0.18)
                    : chip,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: on ? Colors.pinkAccent : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Text(g["emoji"]!, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      g["text"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (on)
                    const Icon(Icons.check_circle_rounded,
                        color: Colors.pinkAccent),
                ],
              ),
            ),
          );
        }).toList(),
      ),
      onSave: () => PetProfileData.updatePet(lookingFor: current),
    );
  }

  String docLabel(dynamic s) {
    if (s == "approved") return "Aprobado ✓";
    if (s == "pending") return "En revisión";
    return "Pendiente";
  }

  Future<void> openPreview() async {
    await PetDetailScreen.open(context, PetProfileData.pet, preview: true);
    if (mounted) setState(() {});
  }

  Future<void> openCertificates() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CertificatesScreen()),
    );
    if (mounted) setState(() {});
  }

  void soon(String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$what: próximamente"),
        duration: const Duration(seconds: 1),
      ),
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

  @override
  void initState() {
    super.initState();
    FavoritesData.load().then((_) {
      if (mounted) setState(() {});
    });
  }

  void openSettings() => openPage(const SettingsScreen());

  Future<void> editBirth() async {
    final now = DateTime.now();
    final b = PetProfileData.pet["birthDate"];
    final picked = await showDatePicker(
      context: context,
      initialDate: b is DateTime ? b : now,
      firstDate: DateTime(now.year - 25),
      lastDate: now,
      helpText: "Fecha de nacimiento",
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: Colors.pinkAccent),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      PetProfileData.updatePet(birthDate: picked);
      if (mounted) setState(() {});
    }
  }

  /// Hoja para elegir UNA opción de una lista de texto.
  void editChoice({
    required String title,
    required String emoji,
    required String field,
    required List<String> options,
  }) {
    String current = (PetProfileData.pet[field] ?? "").toString();
    _sectionSheet(
      title: title,
      emoji: emoji,
      body: (setSheet) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((o) {
          final on = current == o;
          return GestureDetector(
            onTap: () => setSheet(() => current = o),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: on ? Colors.pinkAccent : chip,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                o,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
      onSave: () => PetProfileData.setFields({field: current}),
    );
  }

  void editGoodWith() {
    final selected = PetProfileData.pet["goodWith"] is List
        ? List<String>.from(PetProfileData.pet["goodWith"])
        : <String>[];
    const options = ["Perros", "Gatos", "Niños", "Adultos mayores", "Desconocidos"];
    _sectionSheet(
      title: "Se lleva bien con",
      emoji: "🤝",
      body: (setSheet) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((o) {
          final on = selected.contains(o);
          return GestureDetector(
            onTap: () => setSheet(() {
              on ? selected.remove(o) : selected.add(o);
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: on ? Colors.pinkAccent : chip,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                o,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
      onSave: () => PetProfileData.setFields({"goodWith": selected}),
    );
  }

  /// "Más controles de perfil": visibilidad, como en Tinder.
  void openControls() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF121217),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final pet = PetProfileData.pet;

          Widget toggle(String label, String sub, String field,
              {bool plus = false, bool defaultOn = false}) {
            final on = pet[field] == null ? defaultOn : pet[field] == true;
            return SwitchListTile(
              contentPadding: EdgeInsets.zero,
              activeThumbColor: Colors.white,
              activeTrackColor: Colors.pinkAccent,
              title: Row(
                children: [
                  Flexible(
                    child: Text(label,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                  if (plus)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Plus",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w800)),
                    ),
                ],
              ),
              subtitle: Text(sub,
                  style:
                      const TextStyle(color: Colors.white54, fontSize: 12.5)),
              value: on,
              onChanged: (v) {
                if (plus) {
                  Navigator.pop(ctx);
                  soon("Ocultar datos (PawMatch Plus)");
                  return;
                }
                PetProfileData.setFields({field: v});
                setSheet(() {});
              },
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text("Controles de perfil",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  toggle("Fotos inteligentes",
                      "Mostramos primero tu mejor foto.", "smartPhotos",
                      defaultOn: true),
                  const Divider(color: Colors.white10),
                  toggle("Ocultar edad", "Nadie verá la edad de tu mascota.",
                      "hideAge",
                      plus: true),
                  toggle("Ocultar distancia", "No se mostrará qué tan cerca estás.",
                      "hideDistance",
                      plus: true),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------ piezas

  Widget circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: chip,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget infoChip(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: chip,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget chipRow(List<Widget> chips) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: chips,
      ),
    );
  }

  Widget sectionTitle(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 12),
        child: Text(
          t,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      );

  Widget photosCard(List images) {
    final shown = images.take(6).map((e) => e.toString()).toList();
    final need = shown.length < 4;

    return GestureDetector(
      onTap: editPhotos,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                height: 118,
                child: shown.isEmpty
                    ? Container(
                        color: chip,
                        child: const Center(
                          child: Icon(Icons.add_a_photo_rounded,
                              color: Colors.white38, size: 36),
                        ),
                      )
                    : Row(
                        children: shown.map((u) {
                          return Expanded(
                            child: Image.network(
                              u,
                              height: 118,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: chip),
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(children: [
                      const TextSpan(
                        text: "Consejo: ",
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text: need
                            ? "sube al menos 4 fotos de tu mascota."
                            : "muestra a tu mascota en distintas situaciones.",
                      ),
                    ]),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: const Text(
                    "Editar",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dataCard(List<Widget> rows) {
    final kids = <Widget>[];
    for (int i = 0; i < rows.length; i++) {
      kids.add(rows[i]);
      if (i != rows.length - 1) {
        kids.add(const Divider(color: Colors.white10, height: 1, indent: 56));
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(children: kids),
    );
  }

  Widget dataRow(
      String emoji, String label, String value, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: Text(label,
                  style: const TextStyle(color: Colors.white70, fontSize: 15)),
            ),
            Expanded(
              flex: 6,
              child: Text(
                value.isEmpty ? "Agregar" : value,
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: value.isEmpty ? Colors.white38 : Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white30),
          ],
        ),
      ),
    );
  }

  Widget aboutTile({
    required double width,
    required String label,
    String? text,
    List<String>? tags,
    required String emoji,
    required VoidCallback onTap,
  }) {
    final empty = (text == null || text.isEmpty) && (tags == null || tags.isEmpty);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        constraints: const BoxConstraints(minHeight: 110),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 19)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 14.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (empty)
              const Text(
                "Toca para agregar",
                style: TextStyle(color: Colors.white38, fontSize: 15),
              )
            else if (tags != null)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: tags
                    .map(
                      (t) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          t,
                          style: const TextStyle(
                            color: Color(0xFFFF9CC4),
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              )
            else
              Text(
                text!,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Color(0xFF2C2C34),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit_rounded,
                    color: Colors.white70, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statsBar(Map pet) {
    Widget item(IconData icon, Color color, String text, [VoidCallback? onTap]) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          item(Icons.favorite_rounded, Colors.pinkAccent,
              "${pet["likes"] ?? 0} Likes"),
          item(Icons.pets, Colors.amber, "${pet["matches"] ?? 0} Matches"),
          item(Icons.verified_user_rounded, Colors.lightBlueAccent,
              "Certificados", openCertificates),
        ],
      ),
    );
  }

  // -------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final pet = PetProfileData.pet;

    final images = pet["images"] is List ? pet["images"] as List : [];
    final photo = images.isNotEmpty ? images.first.toString() : null;

    final name = (pet["name"] ?? "").toString();
    final age = pet["age"] ?? 0;
    final unit = (pet["ageType"] ?? "años").toString();
    final breed = (pet["breed"] ?? "").toString();
    final gender = (pet["gender"] ?? "").toString();
    final location = (pet["location"] ?? "").toString();
    final goal = (pet["lookingFor"] ?? "").toString();
    final desc = (pet["description"] ?? "").toString();
    final traits = pet["traits"] is List
        ? (pet["traits"] as List).map((e) => e.toString()).toList()
        : <String>[];

    PetProfileData.refreshAge();
    final isPure = pet["isPureBreed"] == true;
    final nameOrPet = name.isEmpty ? "mi mascota" : name;
    final bd = pet["birthDate"];
    final birthText = bd is DateTime
        ? "${bd.day.toString().padLeft(2, "0")}/${bd.month.toString().padLeft(2, "0")}/${bd.year} · ${AgeHelper.petAgeText((pet["age"] as num).toInt(), unit)}"
        : "";
    final size = (pet["size"] ?? "").toString();
    final energy = (pet["energy"] ?? "").toString();
    final neutered = (pet["neutered"] ?? "").toString();
    final goodWith = pet["goodWith"] is List
        ? (pet["goodWith"] as List).map((e) => e.toString()).toList()
        : <String>[];
    final ownerStatus =
        (UserProfileData.user["verifyStatus"] ?? "none").toString();

    final percent = ProfileCompletion.percent();
    final pending = ProfileCompletion.pending();

    final tileW = (MediaQuery.of(context).size.width - 40 - 12) / 2;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: bottom + 24),
          children: [
            // Encabezado
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: [
                  ProfileRingAvatar(photoUrl: photo, percent: percent, size: 92),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                name.isEmpty ? "Tu mascota" : name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            PetBadgeRow(pet: pet, size: 24),
                          ],
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: openPreview,
                          behavior: HitTestBehavior.opaque,
                          child: const Row(
                            children: [
                              Text(
                                "Vista previa",
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 17,
                                ),
                              ),
                              Icon(Icons.chevron_right_rounded,
                                  color: Colors.white60),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  circleBtn(Icons.settings_outlined, openSettings),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Chips con datos
            chipRow([
              if (location.isNotEmpty) infoChip(Icons.location_on_outlined, location),
              infoChip(Icons.cake_outlined, AgeHelper.petAgeText((age as num).toInt(), unit)),
              if (breed.isNotEmpty) infoChip(Icons.pets, breed),
            ]),
            const SizedBox(height: 10),
            chipRow([
              if (gender.isNotEmpty)
                infoChip(
                  gender == "Hembra" ? Icons.female_rounded : Icons.male_rounded,
                  gender,
                ),
              if (goal.isNotEmpty) infoChip(Icons.favorite_border_rounded, goal),
            ]),

            // Progreso del perfil
            const SizedBox(height: 18),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(18),
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
                      Expanded(
                        child: Text(
                          pending.isEmpty
                              ? "¡Perfil completo! 🎉"
                              : "Tu perfil está al $percent%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text("$percent%",
                          style: const TextStyle(
                              color: Colors.pinkAccent,
                              fontWeight: FontWeight.w800,
                              fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: percent / 100,
                      minHeight: 8,
                      backgroundColor: Colors.white12,
                      valueColor:
                          const AlwaysStoppedAnimation(Colors.pinkAccent),
                    ),
                  ),
                  if (pending.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    const Text(
                      "Sube tu progreso haciendo esto:",
                      style: TextStyle(color: Colors.white60, fontSize: 13.5),
                    ),
                    const SizedBox(height: 6),
                    for (final t in pending.take(3))
                      InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => openTarget(t.target),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: Colors.pinkAccent
                                      .withValues(alpha: 0.14),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(t.icon,
                                    color: Colors.pinkAccent, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(t.title,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700)),
                                    Text(t.subtitle,
                                        style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12.5)),
                                  ],
                                ),
                              ),
                              Text("+${t.weight}%",
                                  style: const TextStyle(
                                      color: Color(0xFFFF9CC4),
                                      fontWeight: FontWeight.w800)),
                              const Icon(Icons.chevron_right_rounded,
                                  color: Colors.white38),
                            ],
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),

            sectionTitle("Mis fotos"),
            photosCard(images),

            sectionTitle("Más acerca de $nameOrPet"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  aboutTile(
                    width: double.infinity,
                    label: "Sobre mí",
                    text: desc,
                    emoji: "🐾",
                    onTap: editDescription,
                  ),
                  const SizedBox(height: 12),
                  aboutTile(
                    width: double.infinity,
                    label: "Personalidad",
                    tags: traits,
                    emoji: "🐶",
                    onTap: editTraits,
                  ),
                  const SizedBox(height: 12),
                  dataCard([
                    dataRow("🎂", "Nacimiento", birthText, editBirth),
                    dataRow("🎾", "Qué busco", goal, editGoal),
                    dataRow("📏", "Tamaño", size, () => editChoice(
                          title: "Tamaño",
                          emoji: "📏",
                          field: "size",
                          options: const ["Pequeño", "Mediano", "Grande", "Gigante"],
                        )),
                    dataRow("⚡", "Energía", energy, () => editChoice(
                          title: "Nivel de energía",
                          emoji: "⚡",
                          field: "energy",
                          options: const ["Tranquilo", "Moderado", "Muy activo"],
                        )),
                    dataRow("✂️", "Esterilizado", neutered, () => editChoice(
                          title: "Esterilizado",
                          emoji: "✂️",
                          field: "neutered",
                          options: const ["Sí", "No"],
                        )),
                    dataRow("🤝", "Se lleva bien con",
                        goodWith.join(", "), editGoodWith),
                  ]),
                ],
              ),
            ),

            sectionTitle("Certificados de $nameOrPet"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: dataCard([
                dataRow("💉", "Carnet de vacunas",
                    docLabel(pet["vaccineStatus"]), openCertificates),
                if (isPure)
                  dataRow("📜", "Pedigrí",
                      docLabel(pet["pedigreeStatus"]), openCertificates),
              ]),
            ),

            sectionTitle("Mis lugares"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: dataCard([
                dataRow(
                  "❤️",
                  "Parques y hoteles favoritos",
                  FavoritesData.count == 0 ? "" : "${FavoritesData.count}",
                  () => openPage(const FavoritesScreen()),
                ),
              ]),
            ),

            sectionTitle("Dueño"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: dataCard([
                dataRow(
                  "🧑",
                  "Perfil del dueño",
                  ownerStatus == "approved"
                      ? "Verificado ✓"
                      : ownerStatus == "pending"
                          ? "En revisión"
                          : "Sin verificar",
                  () => openPage(const EditUserProfilePage()),
                ),
              ]),
            ),

            const SizedBox(height: 22),
            GestureDetector(
              onTap: openControls,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white10),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          "Más controles de perfil",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: Colors.white54),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            statsBar(pet),
          ],
        ),
      ),
    );
  }
}
