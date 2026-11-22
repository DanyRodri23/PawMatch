import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/user_data.dart';
import '../../data/user_profile_data.dart';
import '../../photos/user_photos_page.dart';

class EditUserProfilePage extends StatefulWidget {
  const EditUserProfilePage({super.key});

  @override
  State<EditUserProfilePage> createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  static const Color bg = Color(0xFF0B0B0F);
  static const Color card = Color(0xFF16161C);

  static const List<String> genders = [
    "Masculino",
    "Femenino",
    "Prefiero no decir",
  ];

  late final TextEditingController nameController;
  late final TextEditingController bioController;
  late final TextEditingController instagramController;

  String gender = "";
  bool showGender = true;

  @override
  void initState() {
    super.initState();

    final user = UserProfileData.user;

    nameController = TextEditingController(
      text: (user["name"] ?? "").toString(),
    );

    bioController = TextEditingController(
      text: (user["bio"] ?? "").toString(),
    );

    final insta = (user["instagram"] ?? "").toString();
    instagramController = TextEditingController(
      text: insta == "@usuario" ? "" : insta,
    );

    final g = (user["gender"] ?? "").toString();
    gender = genders.contains(g) ? g : "";

    showGender = user["showGender"] != false;
  }

  @override
  void dispose() {
    nameController.dispose();
    bioController.dispose();
    instagramController.dispose();
    super.dispose();
  }

  bool get canSave => nameController.text.trim().length >= 2;

  void save() {
    if (!canSave) return;

    var insta = instagramController.text.trim();
    if (insta.isNotEmpty && !insta.startsWith("@")) insta = "@$insta";

    UserProfileData.updateUser(
      name: nameController.text.trim(),
      bio: bioController.text.trim(),
      instagram: insta,
      gender: gender.isEmpty ? null : gender,
      showGender: showGender,
    );

    // Mantiene sincronizado el nombre del registro.
    UserData.updateProfile(
      name: nameController.text.trim(),
      showGender: showGender,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Perfil actualizado")),
    );

    Navigator.pop(context);
  }

  Widget section(String title, Widget child) {
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
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  InputDecoration fieldDecoration(String label, {Widget? prefix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white60),
      prefixIcon: prefix,
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

  Widget photosRow() {
    final images = UserData.profile["images"] is List
        ? UserData.profile["images"] as List
        : [];

    final first = images.isNotEmpty ? images.first.toString() : null;
    final hasPhoto = first != null && first.startsWith("http");

    return Row(
      children: [
        CircleAvatar(
          radius: 38,
          backgroundColor: Colors.white10,
          backgroundImage: hasPhoto ? NetworkImage(first) : null,
          child: hasPhoto
              ? null
              : const Icon(Icons.person, color: Colors.white38, size: 36),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${images.length} foto${images.length == 1 ? "" : "s"}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
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
                    MaterialPageRoute(builder: (_) => const UserPhotosPage()),
                  );
                  if (mounted) setState(() {});
                },
                icon: const Icon(Icons.photo_library_outlined, size: 18),
                label: const Text("Administrar"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget genderChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final g in genders)
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => gender = g);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: gender == g ? Colors.pinkAccent : Colors.white10,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                g,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: gender == g ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final location = (UserData.profile["location"] ?? "").toString();
    final verified = UserProfileData.user["verified"] == true;

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
                    "Editar dueño",
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
                    section("Tus fotos", photosRow()),
                    section(
                      "Sobre ti",
                      Column(
                        children: [
                          TextField(
                            controller: nameController,
                            maxLength: 30,
                            textCapitalization: TextCapitalization.words,
                            style: const TextStyle(color: Colors.white),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r"[A-Za-zÁÉÍÓÚÜÑáéíóúüñ' \-]"),
                              ),
                            ],
                            onChanged: (_) => setState(() {}),
                            decoration: fieldDecoration("Nombre"),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: bioController,
                            maxLines: 4,
                            maxLength: 300,
                            textCapitalization: TextCapitalization.sentences,
                            style: const TextStyle(color: Colors.white),
                            decoration: fieldDecoration("Biografía"),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: instagramController,
                            style: const TextStyle(color: Colors.white),
                            autocorrect: false,
                            decoration: fieldDecoration(
                              "Instagram (opcional)",
                              prefix: const Icon(Icons.alternate_email,
                                  color: Colors.white38, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    section(
                      "Género",
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          genderChips(),
                          const SizedBox(height: 10),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            activeThumbColor: Colors.pinkAccent,
                            value: showGender,
                            onChanged: (v) => setState(() => showGender = v),
                            title: const Text(
                              "Mostrar en mi perfil",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    section(
                      "Ubicación",
                      Row(
                        children: [
                          const Icon(Icons.location_on_rounded,
                              color: Colors.pinkAccent),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  location.isEmpty ? "Sin detectar" : location,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  "Se actualiza sola cuando cambias de provincia.",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: card,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            verified
                                ? Icons.verified_rounded
                                : Icons.shield_outlined,
                            color: verified
                                ? Colors.lightBlueAccent
                                : Colors.white38,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              verified
                                  ? "Tu perfil está verificado."
                                  : "Verificación de dueño: próximamente.",
                              style: const TextStyle(
                                color: Colors.white70,
                                height: 1.35,
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
