import 'package:flutter/material.dart';

/// Foto de perfil con un anillo que muestra el % completado.
class ProfileRingAvatar extends StatelessWidget {
  final String? photoUrl;
  final int percent;
  final double size;

  const ProfileRingAvatar({
    super.key,
    required this.photoUrl,
    required this.percent,
    this.size = 112,
  });

  @override
  Widget build(BuildContext context) {
    final url = photoUrl;
    final hasPhoto = url != null && url.startsWith("http");

    return SizedBox(
      width: size,
      height: size + 12,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: percent / 100),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, v, _) => CircularProgressIndicator(
                value: v,
                strokeWidth: 5,
                backgroundColor: Colors.white12,
                color: Colors.pinkAccent,
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9),
            child: CircleAvatar(
              radius: size / 2 - 9,
              backgroundColor: const Color(0xFF1E1E26),
              backgroundImage: hasPhoto ? NetworkImage(url) : null,
              child: hasPhoto
                  ? null
                  : const Icon(Icons.pets, color: Colors.white38, size: 38),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF0B0B0F), width: 3),
              ),
              child: Text(
                "$percent%",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
