import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'location_permission_screen.dart';
import '../../services/cloudinary_service.dart';
import '../../widgets/user_progress_bar.dart';
import '../../data/user_data.dart';

class ProfilePhotoScreen extends StatefulWidget {
  const ProfilePhotoScreen({super.key});

  @override
  State<ProfilePhotoScreen> createState() => _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends State<ProfilePhotoScreen> {
  static const int maxPhotos = 4;

  final List<Uint8List?> previews = List.generate(maxPhotos, (_) => null);

  /// Dirección de la foto ya subida a internet (Cloudinary).
  final List<String?> imageUrls = List.generate(maxPhotos, (_) => null);

  final List<bool> loading = List.generate(maxPhotos, (_) => false);
  final List<bool> failed = List.generate(maxPhotos, (_) => false);

  /// Ruta local de la foto elegida (para poder reintentar la subida).
  final List<String?> localPaths = List.generate(maxPhotos, (_) => null);

  int get photoCount => imageUrls.where((u) => u != null).length;

  bool get anyLoading => loading.any((l) => l);

  bool get canContinue => photoCount > 0 && !anyLoading;

  @override
  void initState() {
    super.initState();

    // Si regresa a esta pantalla, se muestran las fotos ya subidas.
    final saved = UserData.profile["images"];

    if (saved is List) {
      for (var i = 0; i < saved.length && i < maxPhotos; i++) {
        final url = saved[i].toString();
        if (url.startsWith("http")) imageUrls[i] = url;
      }
    }
  }

  Future<void> upload(int index) async {
    final path = localPaths[index];
    if (path == null) return;

    setState(() {
      loading[index] = true;
      failed[index] = false;
    });

    String? url;

    try {
      url = await CloudinaryService.uploadImage(File(path))
          .timeout(const Duration(seconds: 40));
    } catch (e) {
      debugPrint("Error subiendo foto: $e");
    }

    if (!mounted) return;

    setState(() {
      loading[index] = false;
      if (url == null) {
        failed[index] = true;
      } else {
        imageUrls[index] = url;
      }
    });
  }

  Future<void> pickImage(ImageSource source, int index) async {
    final XFile? pickedFile;

    try {
      pickedFile = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
      );
    } catch (e) {
      debugPrint("Error abriendo cámara o galería: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No se pudo abrir la cámara o la galería."),
        ),
      );
      return;
    }

    if (pickedFile == null) return;

    final bytes = await pickedFile.readAsBytes();
    final path = pickedFile.path;

    if (!mounted) return;

    setState(() {
      previews[index] = bytes;
      localPaths[index] = path;
      imageUrls[index] = null;
    });

    await upload(index);
  }

  void removePhoto(int index) {
    setState(() {
      previews[index] = null;
      imageUrls[index] = null;
      localPaths[index] = null;
      loading[index] = false;
      failed[index] = false;
    });
  }

  bool hasPhoto(int index) =>
      previews[index] != null || imageUrls[index] != null;

  void showPicker(int index) {
    HapticFeedback.selectionClick();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text("Tomar foto"),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.camera, index);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text("Elegir de la galería"),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.gallery, index);
                  },
                ),
                if (hasPhoto(index))
                  ListTile(
                    leading: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    title: const Text(
                      "Quitar foto",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      removePhoto(index);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void goNext() {
    if (anyLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Espera a que termine de subir la foto.")),
      );
      return;
    }

    final validImages = imageUrls.whereType<String>().toList();

    if (validImages.isEmpty) return;

    UserData.updateProfile(images: validImages);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationPermissionScreen(),
      ),
    );
  }

  /// Un espacio de foto. El primero es la foto principal.
  Widget buildPhotoSlot(int index, {bool main = false}) {
    final preview = previews[index];
    final url = imageUrls[index];

    return GestureDetector(
      onTap: () {
        if (failed[index] && localPaths[index] != null) {
          upload(index);
        } else if (!loading[index]) {
          showPicker(index);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(main ? 28 : 22),
          border: Border.all(
            color: hasPhoto(index) ? Colors.transparent : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // FOTO
            if (preview != null || url != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(main ? 28 : 22),
                child: preview != null
                    ? Image.memory(preview, fit: BoxFit.cover)
                    : Image.network(url!, fit: BoxFit.cover),
              )
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: main ? 64 : 44,
                    height: main ? 64 : 44,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: main ? 34 : 24,
                    ),
                  ),
                  if (main) ...[
                    const SizedBox(height: 14),
                    const Text(
                      "Foto principal",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Una donde se vea bien tu cara",
                      style: TextStyle(color: Colors.black45, fontSize: 13),
                    ),
                  ],
                ],
              ),

            // ETIQUETA "PRINCIPAL"
            if (main && hasPhoto(index))
              Positioned(
                left: 14,
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Principal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

            // SUBIENDO
            if (loading[index])
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(main ? 28 : 22),
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),

            // ERROR: TOCAR PARA REINTENTAR
            if (failed[index])
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(main ? 28 : 22),
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh, color: Colors.white, size: 30),
                      SizedBox(height: 6),
                      Text(
                        "No se subió\nToca para reintentar",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),

            // SUBIDA OK
            if (url != null && !loading[index])
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 14, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const UserProgressBar(step: 4),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 40, 28, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.pets,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      "Agrega tus\nfotos",
                      style: TextStyle(
                        fontSize: 34,
                        height: 1.15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Sube al menos 1 y hasta $maxPhotos fotos. Llevas $photoCount de $maxPhotos.",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Foto principal grande
                    AspectRatio(
                      aspectRatio: 1.25,
                      child: buildPhotoSlot(0, main: true),
                    ),
                    const SizedBox(height: 14),

                    // 3 fotos más pequeñas
                    Row(
                      children: [
                        for (var i = 1; i < maxPhotos; i++) ...[
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 0.85,
                              child: buildPhotoSlot(i),
                            ),
                          ),
                          if (i < maxPhotos - 1) const SizedBox(width: 12),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade500,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: canContinue ? goNext : null,
                  child: Text(
                    anyLoading ? "Subiendo foto..." : "Continuar",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
