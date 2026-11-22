import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/cloudinary_service.dart';

enum _S { uploading, ok, failed }

class _Item {
  String? url;
  Uint8List? preview;
  _S state;

  _Item({this.url, this.preview, this.state = _S.ok});
}

/// Administrar fotos (mascota o dueño): sube a Cloudinary, la primera es
/// la principal.
class PhotosManagerPage extends StatefulWidget {
  final String title;
  final String hint;
  final List<String> initial;
  final int max;
  final int minimum;
  final void Function(List<String> urls) onSave;

  const PhotosManagerPage({
    super.key,
    required this.title,
    required this.initial,
    required this.onSave,
    this.hint = "La primera foto es la principal.",
    this.max = 8,
    this.minimum = 1,
  });

  @override
  State<PhotosManagerPage> createState() => _PhotosManagerPageState();
}

class _PhotosManagerPageState extends State<PhotosManagerPage> {
  late final List<_Item> items;

  @override
  void initState() {
    super.initState();
    items = widget.initial.map((u) => _Item(url: u)).toList();
  }

  int get okCount => items.where((i) => i.state == _S.ok).length;
  bool get busy => items.any((i) => i.state == _S.uploading);

  Future<ImageSource?> askSource() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF16161C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined,
                  color: Colors.white),
              title: const Text("Tomar una foto",
                  style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
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
  }

  Future<void> upload(_Item item, XFile picked) async {
    try {
      final url = await CloudinaryService.uploadImage(File(picked.path))
          .timeout(const Duration(seconds: 40));

      if (!mounted) return;

      setState(() {
        if (url == null || url.isEmpty) {
          item.state = _S.failed;
        } else {
          item.url = url;
          item.state = _S.ok;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => item.state = _S.failed);
    }
  }

  Future<void> addPhoto() async {
    if (items.length >= widget.max) return;

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
    final item = _Item(preview: bytes, state: _S.uploading);

    setState(() => items.add(item));

    await upload(item, picked);
  }

  Future<void> menu(int index) async {
    final item = items[index];

    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF16161C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            if (index != 0 && item.state == _S.ok)
              ListTile(
                leading:
                    const Icon(Icons.star_rounded, color: Colors.amber),
                title: const Text("Hacer foto principal",
                    style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context, "main"),
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text("Quitar foto",
                  style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context, "remove"),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );

    if (!mounted) return;

    setState(() {
      if (action == "remove") items.removeAt(index);
      if (action == "main") {
        final moved = items.removeAt(index);
        items.insert(0, moved);
      }
    });
  }

  void save() {
    final urls = <String>[];

    for (final i in items) {
      if (i.state == _S.ok && i.url != null) urls.add(i.url!);
    }

    widget.onSave(urls);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fotos guardadas")),
    );

    Navigator.pop(context);
  }

  Widget photo(_Item item) {
    if (item.preview != null) {
      return Image.memory(item.preview!, fit: BoxFit.cover);
    }

    final url = item.url;

    if (url != null && url.startsWith("http")) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image_outlined, color: Colors.white38),
        ),
      );
    }

    if (url != null) {
      return Image.file(
        File(url),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image_outlined, color: Colors.white38),
        ),
      );
    }

    return const SizedBox();
  }

  Widget itemBox(int index) {
    final item = items[index];

    return GestureDetector(
      onTap: () {
        if (item.state == _S.failed) {
          // Una foto que falló se quita y se vuelve a agregar.
          setState(() => items.removeAt(index));
          addPhoto();
        } else if (item.state == _S.ok) {
          menu(index);
        }
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: index == 0 ? Colors.pinkAccent : Colors.white12,
            width: index == 0 ? 2 : 1,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            photo(item),
            if (item.state == _S.uploading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            if (item.state == _S.failed)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh_rounded,
                          color: Colors.redAccent, size: 30),
                      SizedBox(height: 4),
                      Text("Reintentar",
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            if (index == 0 && item.state == _S.ok)
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Principal",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget addBox() {
    return GestureDetector(
      onTap: addPhoto,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white24),
        ),
        child: const Center(
          child: Icon(Icons.add_a_photo_rounded,
              color: Colors.white70, size: 34),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canAdd = items.length < widget.max;
    final canSave = !busy && okCount >= widget.minimum;

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
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.hint}  (${items.length}/${widget.max})",
                  style: const TextStyle(color: Colors.white54),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: items.length + (canAdd ? 1 : 0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (_, i) {
                  if (i == items.length) return addBox();
                  return itemBox(i);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
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
                  child: Text(
                    busy
                        ? "Subiendo..."
                        : (okCount < widget.minimum
                            ? "Agrega al menos ${widget.minimum}"
                            : "Guardar fotos"),
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
    );
  }
}
