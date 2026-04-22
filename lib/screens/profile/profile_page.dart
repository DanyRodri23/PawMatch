import 'package:flutter/material.dart';
import '../../data/pet_profile_data.dart';
import 'edit_profile_pro_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {

  final PageController planController =
      PageController(viewportFraction: 0.92);

  @override
  Widget build(BuildContext context) {
    final pet = PetProfileData.pet;

    final List images =
        pet["images"] ?? [];

    final String photo =
        images.isNotEmpty
            ? images[0]
            : "https://placedog.net/500";

    final String name =
        pet["name"] ?? "Mascota";

    final int age =
        pet["age"] ?? 0;

    return Scaffold(
      backgroundColor:
          const Color(0xFF0B0B0F),

      body: SafeArea(
        child:
            SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            18,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                children: [

                  CircleAvatar(
                    radius: 34,
                    backgroundImage:
                        NetworkImage(
                      photo,
                    ),
                  ),

                  const SizedBox(
                      width: 14),

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
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                            height:
                                4),

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

                  _circleButton(
                    Icons.settings,
                  ),
                ],
              ),

              const SizedBox(
                  height: 18),

              /// EDITAR
              SizedBox(
                width:
                    double.infinity,
                child:
                    ElevatedButton.icon(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.white,
                    foregroundColor:
                        Colors.black,
                    padding:
                        const EdgeInsets.symmetric(
                      vertical:
                          16,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        40,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                const EditProfileProPage(),
                      ),
                    ).then(
                      (_) {
                        setState(
                            () {});
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.edit,
                  ),
                  label: const Text(
                    "Editar perfil",
                    style:
                        TextStyle(
                      fontSize:
                          18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                  height: 22),

              /// PROGRESO
              _glassCard(
                child: Column(
                  children: [

                    Row(
                      children: const [

                        Expanded(
                          child: Text(
                            "78% completado",
                            style:
                                TextStyle(
                              color:
                                  Colors.white,
                              fontSize:
                                  18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        Text(
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
                        height:
                            12),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                      child:
                          const LinearProgressIndicator(
                        value:
                            0.78,
                        minHeight:
                            10,
                        backgroundColor:
                            Colors.white12,
                        valueColor:
                            AlwaysStoppedAnimation(
                          Colors.pink,
                        ),
                      ),
                    ),

                    const SizedBox(
                        height:
                            10),

                    const Text(
                      "Completa tu perfil para más matches.",
                      style:
                          TextStyle(
                        color:
                            Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                  height: 22),

              const Text(
                "Planes Premium",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                  height: 14),

              /// PLANES DESLIZABLES
              SizedBox(
                height: 330,
                child: PageView(
                  controller:
                      planController,
                  children: [

                    _planBasic(),

                    _planGold(),

                    _planPlatinum(),
                  ],
                ),
              ),

              const SizedBox(
                  height: 22),

              Row(
                children: [

                  Expanded(
                    child: _statBox(
                      "Likes",
                      "12",
                      Colors.pink,
                    ),
                  ),

                  const SizedBox(
                      width: 10),

                  Expanded(
                    child: _statBox(
                      "Matches",
                      "6",
                      Colors.amber,
                    ),
                  ),

                  const SizedBox(
                      width: 10),

                  Expanded(
                    child: _statBox(
                      "Boost",
                      "2",
                      Colors.blue,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                  height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _planBasic() {
    return _premiumCard(
      colors: const [
        Color(0xFF1565C0),
        Color(0xFF42A5F5),
      ],
      title: "🐾 PawMatch Basic",
      price: "Gratis",
      items: [
        "Likes limitados",
        "Matches normales",
        "Perfil visible",
        "Chat básico",
      ],
    );
  }

  Widget _planGold() {
    return _premiumCard(
      colors: const [
        Color(0xFFFFC107),
        Color(0xFFFFE082),
      ],
      title: "👑 PawMatch Gold",
      price: "₡4,990",
      items: [
        "Descubre quién te dio like",
        "Top Picks diarios",
        "Super Like gratis",
        "1 Boost mensual",
      ],
    );
  }

  Widget _planPlatinum() {
    return _premiumCard(
      colors: const [
        Color(0xFF9E9E9E),
        Color(0xFFE0E0E0),
      ],
      title: "💎 PawMatch Platinum",
      price: "₡8,990",
      items: [
        "Like prioritario",
        "Mensaje antes del match",
        "Ver quién te dio like",
        "Descuento veterinarias",
        "Descuento hospitales pets",
      ],
    );
  }

  Widget _premiumCard({
    required List<Color> colors,
    required String title,
    required String price,
    required List<String> items,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(
        right: 10,
      ),
      padding:
          const EdgeInsets.all(
        22,
      ),
      decoration:
          BoxDecoration(
        gradient:
            LinearGradient(
          colors: colors,
          begin:
              Alignment.topLeft,
          end: Alignment
              .bottomRight,
        ),
        borderRadius:
            BorderRadius.circular(
          28,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style:
                const TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(
              height: 6),

          Text(
            price,
            style:
                const TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(
              height: 18),

          ...items.map(
            (e) => Padding(
              padding:
                  const EdgeInsets.only(
                bottom: 10,
              ),
              child: Text(
                "✔ $e",
                style:
                    const TextStyle(
                  fontSize: 16,
                  color:
                      Colors.black87,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ),
          ),

          const Spacer(),

          Container(
            width:
                double.infinity,
            padding:
                const EdgeInsets.symmetric(
              vertical: 14,
            ),
            decoration:
                BoxDecoration(
              color:
                  Colors.black,
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),
            child: const Center(
              child: Text(
                "Elegir plan",
                style:
                    TextStyle(
                  color:
                      Colors.white,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(
        18,
      ),
      decoration:
          BoxDecoration(
        color: const Color(
          0xFF16161C,
        ),
        borderRadius:
            BorderRadius.circular(
          26,
        ),
        border: Border.all(
          color:
              Colors.white10,
        ),
      ),
      child: child,
    );
  }

  Widget _circleButton(
    IconData icon,
  ) {
    return Container(
      width: 50,
      height: 50,
      decoration:
          const BoxDecoration(
        color: Color(
          0xFF16161C,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  Widget _statBox(
    String title,
    String value,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(
        16,
      ),
      decoration:
          BoxDecoration(
        color: const Color(
          0xFF16161C,
        ),
        borderRadius:
            BorderRadius.circular(
          22,
        ),
      ),
      child: Column(
        children: [

          Text(
            value,
            style:
                TextStyle(
              color: color,
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
              height: 6),

          Text(
            title,
            style:
                const TextStyle(
              color:
                  Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}