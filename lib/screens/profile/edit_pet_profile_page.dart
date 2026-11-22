import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/pet_options.dart';
import '../../data/pet_profile_data.dart';
import '../../photos/pet_photos_page.dart';
import 'certificates_screen.dart';

class EditPetProfilePage extends StatefulWidget {
  const EditPetProfilePage({super.key});

  @override
  State<EditPetProfilePage> createState() => _EditPetProfilePageState();
}

class _EditPetProfilePageState extends State<EditPetProfilePage> {
  static const Color bg = Color(0xFF0B0B0F);
  static const Color card = Color(0xFF16161C);

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  int age = 1;
  String unit = "años";
  String gender = "";
  bool isPure = false;
  String breed = "";
  String lookingFor = "";
  List<String> selectedTraits = [];

  @override
  void initState() {
    super.initState();

    final pet = PetProfileData.pet;

    nameController.text = (pet["name"] ?? "").toString();
    descriptionController.text = (pet["description"] ?? "").toString();

    final a = pet["age"];
    age = (a is int && a > 0) ? a : 1;
    unit = pet["ageType"] == "meses" ? "meses" : "años";

    final g = (pet["gender"] ?? "").toString().toLowerCase();
    gender = g == "macho" ? "Macho" : (g == "hembra" ? "Hembra" : "");

    isPure = pet["isPureBreed"] == true;
    breed = (pet["breed"] ?? "").toString();
    lookingFor = (pet["lookingFor"] ?? "").toString();

    selectedTraits =
        pet["traits"] is List ? List<String>.from(pet["traits"]) : [];
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  bool get canSave => nameController.text.trim().isNotEmpty;

  void save() {
    if (!canSave) return;

    PetProfileData.updatePet(
      name: nameController.text.trim(),
      age: age,
      ageType: unit,
      gender: gender,
      isPureBreed: isPure,
      breed: isPure ? breed : "",
      lookingFor: lookingFor,
      description: descriptionController.text.trim(),
      traits: selectedTraits,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Perfil actualizado")),
    );

    Navigator.pop(context);
  }

  int get maxAge => unit == "años" ? 30 : 36;

  void changeAge(int delta) {
    final next = age + delta;
    if (next < 1 || next > maxAge) return;
    HapticFeedback.selectionClick();
    setState(() => age = next);
  }

  // ---------- piezas ----------

  Widget section(String title, Widget child, {String? hint}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (hint != null) ...[
            const SizedBox(height: 4),
            Text(hint, style: const TextStyle(color: Colors.white54)),
          ],
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60),
      filled: true,
      fillColor: Colors.white10,
      counterStyle: const TextStyle(color: Colors.white38),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Colors.pinkAccent, width: 1.5),
      ),
    );
  }

  Widget segmented(List<String> options, String current, ValueChanged<String> onTap) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          for (final o in options)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  onTap(o);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: current == o ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Text(
                    o,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: current == o ? Colors.black : Colors.white70,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget chip(String text, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.pinkAccent : Colors.white10,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget photosPreview() {
    final images = PetProfileData.pet["images"] is List
        ? PetProfileData.pet["images"] as List
        : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 78,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.isEmpty ? 1 : images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              if (images.isEmpty) {
                return Container(
                  width: 78,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.pets, color: Colors.white38),
                );
              }

              final url = images[i].toString();

              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 78,
                  height: 78,
                  child: url.startsWith("http")
                      ? Image.network(url, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.broken_image_outlined,
                              color: Colors.white38))
                      : const Icon(Icons.image_not_supported_outlined,
                          color: Colors.white38),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PetPhotosPage()),
              );
              if (mounted) setState(() {});
            },
            icon: const Icon(Icons.photo_library_outlined, size: 20),
            label: const Text("Administrar fotos"),
          ),
        ),
      ],
    );
  }

  Widget ageStepper() {
    Widget round(IconData icon, VoidCallback onTap, bool enabled) {
      return GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: enabled ? Colors.white : Colors.white12,
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              color: enabled ? Colors.black : Colors.white30, size: 24),
        ),
      );
    }

    return Row(
      children: [
        round(Icons.remove_rounded, () => changeAge(-1), age > 1),
        Expanded(
          child: Text(
            "$age ${unit == "años" ? (age == 1 ? "año" : "años") : (age == 1 ? "mes" : "meses")}",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        round(Icons.add_rounded, () => changeAge(1), age < maxAge),
      ],
    );
  }

  Future<void> pickBreed() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        String query = "";

        return StatefulBuilder(
          builder: (context, setSheet) {
            final list = PetOptions.breeds
                .where((b) => b.toLowerCase().contains(query.toLowerCase()))
                .toList()
              ..sort();

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  18,
                  18,
                  18,
                  MediaQuery.of(context).viewInsets.bottom + 10,
                ),
                child: Column(
                  children: [
                    TextField(
                      autofocus: false,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Buscar raza",
                        hintStyle: const TextStyle(color: Colors.white38),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (v) => setSheet(() => query = v),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: list.isEmpty
                          ? const Center(
                              child: Text("No encontramos esa raza",
                                  style: TextStyle(color: Colors.white54)),
                            )
                          : ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (_, i) => ListTile(
                                title: Text(
                                  list[i],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: list[i] == breed
                                    ? const Icon(Icons.check_circle,
                                        color: Colors.pinkAccent)
                                    : null,
                                onTap: () => Navigator.pop(context, list[i]),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null && mounted) setState(() => breed = result);
  }

  @override
  Widget build(BuildContext context) {
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
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    "Editar mascota",
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
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
                child: Column(
                  children: [
                    section("Fotos", photosPreview()),
                    section(
                      "Datos básicos",
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: nameController,
                            maxLength: 25,
                            textCapitalization: TextCapitalization.words,
                            style: const TextStyle(color: Colors.white),
                            onChanged: (_) => setState(() {}),
                            decoration: fieldDecoration("Nombre"),
                          ),
                          const SizedBox(height: 14),
                          const Text("Edad",
                              style: TextStyle(color: Colors.white70)),
                          const SizedBox(height: 10),
                          ageStepper(),
                          const SizedBox(height: 12),
                          segmented(
                            const ["años", "meses"],
                            unit,
                            (v) => setState(() {
                              unit = v;
                              if (age > maxAge) age = maxAge;
                            }),
                          ),
                          const SizedBox(height: 18),
                          const Text("Sexo",
                              style: TextStyle(color: Colors.white70)),
                          const SizedBox(height: 10),
                          segmented(
                            const ["Macho", "Hembra"],
                            gender,
                            (v) => setState(() => gender = v),
                          ),
                        ],
                      ),
                    ),
                    section(
                      "Raza",
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          segmented(
                            const ["De raza", "Mestizo"],
                            isPure ? "De raza" : "Mestizo",
                            (v) => setState(() => isPure = v == "De raza"),
                          ),
                          if (isPure) ...[
                            const SizedBox(height: 14),
                            GestureDetector(
                              onTap: pickBreed,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white10,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.pets,
                                        color: Colors.white54, size: 20),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        breed.isEmpty
                                            ? "Elegir raza"
                                            : breed,
                                        style: TextStyle(
                                          color: breed.isEmpty
                                              ? Colors.white54
                                              : Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
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
                    section(
                      "Personalidad",
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final t in PetOptions.traits)
                                chip(
                                  t,
                                  selectedTraits.contains(t),
                                  () => setState(() {
                                    selectedTraits.contains(t)
                                        ? selectedTraits.remove(t)
                                        : selectedTraits.add(t);
                                  }),
                                ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          TextField(
                            controller: descriptionController,
                            maxLines: 4,
                            maxLength: 200,
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(color: Colors.white),
                            decoration: fieldDecoration("Descripción"),
                          ),
                        ],
                      ),
                    ),
                    section(
                      "Qué busca",
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final g in PetOptions.goals)
                            chip(
                              "${g["emoji"]} ${g["text"]}",
                              lookingFor == g["text"],
                              () => setState(() => lookingFor = g["text"]!),
                            ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CertificatesScreen(),
                          ),
                        );
                        if (mounted) setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(26),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.verified_user_rounded,
                                color: Colors.lightBlueAccent),
                            SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                "Las insignias de vacunas y pedigrí se ganan subiendo tus certificados.",
                                style: TextStyle(
                                  color: Colors.white70,
                                  height: 1.35,
                                ),
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded,
                                color: Colors.white38),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white12,
                    disabledForegroundColor: Colors.white38,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: canSave ? save : null,
                  child: const Text(
                    "Guardar cambios",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
