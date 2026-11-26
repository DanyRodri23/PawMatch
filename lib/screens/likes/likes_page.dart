import '../../helpers/age_helper.dart';
import 'package:flutter/material.dart';

import '../../data/likes_data.dart';
import '../../data/matches_data.dart';
import '../../data/pet_profile_data.dart';
import '../../services/discover_service.dart';
import '../match/match_success_screen.dart';
import '../match/pet_detail_screen.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  static const Color _bg = Color(0xFF0B0B0F);
  static const Color _pink = Color(0xFFF6B8E6);

  String sort = "Recomendado";

  String _img(Map<String, dynamic> pet) {
    final images = pet["images"];
    if (images is List && images.isNotEmpty) return "${images[0]}";
    return "";
  }

  List<Map<String, dynamic>> get _likes {
    final list = [...LikesData.receivedLikes];
    if (sort == "Más reciente") return list.reversed.toList();
    return list;
  }

  void _pass(Map<String, dynamic> pet) {
    setState(() => LikesData.removeReceivedLike(pet));
    DiscoverService.swipe("${pet["id"]}", liked: false);
  }

  void _likeBack(Map<String, dynamic> pet) {
    LikesData.removeReceivedLike(pet);
    MatchesData.createMatch(pet);
    DiscoverService.swipe("${pet["id"]}", liked: true);
    final img = _img(pet);
    setState(() {});
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MatchSuccessScreen(
          matchPet: pet,
          myPet: (PetProfileData.pet["name"] ?? "").toString().isEmpty
              ? "Tu mascota"
              : PetProfileData.pet["name"].toString(),
          otherPet: "${pet["name"]}",
          image1: (PetProfileData.pet["images"] is List &&
                  (PetProfileData.pet["images"] as List).isNotEmpty)
              ? (PetProfileData.pet["images"] as List).first.toString()
              : img,
          image2: img,
        ),
      ),
    );
  }

  void _open(Map<String, dynamic> pet) async {
    // Mismo perfil que se ve en Descubre; abajo salen los botones de No / Me gusta.
    await PetDetailScreen.open(
      context,
      pet,
      heroTag: "petphoto_${pet["id"] ?? pet["name"]}",
      onNope: () {
        LikesData.removeReceivedLike(pet);
        DiscoverService.swipe("${pet["id"]}", liked: false);
        if (mounted) setState(() {});
      },
      onLike: () => _likeBack(pet),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final likes = _likes;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  const Text(
                    "Likes",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF26262C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${likes.length}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: ["Recomendado", "Más reciente"].map((t) {
                  final sel = sort == t;
                  return GestureDetector(
                    onTap: () => setState(() => sort = t),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: sel ? Colors.white : const Color(0xFF26262C),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Text(
                        t,
                        style: TextStyle(
                          color: sel ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: likes.isEmpty
                  ? _empty()
                  : ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(20, 8, 20, bottom + 24),
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "Hace match con tu vibra",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        _featured(likes.first),
                        if (likes.length > 1) ...[
                          const Padding(
                            padding: EdgeInsets.only(top: 26, bottom: 14),
                            child: Text(
                              "Más mascotas interesadas en ti",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: likes.length - 1,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.72,
                            ),
                            itemBuilder: (_, i) => _gridCard(likes[i + 1]),
                          ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _empty() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 72, color: Colors.white24),
            SizedBox(height: 18),
            Text(
              "Aún no tienes likes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Sigue explorando: cuando alguien le dé like a tu mascota aparecerá aquí.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featured(Map<String, dynamic> pet) {
    final img = _img(pet);
    return GestureDetector(
      onTap: () => _open(pet),
      child: AspectRatio(
        aspectRatio: 0.82,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (img.isNotEmpty)
                Image.network(
                  img,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFF16161C)),
                )
              else
                Container(color: const Color(0xFF16161C)),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment(0, -0.1),
                    colors: [Color(0xF2000000), Colors.transparent],
                  ),
                ),
              ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Dio like a tu mascota",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${pet["name"]}, ${AgeHelper.shortOf(pet)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if ((pet["breed"] ?? "").toString().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: _pink,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${pet["breed"]}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _round(Icons.close_rounded, Colors.white, 62,
                            () => _pass(pet)),
                        const SizedBox(width: 20),
                        _round(Icons.favorite_rounded, Colors.pinkAccent, 62,
                            () => _likeBack(pet)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _round(IconData icon, Color color, double size, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withValues(alpha: 0.5),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }

  Widget _gridCard(Map<String, dynamic> pet) {
    final img = _img(pet);
    return GestureDetector(
      onTap: () => _open(pet),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (img.isNotEmpty)
              Image.network(
                img,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Container(color: const Color(0xFF16161C)),
              )
            else
              Container(color: const Color(0xFF16161C)),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Color(0xE6000000), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                  color: Colors.pinkAccent,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite,
                    color: Colors.white, size: 15),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${pet["name"]}, ${AgeHelper.shortOf(pet)}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "${pet["breed"] ?? pet["distance"] ?? ""}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
