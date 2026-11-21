import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'pet_personality_screen.dart';
import '../../widgets/pet_step_scaffold.dart';
import '../../data/pet_profile_data.dart';
import '../../services/cloudinary_service.dart';

enum _Slot { empty, uploading, ok, failed }

class PetPhotosScreen extends StatefulWidget {
  final bool isBreedDog;
  final bool fromVaccineCard;

  const PetPhotosScreen({
    super.key,
    required this.isBreedDog,
    this.fromVaccineCard = false,
  });

  @override
  State<PetPhotosScreen> createState() => _PetPhotosScreenState();
}

class _PetPhotosScreenState extends State<PetPhotosScreen> {
  static const int total = 6;
  static const int minimum = 4;

  final List<String?> urls = List.filled(total, null);
  final List<Uint8List?> previews = List.filled(total, null);
  final List<_Slot> slots = List.filled(total, _Slot.empty);

  @override
  void initState() {
    super.initState();

    final saved = List<String>.from(PetProfileData.pet["images"] ?? []);

    for (int i = 0; i < saved.length && i < total; i++) {
      urls[i] = saved[i];
      slots[i] = _Slot.ok;
    }
  }

  int get uploaded => slots.where((s) => s == _Slot.ok).length;

  bool get anyUploading => slots.contains(_Slot.uploading);

  String get petName {
    final n = (PetProfileData.pet["name"] ?? "").toString().trim();
    return n.isEmpty ? "tu mascota" : n;
  }

  Future<ImageSource?> askSource() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text("Tomar una foto"),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text("Elegir de la galería"),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> pickPhoto(int index) async {
    final source = await askSource();
    if (source == null || !mounted) return;

    XFile? picked;
    try {
      picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1800,
      );
    } catch (_) {
      picked = null;
    }

    if (picked == null || !mounted) return;

    final bytes = await picked.readAsBytes();

    setState(() {
      previews[index] = bytes;
      slots[index] = _Slot.uploading;
    });

    try {
      final url = await CloudinaryService.uploadImage(File(picked.path))
          .timeout(const Duration(seconds: 40));

      if (!mounted) return;

      if (url == null || url.isEmpty) {
        setState(() => slots[index] = _Slot.failed);
        return;
      }

      setState(() {
        urls[index] = url;
        slots[index] = _Slot.ok;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => slots[index] = _Slot.failed);
    }
  }

  void removePhoto(int index) {
    setState(() {
      urls[index] = null;
      previews[index] = null;
      slots[index] = _Slot.empty;
    });
  }

  void makeMain(int index) {
    setState(() {
      final u = urls[index];
      final p = previews[index];
      final s = slots[index];

      urls[index] = urls[0];
      previews[index] = previews[0];
      slots[index] = slots[0];

      urls[0] = u;
      previews[0] = p;
      slots[0] = s;
    });
  }

  Future<void> photoMenu(int index) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            if (index != 0)
              ListTile(
                leading: const Icon(Icons.star_outline_rounded),
                title: const Text("Hacer foto principal"),
                onTap: () => Navigator.pop(context, "main"),
              ),
            ListTile(
              leading: const Icon(Icons.swap_horiz_rounded),
              title: const Text("Cambiar foto"),
              onTap: () => Navigator.pop(context, "change"),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text(
                "Quitar foto",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => Navigator.pop(context, "remove"),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (action == "main") makeMain(index);
    if (action == "remove") removePhoto(index);
    if (action == "change") await pickPhoto(index);
  }

  void goNext() {
    final valid = <String>[];

    for (int i = 0; i < total; i++) {
      final u = urls[i];
      if (slots[i] == _Slot.ok && u != null) valid.add(u);
    }

    if (valid.length < minimum) return;

    PetProfileData.updatePet(images: valid);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetPersonalityScreen(
          isBreedDog: widget.isBreedDog,
        ),
      ),
    );
  }

  Widget image(int index) {
    final preview = previews[index];
    final url = urls[index];

    if (preview != null) {
      return Image.memory(preview, fit: BoxFit.cover);
    }

    if (url != null && url.startsWith("http")) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Center(child: Icon(Icons.broken_image_outlined)),
      );
    }

    if (url != null) {
      return Image.file(
        File(url),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Center(child: Icon(Icons.broken_image_outlined)),
      );
    }

    return const SizedBox();
  }

  Widget photoBox(int index) {
    final slot = slots[index];
    final isMain = index == 0;

    Widget content;

    switch (slot) {
      case _Slot.ok:
        content = Stack(
          fit: StackFit.expand,
          children: [
            image(index),
            if (isMain)
              Positioned(
                left: 8,
                top: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "Principal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        );
        break;

      case _Slot.uploading:
        content = Stack(
          fit: StackFit.expand,
          children: [
            if (previews[index] != null)
              Image.memory(previews[index]!, fit: BoxFit.cover),
            Container(color: Colors.black.withValues(alpha: 0.45)),
            const Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
        break;

      case _Slot.failed:
        content = Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.refresh_rounded, color: Colors.red.shade400, size: 28),
              const SizedBox(height: 4),
              const Text(
                "Reintentar",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
        break;

      case _Slot.empty:
        content = Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isMain ? 54 : 38,
                height: isMain ? 54 : 38,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_a_photo_rounded,
                  color: Colors.white,
                  size: isMain ? 26 : 18,
                ),
              ),
              if (isMain) ...[
                const SizedBox(height: 10),
                const Text(
                  "Foto principal",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ],
          ),
        );
        break;
    }

    return GestureDetector(
      onTap: () {
        if (slot == _Slot.uploading) return;
        if (slot == _Slot.ok) {
          photoMenu(index);
        } else {
          pickPhoto(index);
        }
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isMain ? Colors.black : Colors.grey.shade300,
            width: isMain ? 2 : 1,
          ),
        ),
        child: content,
      ),
    );
  }

  Widget grid() {
    return LayoutBuilder(
      builder: (context, box) {
        const gap = 12.0;
        final small = (box.maxWidth - gap * 2) / 3;
        final big = small * 2 + gap;

        return Column(
          children: [
            Row(
              children: [
                SizedBox(width: big, height: big, child: photoBox(0)),
                const SizedBox(width: gap),
                Column(
                  children: [
                    SizedBox(width: small, height: small, child: photoBox(1)),
                    const SizedBox(height: gap),
                    SizedBox(width: small, height: small, child: photoBox(2)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: gap),
            Row(
              children: [
                SizedBox(width: small, height: small, child: photoBox(3)),
                const SizedBox(width: gap),
                SizedBox(width: small, height: small, child: photoBox(4)),
                const SizedBox(width: gap),
                SizedBox(width: small, height: small, child: photoBox(5)),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ready = uploaded >= minimum && !anyUploading;

    return PetStepScaffold(
      stepKey: "photos",
      emoji: "📸",
      title: "Fotos de $petName",
      subtitle: "Agrega al menos $minimum fotos. La primera es la que verán todos.",
      onNext: ready ? goNext : null,
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            ready ? Icons.check_circle : Icons.photo_library_outlined,
            size: 18,
            color: ready ? Colors.green : Colors.black45,
          ),
          const SizedBox(width: 6),
          Text(
            anyUploading
                ? "Subiendo fotos..."
                : "$uploaded de $minimum fotos mínimas",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ready ? Colors.green : Colors.black54,
            ),
          ),
        ],
      ),
      child: grid(),
    );
  }
}
