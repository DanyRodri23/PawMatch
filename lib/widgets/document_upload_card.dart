import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/cloudinary_service.dart';

enum _Up { empty, uploading, done, failed }

/// Zona para subir un documento (foto del pedigrí, carnet de vacunas...).
/// Sube la imagen a Cloudinary y avisa con la dirección (URL).
class DocumentUploadCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String hint;
  final String? initialValue;
  final ValueChanged<String> onUploaded;
  final VoidCallback onRemoved;
  final bool dark;

  const DocumentUploadCard({
    super.key,
    required this.icon,
    required this.title,
    required this.hint,
    required this.onUploaded,
    required this.onRemoved,
    this.initialValue,
    this.dark = false,
  });

  @override
  State<DocumentUploadCard> createState() => _DocumentUploadCardState();
}

class _DocumentUploadCardState extends State<DocumentUploadCard> {
  _Up state = _Up.empty;
  Uint8List? preview;
  String? url;

  @override
  void initState() {
    super.initState();

    final saved = widget.initialValue;
    if (saved != null && saved.isNotEmpty) {
      url = saved;
      state = _Up.done;
    }
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

  Future<void> pick() async {
    if (state == _Up.uploading) return;

    final source = await askSource();
    if (source == null || !mounted) return;

    XFile? picked;
    try {
      picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 2000,
      );
    } catch (_) {
      picked = null;
    }

    if (picked == null || !mounted) return;

    final bytes = await picked.readAsBytes();

    setState(() {
      preview = bytes;
      state = _Up.uploading;
    });

    try {
      final result = await CloudinaryService.uploadImage(File(picked.path))
          .timeout(const Duration(seconds: 40));

      if (!mounted) return;

      if (result == null || result.isEmpty) {
        setState(() => state = _Up.failed);
        return;
      }

      setState(() {
        url = result;
        state = _Up.done;
      });

      widget.onUploaded(result);
    } catch (_) {
      if (!mounted) return;
      setState(() => state = _Up.failed);
    }
  }

  void remove() {
    setState(() {
      url = null;
      preview = null;
      state = _Up.empty;
    });

    widget.onRemoved();
  }

  Widget body() {
    switch (state) {
      case _Up.uploading:
        return Stack(
          fit: StackFit.expand,
          children: [
            if (preview != null) Image.memory(preview!, fit: BoxFit.cover),
            Container(color: Colors.black.withValues(alpha: 0.5)),
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 12),
                  Text(
                    "Subiendo...",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      case _Up.done:
        final network = url != null && url!.startsWith("http");

        return Stack(
          fit: StackFit.expand,
          children: [
            if (preview != null)
              Image.memory(preview!, fit: BoxFit.cover)
            else if (network)
              Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.description_outlined, size: 48),
                ),
              )
            else
              const Center(child: Icon(Icons.description_outlined, size: 48)),
            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 5),
                    Text(
                      "Cargado",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: GestureDetector(
                onTap: remove,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        );

      case _Up.failed:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 40, color: Colors.red.shade400),
              const SizedBox(height: 10),
              Text(
                "No se pudo subir",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: widget.dark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Toca para intentarlo otra vez",
                style: TextStyle(
                  color: widget.dark ? Colors.white54 : Colors.black54,
                ),
              ),
            ],
          ),
        );

      case _Up.empty:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: widget.dark ? Colors.pink : Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.icon, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 14),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: widget.dark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.hint,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.dark ? Colors.white54 : Colors.black54,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: state == _Up.done ? null : pick,
      child: Container(
        height: 210,
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: widget.dark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: state == _Up.done
                ? Colors.green
                : (widget.dark ? Colors.white24 : Colors.grey.shade300),
            width: 1.5,
          ),
        ),
        child: body(),
      ),
    );
  }
}
