import 'package:flutter/material.dart';

import '../../data/user_profile_data.dart';
import '../../data/sample_pets.dart';
import '../../helpers/age_helper.dart';
import '../../helpers/pet_badges.dart';
import '../../widgets/pet_badge_row.dart';
import '../profile/owner_profile_sheet.dart';
import '../profile/preview_owner_sheet.dart';
import 'gallery_viewer_screen.dart';

/// Perfil completo de una mascota.
/// Se usa tanto para ver a otras mascotas como para la "Vista previa" de la
/// propia (preview = true), así lo que ves es lo que ven los demás.
class PetDetailScreen extends StatefulWidget {
  final Map<String, dynamic> pet;
  final bool preview;

  const PetDetailScreen({super.key, required this.pet, this.preview = false});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  static const Color bg = Color(0xFF0B0B0F);
  static const Color card = Color(0xFF16161C);

  int photo = 0;

  Map<String, dynamic> get pet =>
      widget.preview ? widget.pet : SamplePets.full(widget.pet);

  String s(String k) => (pet[k] ?? "").toString();

  List<String> list(String k) =>
      pet[k] is List ? (pet[k] as List).map((e) => e.toString()).toList() : [];

  @override
  Widget build(BuildContext context) {
    final images = list("images");
    final name = s("name").isEmpty ? "Mascota" : s("name");
    final hideAge = pet["hideAge"] == true;
    final hideDistance = pet["hideDistance"] == true;

    String ageText = "";
    final a = pet["age"];
    if (a is num && !hideAge) {
      ageText = AgeHelper.petAgeText(
        a.toInt(),
        s("ageType").isEmpty ? "años" : s("ageType"),
      );
    }

    String place = s("distance");
    if (place.isEmpty) place = s("location");
    if (hideDistance) place = "";

    final breed = s("breed");
    final gender = s("gender");
    final goal = s("lookingFor").isNotEmpty ? s("lookingFor") : s("goal");
    final size = s("size");
    final energy = s("energy");
    final neutered = s("neutered");
    final goodWith = list("goodWith");
    final traits = list("traits");
    final desc = s("description");

    final vacc = PetBadges.vaccineApproved(pet);
    final pedi = PetBadges.pedigreeApproved(pet);
    final isPure = pet["isPureBreed"] == true || pet["pedigree"] == true;

    final h = MediaQuery.of(context).size.height;
    final heroH = h * 0.58;

    final facts = <List<dynamic>>[
      if (gender.isNotEmpty)
        [gender == "Hembra" ? Icons.female_rounded : Icons.male_rounded, gender],
      if (breed.isNotEmpty) [Icons.pets, breed],
      if (size.isNotEmpty) [Icons.straighten_rounded, size],
      if (energy.isNotEmpty) [Icons.bolt_rounded, energy],
    ];

    final details = <List<String>>[
      if (goal.isNotEmpty) ["🎾", "Busca", goal],
      if (ageText.isNotEmpty) ["🎂", "Edad", ageText],
      if (neutered.isNotEmpty) ["✂️", "Esterilizado", neutered],
      if (goodWith.isNotEmpty) ["🤝", "Se lleva bien con", goodWith.join(", ")],
    ];

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            children: [
              // ---------- fotos
              SizedBox(
                height: heroH,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (images.isEmpty)
                      Container(
                        color: card,
                        child: const Icon(Icons.pets,
                            color: Colors.white24, size: 80),
                      )
                    else
                      PageView.builder(
                        itemCount: images.length,
                        onPageChanged: (i) => setState(() => photo = i),
                        itemBuilder: (_, i) => GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GalleryViewerScreen(
                                images: images,
                                initialIndex: i,
                              ),
                            ),
                          ),
                          child: Image.network(
                            images[i],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: card,
                              child: const Icon(Icons.pets,
                                  color: Colors.white24, size: 80),
                            ),
                          ),
                        ),
                      ),
                    IgnorePointer(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0, 0.35, 1],
                            colors: [
                              Color(0x99000000),
                              Color(0x00000000),
                              Color(0xFF0B0B0F),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // indicadores de foto
                    if (images.length > 1)
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        left: 70,
                        right: 70,
                        child: Row(
                          children: List.generate(
                            images.length,
                            (i) => Expanded(
                              child: Container(
                                height: 4,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: i == photo
                                      ? Colors.white
                                      : Colors.white38,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // nombre
                    Positioned(
                      left: 22,
                      right: 22,
                      bottom: 18,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  ageText.isEmpty ? name : "$name, $ageText",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 34,
                                    fontWeight: FontWeight.w800,
                                    height: 1.05,
                                  ),
                                ),
                              ),
                              PetBadgeRow(pet: pet, size: 28),
                            ],
                          ),
                          if (place.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded,
                                    color: Colors.white70, size: 18),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    place,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ---------- contenido
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (facts.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final f in facts) _fact(f[0] as IconData, f[1] as String),
                        ],
                      ),

                    if (desc.isNotEmpty) ...[
                      _title("Sobre $name"),
                      _box(
                        child: Text(
                          desc,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],

                    if (traits.isNotEmpty) ...[
                      _title("Personalidad"),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final t in traits)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 9),
                              decoration: BoxDecoration(
                                color:
                                    Colors.pinkAccent.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: Colors.pinkAccent
                                      .withValues(alpha: 0.35),
                                ),
                              ),
                              child: Text(
                                t,
                                style: const TextStyle(
                                  color: Color(0xFFFF9CC4),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],

                    if (details.isNotEmpty) ...[
                      _title("Detalles"),
                      _box(
                        pad: 0,
                        child: Column(
                          children: [
                            for (int i = 0; i < details.length; i++) ...[
                              _row(details[i][0], details[i][1], details[i][2]),
                              if (i != details.length - 1)
                                const Divider(
                                    color: Colors.white10,
                                    height: 1,
                                    indent: 54),
                            ],
                          ],
                        ),
                      ),
                    ],

                    _title("Certificados"),
                    _box(
                      pad: 0,
                      child: Column(
                        children: [
                          _cert("Vacunas al día", Icons.vaccines_rounded, vacc),
                          if (isPure) ...[
                            const Divider(
                                color: Colors.white10, height: 1, indent: 54),
                            _cert("Pedigrí", Icons.pets, pedi),
                          ],
                        ],
                      ),
                    ),

                    if (images.length > 1) ...[
                      _title("Galería"),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (_, i) => GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GalleryViewerScreen(
                                  images: images,
                                  initialIndex: i,
                                ),
                              ),
                            ),
                            child: Container(
                              width: 100,
                              margin: const EdgeInsets.only(right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.network(images[i],
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],

                    _title("Dueño"),
                    _ownerCard(),

                    SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 40),
                  ],
                ),
              ),
            ],
          ),

          // botón atrás
          Positioned(
            top: MediaQuery.of(context).padding.top + 6,
            left: 14,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0x88000000),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 18),
              ),
            ),
          ),

          // aviso de vista previa
          if (widget.preview)
            Positioned(
              top: MediaQuery.of(context).padding.top + 6,
              right: 14,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.pinkAccent,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Text(
                  "Así te ven los demás",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------- piezas

  Widget _title(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(2, 28, 2, 12),
        child: Text(
          t,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
      );

  Widget _box({required Widget child, double pad = 18}) => Container(
        width: double.infinity,
        padding: EdgeInsets.all(pad),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white10),
        ),
        child: child,
      );

  Widget _fact(IconData icon, String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFF22222A),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 17),
            const SizedBox(width: 7),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );

  Widget _row(String emoji, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 5,
              child: Text(label,
                  style:
                      const TextStyle(color: Colors.white60, fontSize: 15)),
            ),
            Expanded(
              flex: 6,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _cert(String label, IconData icon, bool ok) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: ok ? Colors.blue : Colors.white12,
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: ok ? Colors.white : Colors.white38, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: const TextStyle(color: Colors.white, fontSize: 15.5)),
            ),
            Text(
              ok ? "Verificado ✓" : "Sin verificar",
              style: TextStyle(
                color: ok ? Colors.lightBlueAccent : Colors.white38,
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      );

  Widget _ownerCard() {
    final user = UserProfileData.user;
    final uImgs = user["images"] is List ? user["images"] as List : [];
    final uImg = uImgs.isNotEmpty ? uImgs.first.toString() : "";
    final uName = (user["name"] ?? "Usuario").toString();
    final verified = user["verified"] == true;

    return GestureDetector(
      onTap: () => widget.preview
          ? showPreviewOwnerSheet(context)
          : showOwnerProfileSheet(context),
      child: _box(
        pad: 16,
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey.shade800,
              backgroundImage:
                  uImg.startsWith("http") ? NetworkImage(uImg) : null,
              child: uImg.startsWith("http")
                  ? null
                  : const Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          uName,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (verified)
                        const Padding(
                          padding: EdgeInsets.only(left: 6),
                          child: Icon(Icons.verified,
                              color: Colors.blue, size: 18),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    "Toca para ver su perfil",
                    style: TextStyle(color: Colors.lightBlueAccent, fontSize: 12.5),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_up, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
