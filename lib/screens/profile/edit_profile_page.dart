import 'dart:ui';
import 'package:flutter/material.dart';
import 'edit_pet_profile_page.dart';
import 'edit_user_profile_page.dart';

class EditProfileSelectorPage extends StatelessWidget {
  const EditProfileSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [

          /// 🔥 FONDO GRADIENT PRO
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Editar perfil",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// TARJETA MASCOTA
                  _premiumCard(
                    context,
                    icon: Icons.pets,
                    title: "Perfil de tu mascota",
                    subtitle: "Editar info, fotos y personalidad",
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditPetProfilePage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 25),

                  /// TARJETA USUARIO
                  _premiumCard(
                    context,
                    icon: Icons.person,
                    title: "Perfil del propietario",
                    subtitle: "Fotos, verificación y seguridad",
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditUserProfilePage(),
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 💎 CARD PRO (GLASS + SHADOW + ANIMACIÓN)
  Widget _premiumCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Row(
              children: [

                /// ICONO PRO
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),

                const SizedBox(width: 15),

                /// TEXTO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text(subtitle,
                          style:
                              const TextStyle(color: Colors.white54)),
                    ],
                  ),
                ),

                /// FLECHA
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.white30, size: 16)
              ],
            ),
          ),
        ),
      ),
    );
  }
}