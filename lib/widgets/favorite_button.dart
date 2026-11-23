import 'package:flutter/material.dart';

import '../data/favorites_data.dart';

/// Corazón para guardar un parque u hotel en favoritos.
class FavoriteButton extends StatelessWidget {
  final String kind; // "park" | "hotel"
  final Map item;
  final double size;

  const FavoriteButton({
    super.key,
    required this.kind,
    required this.item,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: FavoritesData.version,
      builder: (_, __, ___) {
        final on = FavoritesData.isFavorite(kind, item);
        return GestureDetector(
          onTap: () {
            FavoritesData.toggle(kind, item);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(milliseconds: 1100),
                content: Text(
                  on ? "Quitado de favoritos" : "Guardado en favoritos ❤️",
                ),
              ),
            );
          },
          child: Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: Color(0x99000000),
              shape: BoxShape.circle,
            ),
            child: Icon(
              on ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: on ? Colors.pinkAccent : Colors.white,
              size: size * 0.52,
            ),
          ),
        );
      },
    );
  }
}
