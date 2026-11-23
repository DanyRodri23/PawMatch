import 'package:flutter/material.dart';
import '../helpers/pet_badges.dart';

/// Insignias azules de una mascota:
/// huellita = pedigrí verificado, jeringa = vacunas verificadas.
/// Si no tiene ninguna, no muestra nada.
class PetBadgeRow extends StatelessWidget {
  final Map pet;
  final double size;

  const PetBadgeRow({super.key, required this.pet, this.size = 30});

  Widget badge(IconData icon, Color color) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.9), width: 1.6),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.45),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, size: size * 0.58, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pedigree = PetBadges.pedigreeApproved(pet);
    final vaccine = PetBadges.vaccineApproved(pet);

    if (!pedigree && !vaccine) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (pedigree) badge(Icons.pets, const Color(0xFF1E88E5)),
        if (vaccine) badge(Icons.vaccines, const Color(0xFF29B6F6)),
      ],
    );
  }
}
