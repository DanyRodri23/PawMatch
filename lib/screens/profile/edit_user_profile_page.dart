import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import '../../data/user_data.dart';
import '../../data/user_profile_data.dart';
import '../../photos/user_photos_page.dart';
import '../../services/cloudinary_service.dart';

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

  final ImagePicker _picker = ImagePicker();
  bool uploadingSelfie = false;
  bool uploadingId = false;

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

  // ----------------------------------------------------- verificación

  String get vStatus =>
      (UserProfileData.user["verifyStatus"] ?? "none").toString();
  String get selfieUrl => (UserProfileData.user["selfieUrl"] ?? "").toString();
  String get idUrl => (UserProfileData.user["idUrl"] ?? "").toString();

  void _snack(String t) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));
  }

  Future<void> takeSelfie() async {
    try {
      final x = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 80,
      );
      if (x == null) return;
      setState(() => uploadingSelfie = true);
      final url = await CloudinaryService.uploadImage(File(x.path));
      if (url == null) throw Exception("sin url");
      UserProfileData.updateVerification(selfieUrl: url);
    } catch (e) {
      _snack("No se pudo subir la selfie. Inténtalo de nuevo.");
    } finally {
      if (mounted) setState(() => uploadingSelfie = false);
    }
  }

  Future<void> uploadId() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF121217),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded,
                  color: Colors.white),
              title: const Text("Tomar foto",
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded,
                  color: Colors.white),
              title: const Text("Elegir de la galería",
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (source == null) return;

    try {
      final x = await _picker.pickImage(source: source, imageQuality: 85);
      if (x == null) return;
      setState(() => uploadingId = true);
      final url = await CloudinaryService.uploadImage(File(x.path));
      if (url == null) throw Exception("sin url");
      UserProfileData.updateVerification(idUrl: url);
    } catch (e) {
      _snack("No se pudo subir el documento. Inténtalo de nuevo.");
    } finally {
      if (mounted) setState(() => uploadingId = false);
    }
  }

  void sendForReview() {
    UserProfileData.updateVerification(status: "pending");
    setState(() {});
    _snack("Enviado. PawMatch revisará tus datos.");
  }

  Widget verifyStep({
    required int number,
    required String title,
    required String subtitle,
    required bool done,
    required bool loading,
    required String actionText,
    required VoidCallback? onTap,
    String? imageUrl,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: done
              ? const Color(0xFF29B6F6).withValues(alpha: 0.5)
              : Colors.white10,
        ),
      ),
      child: Row(
        children: [
          if (imageUrl != null && imageUrl.startsWith("http"))
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                imageUrl,
                width: 54,
                height: 54,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 54,
                  height: 54,
                  color: Colors.white10,
                ),
              ),
            )
          else
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: done ? const Color(0xFF29B6F6) : Colors.white10,
                shape: BoxShape.circle,
              ),
              child: done
                  ? const Icon(Icons.check_rounded, color: Colors.white)
                  : Center(
                      child: Text(
                        "$number",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
            ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (loading)
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          else if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: done ? Colors.white12 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  actionText,
                  style: TextStyle(
                    color: done ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget verificationCard() {
    final st = vStatus;
    final approved = st == "approved";
    final pending = st == "pending";
    final bothReady = selfieUrl.isNotEmpty && idUrl.isNotEmpty;
    const blue = Color(0xFF29B6F6);

    final Color accent = approved ? blue : (pending ? Colors.amber : Colors.pinkAccent);
    final String chipText =
        approved ? "Verificado" : (pending ? "En revisión" : "Sin verificar");

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: accent.withValues(alpha: 0.5)),
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
                  color: accent.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  approved ? Icons.verified_rounded : Icons.shield_outlined,
                  color: accent,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  "Verifica que eres real",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  chipText,
                  style: TextStyle(
                    color: accent,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            approved
                ? "Tu identidad fue confirmada por PawMatch. Ya apareces como dueño verificado."
                : "En PawMatch cada dueño es una persona real. Tu selfie y tu documento son privados: solo los ve el equipo de PawMatch para revisarte.",
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13.5,
              height: 1.4,
            ),
          ),
          if (!approved) ...[
            verifyStep(
              number: 1,
              title: "Selfie en vivo",
              subtitle: "Mira a la cámara, con buena luz y sin lentes oscuros.",
              done: selfieUrl.isNotEmpty,
              loading: uploadingSelfie,
              actionText: selfieUrl.isEmpty ? "Tomar" : "Repetir",
              imageUrl: selfieUrl,
              onTap: pending ? null : takeSelfie,
            ),
            verifyStep(
              number: 2,
              title: "Documento de identidad",
              subtitle: "Cédula o pasaporte (la parte de la foto). Debes ser mayor de 18 años.",
              done: idUrl.isNotEmpty,
              loading: uploadingId,
              actionText: idUrl.isEmpty ? "Subir" : "Cambiar",
              imageUrl: idUrl,
              onTap: pending ? null : uploadId,
            ),
            const SizedBox(height: 14),
            if (pending)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.hourglass_top_rounded,
                        color: Colors.amber, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Estamos revisando tus datos. Te avisaremos cuando termine.",
                        style: TextStyle(color: Colors.white70, height: 1.3),
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.white12,
                    disabledForegroundColor: Colors.white38,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: bothReady ? sendForReview : null,
                  child: const Text(
                    "Enviar a revisión",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            if (kDebugMode && pending)
              TextButton(
                onPressed: () {
                  UserProfileData.updateVerification(status: "approved");
                  setState(() {});
                },
                child: const Text("Aprobar (solo pruebas)"),
              ),
          ],
        ],
      ),
    );
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
                    "Perfil del dueño",
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
                    verificationCard(),
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
