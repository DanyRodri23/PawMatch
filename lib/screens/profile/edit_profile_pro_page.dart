import 'package:flutter/material.dart';
import '../../data/pet_profile_data.dart';
import 'edit_pet_profile_page.dart';
import 'edit_user_profile_page.dart';
import 'profile_preview_screen.dart';
import 'verification_screen.dart';

class EditProfileProPage extends StatefulWidget {
  const EditProfileProPage({super.key});

  @override
  State<EditProfileProPage> createState() =>
      _EditProfileProPageState();
}

class _EditProfileProPageState
    extends State<EditProfileProPage> {

  int profilePercent = 78;

  @override
  Widget build(BuildContext context) {
    final pet = PetProfileData.pet;
    final images = pet["images"] ?? [];

    final name = pet["name"] ?? "Max";
    final age = pet["age"] ?? 2;

    final mainImage = images.isNotEmpty
        ? images[0]
        : "https://images.unsplash.com/photo-1583511655826-05700442b31b";

    return Scaffold(
      backgroundColor:
          const Color(0xFF050505),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),
          child: Column(
            children: [

              /// TOP BAR NUEVA
              Row(
                children: [

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration:
                          const BoxDecoration(
                        color:
                            Colors.white10,
                        shape:
                            BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color:
                            Colors.white,
                        size: 18,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Text(
                      "Gestionar perfil",
                      style: TextStyle(
                        color:
                            Colors.white,
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  _roundIcon(
                    Icons.settings,
                    () {},
                  ),
                ],
              ),

              const SizedBox(height: 22),

              /// HEADER PERFIL
              Row(
                children: [

                  CircleAvatar(
                    radius: 34,
                    backgroundImage:
                        NetworkImage(
                      mainImage,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [

                        Text(
                          "$name, $age",
                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                            fontSize: 28,
                            fontWeight:
                                FontWeight.w900,
                          ),
                        ),

                        const SizedBox(
                            height: 4),

                        const Text(
                          "Perfil PawMatch",
                          style:
                              TextStyle(
                            color:
                                Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              /// QUITAMOS BOTON EDITAR GRANDE
              /// YA NO HAY DOBLE EDITAR

              _glassCard(
                child: Column(
                  children: [

                    Row(
                      children: [

                        Text(
                          "$profilePercent% completado",
                          style:
                              const TextStyle(
                            color:
                                Colors.white,
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        const Text(
                          "Sube más",
                          style:
                              TextStyle(
                            color:
                                Colors.pink,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                        height: 16),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                      child:
                          LinearProgressIndicator(
                        minHeight: 9,
                        value:
                            profilePercent /
                                100,
                        backgroundColor:
                            Colors.white10,
                        valueColor:
                            const AlwaysStoppedAnimation(
                          Colors.pink,
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 14),

                    const Text(
                      "Completa tu perfil para recibir más matches.",
                      style:
                          TextStyle(
                        color:
                            Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              _taskCard(
                icon:
                    Icons.health_and_safety,
                title:
                    "Agregar vacunas",
                bonus:
                    "+10%",
              ),

              const SizedBox(height: 14),

              _taskCard(
                icon:
                    Icons.verified,
                title:
                    "Verificar pedigree",
                bonus:
                    "+15%",
              ),

              const SizedBox(height: 14),

              _taskCard(
                icon:
                    Icons.photo_camera,
                title:
                    "Subir más fotos",
                bonus:
                    "+12%",
              ),

              const SizedBox(height: 24),

              /// ACCESOS
              Row(
                children: [

                  Expanded(
                    child: _miniAction(
                      "Mascota",
                      Icons.pets,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const EditPetProfilePage(),
                          ),
                        ).then((_) {
                          setState(() {});
                        });
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _miniAction(
                      "Dueño",
                      Icons.person,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const EditUserProfilePage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [

                  Expanded(
                    child: _miniAction(
                      "Vista previa",
                      Icons.remove_red_eye,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProfilePreviewScreen(
                              pet:
                                  PetProfileData.pet,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _miniAction(
                      "Verificado",
                      Icons.verified_user,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const VerificationScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roundIcon(
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration:
            const BoxDecoration(
          color: Colors.white10,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _glassCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.05,
        ),
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        border: Border.all(
          color:
              Colors.white10,
        ),
      ),
      child: child,
    );
  }

  Widget _taskCard({
    required IconData icon,
    required String title,
    required String bonus,
  }) {
    return _glassCard(
      child: Row(
        children: [

          Container(
            width: 54,
            height: 54,
            decoration:
                BoxDecoration(
              color: Colors.pink
                  .withValues(
                alpha: 0.15,
              ),
              shape:
                  BoxShape.circle,
            ),
            child: Icon(
              icon,
              color:
                  Colors.pink,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style:
                  const TextStyle(
                color:
                    Colors.white,
                fontSize: 17,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),

          Text(
            bonus,
            style:
                const TextStyle(
              color:
                  Colors.pink,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniAction(
    String text,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        decoration:
            BoxDecoration(
          color: Colors.white10,
          borderRadius:
              BorderRadius.circular(
            22,
          ),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,
          children: [

            Icon(
              icon,
              color:
                  Colors.white,
            ),

            const SizedBox(
                height: 8),

            Text(
              text,
              style:
                  const TextStyle(
                color:
                    Colors.white,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}