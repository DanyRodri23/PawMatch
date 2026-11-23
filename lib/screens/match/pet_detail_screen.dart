import 'package:flutter/material.dart';

import '../../data/user_profile_data.dart';
import '../../data/pet_options.dart';
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

  /// Si se pasan, aparecen los botones ✕ ★ ❤ flotando abajo (como en Tinder).
  final VoidCallback? onNope;
  final VoidCallback? onLike;

  /// Para que la foto "viaje" desde la tarjeta hasta aquí.
  final String? heroTag;
  final int initialPhoto;

  const PetDetailScreen({
    super.key,
    required this.pet,
    this.preview = false,
    this.onNope,
    this.onLike,
    this.heroTag,
    this.initialPhoto = 0,
  });

  /// Abre el perfil subiendo desde abajo, como si la tarjeta se expandiera.
  static Future<void> open(
    BuildContext context,
    Map<String, dynamic> pet, {
    VoidCallback? onNope,
    VoidCallback? onLike,
    bool preview = false,
    String? heroTag,
    int initialPhoto = 0,
  }) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 420),
        reverseTransitionDuration: const Duration(milliseconds: 340),
        pageBuilder: (_, __, ___) => PetDetailScreen(
          pet: pet,
          preview: preview,
          onNope: onNope,
          onLike: onLike,
          initialPhoto: initialPhoto,
        ),
        // La pantalla se anima sola (foto fija, información subiendo).
        transitionsBuilder: (_, anim, __, child) => child,
      ),
    );
  }

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  static const Color bg = Color(0xFF0B0B0F);
  static const Color card = Color(0xFF16161C);

  late int photo = widget.initialPhoto;
  late final PageController pageCtrl =
      PageController(initialPage: widget.initialPhoto);

  @override
  void dispose() {
    pageCtrl.dispose();
    super.dispose();
  }

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
    final size_ = s("size");
    final energy = s("energy");
    final neutered = s("neutered");
    final goodWith = list("goodWith");
    final traits = list("traits");
    final desc = s("description");

    final vacc = PetBadges.vaccineApproved(pet);
    final pedi = PetBadges.pedigreeApproved(pet);
    final isPure = pet["isPureBreed"] == true || pet["pedigree"] == true;

    final size = MediaQuery.of(context).size;
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;
    final headerH = topPad + 66;
    // la foto se ve casi completa (igual que en la tarjeta); abajo asoma la info
    final photoH = size.height - botPad - 96;
    final hasActions = widget.onLike != null || widget.onNope != null;

    final essentials = <List<dynamic>>[
      if (place.isNotEmpty) [Icons.location_on_outlined, place],
      if (breed.isNotEmpty) [Icons.pets, breed],
      if (gender.isNotEmpty)
        [
          gender == "Hembra" ? Icons.female_rounded : Icons.male_rounded,
          gender
        ],
      if (ageText.isNotEmpty) [Icons.cake_outlined, ageText],
      if (size_.isNotEmpty) [Icons.straighten_rounded, "Tamaño $size_"],
      if (energy.isNotEmpty) [Icons.bolt_rounded, "Energía: $energy"],
      if (neutered.isNotEmpty)
        [
          Icons.content_cut_rounded,
          neutered == "Sí" ? "Esterilizado" : "No esterilizado"
        ],
    ];

    final facts = <List<dynamic>>[
      if (gender.isNotEmpty)
        [gender == "Hembra" ? Icons.female_rounded : Icons.male_rounded, gender],
      if (breed.isNotEmpty) [Icons.pets, breed],
      if (size_.isNotEmpty) [Icons.straighten_rounded, size_],
      if (energy.isNotEmpty) [Icons.bolt_rounded, energy],
    ];

    final details = <List<String>>[
      if (place.isNotEmpty) ["📍", "Ubicación", place],
      if (goal.isNotEmpty) ["🎾", "Busca", goal],
      if (ageText.isNotEmpty) ["🎂", "Edad", ageText],
      if (neutered.isNotEmpty) ["✂️", "Esterilizado", neutered],
      if (goodWith.isNotEmpty) ["🤝", "Se lleva bien con", goodWith.join(", ")],
    ];

    final anim = ModalRoute.of(context)?.animation ?? kAlwaysCompleteAnimation;

    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) {
        final t = Curves.easeOutQuart.transform(anim.value.clamp(0.0, 1.0));
        final fade = ((anim.value - 0.05) / 0.35).clamp(0.0, 1.0);

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // fondo negro que aparece (deja ver la tarjeta al inicio)
              Positioned.fill(
                child: Container(color: Colors.black.withValues(alpha: fade)),
              ),

              ListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  // ---------- foto: se queda igual, solo se recorta
                  Transform.translate(
                    offset: Offset.zero,
                    child: SizedBox(
                      height: photoH,
                      child: ClipRect(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            OverflowBox(
                              // al abrir se acomoda: de pantalla completa a
                              // un cuadro donde se ve bien toda la cara
                              alignment: Alignment.topCenter,
                              minHeight: size.height,
                              maxHeight: size.height,
                              child: images.isEmpty
                                  ? Container(
                                      color: card,
                                      child: const Icon(Icons.pets,
                                          color: Colors.white24, size: 80),
                                    )
                                  : PageView.builder(
                                      controller: pageCtrl,
                                      itemCount: images.length,
                                      onPageChanged: (i) =>
                                          setState(() => photo = i),
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
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                            color: card,
                                            child: const Icon(Icons.pets,
                                                color: Colors.white24,
                                                size: 80),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            if (images.length > 1)
                              Positioned(
                                top: headerH + 8,
                                left: 0,
                                right: 0,
                                child: IgnorePointer(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      images.length,
                                      (i) => AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 250),
                                        width: i == photo ? 20 : 12,
                                        height: 4,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 2.5),
                                        decoration: BoxDecoration(
                                          color: i == photo
                                              ? Colors.white
                                              : Colors.white
                                                  .withValues(alpha: 0.4),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (widget.preview)
                              Positioned(
                                left: 14,
                                bottom: 14,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 9),
                                  decoration: BoxDecoration(
                                    color: Colors.pinkAccent,
                                    borderRadius: BorderRadius.circular(20),
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
                      ),
                    ),
                  ),

                  // ---------- información: sube desde abajo
                  Transform.translate(
                    offset: Offset(0, (1 - t) * (size.height - photoH + 60)),
                    child: Opacity(
                      opacity: 1,
                      child: Column(
                        children: [
                          const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (goal.isNotEmpty)
                            _tCard(
                              Icons.search_rounded,
                              "Busco",
                              Row(
                                children: [
                                  Text(_goalEmoji(goal),
                                      style: const TextStyle(fontSize: 30)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      goal,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 23,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (desc.isNotEmpty)
                            _tCard(
                              Icons.pets,
                              "Sobre mí",
                              Text(
                                desc,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          if (essentials.isNotEmpty)
                            _tCard(
                              Icons.person_pin_circle_outlined,
                              "Esenciales",
                              LayoutBuilder(
                                builder: (context, c) {
                                  final w = (c.maxWidth - 10) / 2;
                                  return Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: [
                                      for (final r in essentials)
                                        Container(
                                          width: r[1].toString().length > 22
                                              ? c.maxWidth
                                              : w,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 13),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1F1C1C),
                                            borderRadius:
                                                BorderRadius.circular(14),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(r[0] as IconData,
                                                  color: Colors.white70,
                                                  size: 20),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  r[1] as String,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14.5,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          if (traits.isNotEmpty)
                            _tCard(
                              Icons.emoji_emotions_outlined,
                              "Personalidad",
                              _chips(traits),
                            ),
                          if (goodWith.isNotEmpty)
                            _tCard(
                              Icons.handshake_outlined,
                              "Se lleva bien con",
                              _chips(goodWith),
                            ),
                          _tCard(
                            Icons.verified_outlined,
                            "Certificados",
                            Column(
                              children: [
                                _cert("Vacunas al día", Icons.vaccines_rounded,
                                    vacc),
                                if (isPure) ...[
                                  const Divider(
                                      color: Colors.white10, height: 1),
                                  _cert("Pedigrí", Icons.pets, pedi),
                                ],
                              ],
                            ),
                            bodyPad: 0,
                          ),
                          if (images.length > 1)
                            _tCard(
                              Icons.photo_library_outlined,
                              "Galería",
                              SizedBox(
                                height: 110,
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
                                      width: 90,
                                      margin: const EdgeInsets.only(right: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(images[i],
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          _tCard(
                            Icons.person_outline_rounded,
                            "Dueño",
                            _ownerCard(),
                          ),
                          SizedBox(
                            height: botPad + (hasActions ? 130 : 30),
                          ),
                        ],
                      ),
                    ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ---------- cabecera: nombre + botón para bajar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Transform.translate(
                  offset: Offset(0, (t - 1) * headerH),
                  child: Container(
                    height: headerH,
                    color: Colors.black,
                    padding: EdgeInsets.fromLTRB(20, topPad + 6, 16, 6),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: name),
                                if (ageText.isNotEmpty && a is num)
                                  TextSpan(
                                    text:
                                        "  ${a.toInt()} ${s("ageType") == "meses" ? "M" : "A"}",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        PetBadgeRow(pet: pet, size: 28),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.keyboard_arrow_down_rounded,
                                color: Colors.black, size: 34),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // botones flotantes ✕ ★ ❤
              if (hasActions)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: botPad + 14,
                  child: Opacity(
                    opacity: fade,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _roundAction(Icons.close_rounded, Colors.white, 66, () {
                          Navigator.pop(context);
                          widget.onNope?.call();
                        }),
                        const SizedBox(width: 18),
                        _roundAction(Icons.star_rounded,
                            const Color(0xFF6EA8FF), 52, () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Super Like: próximamente"),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }),
                        const SizedBox(width: 18),
                        _roundAction(Icons.favorite_rounded,
                            const Color(0xFFFF2D55), 66, () {
                          Navigator.pop(context);
                          widget.onLike?.call();
                        }),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _roundAction(IconData icon, Color color, double size, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C22),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: size * 0.5),
      ),
    );
  }

  // ------------------------------------------------------------- piezas

  /// La información aparece subiendo desde abajo mientras la foto se acomoda.
  Widget _reveal(Widget child) {
    final anim = ModalRoute.of(context)?.animation ?? kAlwaysCompleteAnimation;
    final t = CurvedAnimation(
      parent: anim,
      curve: const Interval(0.35, 1.0, curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: t,
      builder: (_, c) => Opacity(
        opacity: t.value.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, (1 - t.value) * 90),
          child: c,
        ),
      ),
      child: child,
    );
  }

  Widget _hero(Widget child) => widget.heroTag == null
      ? child
      : Hero(tag: widget.heroTag!, child: child);

  Widget _tCard(IconData icon, String label, Widget child,
      {double bodyPad = 18}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF141212),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
            child: Row(
              children: [
                Icon(icon, color: Colors.white54, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                bodyPad, 12, bodyPad, bodyPad == 0 ? 4 : 16),
            child: child,
          ),
        ],
      ),
    );
  }

  String _goalEmoji(String goal) {
    for (final g in PetOptions.goals) {
      if (g["text"] == goal) return g["emoji"] ?? "🐾";
    }
    return "🐾";
  }

  Widget _chips(List<String> items) => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (int i = 0; i < items.length; i++)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: i == 0
                    ? const LinearGradient(
                        colors: [Color(0xFFFF5C9A), Color(0xFFE91E63)],
                      )
                    : null,
                color: i == 0 ? null : const Color(0xFF22222A),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                items[i],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
        ],
      );

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
      child: Padding(
        padding: EdgeInsets.zero,
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
