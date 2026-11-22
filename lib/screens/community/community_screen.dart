import 'package:flutter/material.dart';

/// Comunidad PawMatch: vista previa interactiva de lo que vendrá (sin datos reales).
/// Por ahora solo perros; después se abrirá a todas las mascotas.

const Color _bg = Color(0xFF0B0B0F);
const Color _card = Color(0xFF16161C);
const Color _pink = Color(0xFFFF4D8D);
const Color _orange = Color(0xFFFFB347);
const String _u = "https://images.unsplash.com/";

class _Comment {
  final String user;
  final String text;
  bool liked;
  _Comment(this.user, this.text, {this.liked = false});
}

class _Post {
  final String user;
  final String breed;
  final String image;
  final String caption;
  final String tags;
  int paws;
  bool liked = false;
  bool saved = false;
  final List<_Comment> comments;

  _Post(this.user, this.breed, this.image, this.caption, this.tags, this.paws,
      this.comments);
}

class _Story {
  final String name;
  final String image;
  final String text;
  bool seen = false;
  _Story(this.name, this.image, this.text);
}

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final stories = [
    _Story("Luna", "photo-1558788353-f76d92427f16", "Mi primer día de parque 🌳"),
    _Story("Max", "photo-1518717758536-85ae29035b6d", "Aullando a la luna 🌙"),
    _Story("Rocky", "photo-1507146426996-ef05306b995a", "¡Hoy toca playa! 🌊"),
    _Story("Nala", "photo-1518020382113-a7e8fc38eac9", "Sesión de fotos 📸"),
    _Story("Toby", "photo-1548199973-03cce0bbc87b", "Cumple número 3 🎂"),
  ];

  late final List<_Post> posts = [
    _Post(
      "Luna",
      "Golden Retriever · Heredia",
      "${_u}photo-1558788353-f76d92427f16?w=900",
      "Domingo de parque y cero tareas ☀️",
      "#goldenretriever #parquetime",
      1284,
      [
        _Comment("max_husky", "¡Qué linda! ¿Hacemos match? 😍"),
        _Comment("rocky.lab", "Ese pelaje está de revista"),
      ],
    ),
    _Post(
      "Max",
      "Husky Siberiano · San José",
      "${_u}photo-1518717758536-85ae29035b6d?w=900",
      "Dice que él no aulló, fue el vecino 🐺",
      "#husky #aullidos",
      962,
      [_Comment("luna.golden", "Jajaja el vecino otra vez")],
    ),
    _Post(
      "Rocky",
      "Labrador · Cartago",
      "${_u}photo-1507146426996-ef05306b995a?w=900",
      "Primer baño en la playa y ya quiere vivir ahí 🌊",
      "#labrador #playa",
      2310,
      [
        _Comment("nala_poodle", "¡Qué felicidad!"),
        _Comment("toby.bull", "Vamos juntos la próxima"),
        _Comment("luna.golden", "Mejor foto del día 🐾"),
      ],
    ),
  ];

  int get _savedCount => posts.where((p) => p.saved).length;

  void _soon(String t) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t), duration: const Duration(seconds: 1)),
    );
  }

  void _openStory(int index) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (_, __, ___) => _StoryViewer(stories: stories, start: index),
        transitionsBuilder: (_, a, __, child) =>
            FadeTransition(opacity: a, child: child),
      ),
    );
    if (mounted) setState(() {});
  }

  void _openComments(_Post p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CommentsSheet(post: p),
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  void _openShare(_Post p) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ShareSheet(
        onPick: (label) {
          Navigator.pop(context);
          _soon("$label: próximamente");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: bottom + 24),
          children: [
            // Encabezado
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Comunidad",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  _roundIcon(
                    Icons.bookmark_rounded,
                    badge: _savedCount,
                    onTap: () => _soon(
                      _savedCount == 0
                          ? "Aún no guardas nada"
                          : "Tienes $_savedCount guardados",
                    ),
                  ),
                  const SizedBox(width: 10),
                  _roundIcon(
                    Icons.add_a_photo_rounded,
                    onTap: () => _soon("Publicar: próximamente"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Banner próximamente
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  _pink.withValues(alpha: 0.25),
                  _orange.withValues(alpha: 0.16),
                ]),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.rocket_launch_rounded, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Próximamente: comparte fotos y momentos con la comunidad de mascotas.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Especies
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _species("Perros", "🐶", true),
                  _species("Gatos", "🐱", false),
                  _species("Aves", "🦜", false),
                  _species("Conejos", "🐰", false),
                  _species("Más", "🐾", false),
                ],
              ),
            ),

            // Momentos
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 22, 20, 12),
              child: Text(
                "Momentos",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: stories.length + 1,
                itemBuilder: (_, i) => i == 0
                    ? _addMoment()
                    : _momentCard(stories[i - 1], i - 1),
              ),
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text(
                "Del parque",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            ...posts.map(_postCard),
          ],
        ),
      ),
    );
  }

  Widget _roundIcon(IconData icon, {int badge = 0, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF22222A),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          if (badge > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration:
                    const BoxDecoration(color: _pink, shape: BoxShape.circle),
                child: Text(
                  "$badge",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _species(String name, String emoji, bool active) {
    return GestureDetector(
      onTap: active ? null : () => _soon("$name: pronto en la comunidad"),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? Colors.white : const Color(0xFF22222A),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              name,
              style: TextStyle(
                color: active ? Colors.black : Colors.white60,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (!active) ...[
              const SizedBox(width: 6),
              const Icon(Icons.lock_outline, size: 13, color: Colors.white38),
            ],
          ],
        ),
      ),
    );
  }

  Widget _addMoment() {
    return GestureDetector(
      onTap: () => _soon("Subir momento: próximamente"),
      child: Container(
        width: 96,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white12),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: _pink,
              child: Icon(Icons.add, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              "Tu momento",
              style: TextStyle(color: Colors.white70, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _momentCard(_Story s, int index) {
    return GestureDetector(
      onTap: () => _openStory(index),
      child: Container(
        width: 96,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: s.seen
              ? null
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_pink, _orange],
                ),
          color: s.seen ? Colors.white24 : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21.5),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                "$_u${s.image}?w=300",
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: _card),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [Color(0xCC000000), Colors.transparent],
                  ),
                ),
              ),
              Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: Text(
                  s.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _postCard(_Post p) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: AspectRatio(
        aspectRatio: 0.8,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: _PostBody(
            post: p,
            onChanged: () => setState(() {}),
            onComments: () => _openComments(p),
            onShare: () => _openShare(p),
          ),
        ),
      ),
    );
  }
}

/// Tarjeta de publicación con carril de acciones y huella al dar doble toque.
class _PostBody extends StatefulWidget {
  final _Post post;
  final VoidCallback onChanged;
  final VoidCallback onComments;
  final VoidCallback onShare;

  const _PostBody({
    required this.post,
    required this.onChanged,
    required this.onComments,
    required this.onShare,
  });

  @override
  State<_PostBody> createState() => _PostBodyState();
}

class _PostBodyState extends State<_PostBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _burst = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 750),
  );

  @override
  void dispose() {
    _burst.dispose();
    super.dispose();
  }

  void _setLike(bool v) {
    final p = widget.post;
    if (p.liked == v) return;
    p.liked = v;
    p.paws += v ? 1 : -1;
    widget.onChanged();
  }

  void _doubleTap() {
    _setLike(true);
    _burst.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.post;

    return GestureDetector(
      onDoubleTap: _doubleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            p.image,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: _card),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment(0, -0.1),
                colors: [Color(0xEE000000), Colors.transparent],
              ),
            ),
          ),

          // Usuario
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.fromLTRB(6, 6, 14, 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(p.image),
                    backgroundColor: _card,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.user,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13.5,
                        ),
                      ),
                      Text(
                        p.breed,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Texto
          Positioned(
            left: 18,
            right: 84,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  p.caption,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  p.tags,
                  style: const TextStyle(color: Color(0xFFFF9CC4)),
                ),
              ],
            ),
          ),

          // Carril de acciones
          Positioned(
            right: 12,
            bottom: 14,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _action(
                  Icons.pets,
                  "${p.paws}",
                  active: p.liked,
                  onTap: () {
                    _setLike(!p.liked);
                    if (p.liked) _burst.forward(from: 0);
                  },
                ),
                const SizedBox(height: 12),
                _action(
                  Icons.chat_bubble_rounded,
                  "${p.comments.length}",
                  onTap: widget.onComments,
                ),
                const SizedBox(height: 12),
                _action(Icons.near_me_rounded, "Enviar",
                    onTap: widget.onShare),
                const SizedBox(height: 12),
                _action(
                  Icons.bookmark_rounded,
                  p.saved ? "Guardado" : "Guardar",
                  active: p.saved,
                  onTap: () {
                    p.saved = !p.saved;
                    widget.onChanged();
                  },
                ),
              ],
            ),
          ),

          // Huella grande
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _burst,
              builder: (_, __) {
                final t = _burst.value;
                if (t == 0 || t == 1) return const SizedBox.shrink();
                final scale = Curves.elasticOut.transform((t * 1.4).clamp(0, 1));
                final opacity = t < 0.7 ? 1.0 : (1 - (t - 0.7) / 0.3);
                return Center(
                  child: Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: Transform.scale(
                      scale: 0.4 + scale * 0.9,
                      child: const Icon(
                        Icons.pets,
                        size: 130,
                        color: _pink,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 24)],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _action(IconData icon, String label,
      {bool active = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? _pink : Colors.black.withValues(alpha: 0.45),
              border: Border.all(
                color: active ? _pink : Colors.white24,
              ),
            ),
            child: AnimatedScale(
              duration: const Duration(milliseconds: 180),
              scale: active ? 1.12 : 1,
              child: Icon(icon, color: Colors.white, size: 24),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              shadows: [Shadow(color: Colors.black87, blurRadius: 6)],
            ),
          ),
        ],
      ),
    );
  }
}

/// Visor de momentos (historias) a pantalla completa.
class _StoryViewer extends StatefulWidget {
  final List<_Story> stories;
  final int start;
  const _StoryViewer({required this.stories, required this.start});

  @override
  State<_StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<_StoryViewer>
    with SingleTickerProviderStateMixin {
  late int index = widget.start;
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..addStatusListener((s) {
      if (s == AnimationStatus.completed) _next();
    });
  bool reacted = false;

  @override
  void initState() {
    super.initState();
    _play();
  }

  void _play() {
    widget.stories[index].seen = true;
    reacted = false;
    _c.forward(from: 0);
  }

  void _next() {
    if (index < widget.stories.length - 1) {
      setState(() => index++);
      _play();
    } else {
      Navigator.pop(context);
    }
  }

  void _prev() {
    if (index > 0) {
      setState(() => index--);
      _play();
    } else {
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.stories[index];
    final pad = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (d) {
          if (d.localPosition.dx < MediaQuery.of(context).size.width / 3) {
            _prev();
          } else {
            _next();
          }
        },
        onVerticalDragEnd: (d) {
          if ((d.primaryVelocity ?? 0) > 300) Navigator.pop(context);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              "$_u${s.image}?w=1000",
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: _card),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Color(0xAA000000), Colors.transparent],
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [Color(0xCC000000), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              top: pad.top + 8,
              left: 12,
              right: 12,
              child: Row(
                children: List.generate(widget.stories.length, (i) {
                  return Expanded(
                    child: Container(
                      height: 3.5,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: i < index
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            )
                          : i == index
                              ? AnimatedBuilder(
                                  animation: _c,
                                  builder: (_, __) => FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: _c.value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                )
                              : null,
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              top: pad.top + 22,
              left: 14,
              right: 8,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage("$_u${s.image}?w=200"),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    s.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text("Hace 2 h",
                      style: TextStyle(color: Colors.white60, fontSize: 12)),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded,
                        color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 22,
              right: 22,
              bottom: pad.bottom + 92,
              child: Text(
                s.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 12)],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: pad.bottom + 18,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white54),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Text(
                        "Responder a ${s.name}…",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => setState(() => reacted = !reacted),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: reacted ? _pink : Colors.black45,
                        border: Border.all(
                          color: reacted ? _pink : Colors.white54,
                        ),
                      ),
                      child: const Icon(Icons.pets, color: Colors.white),
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

class _CommentsSheet extends StatefulWidget {
  final _Post post;
  const _CommentsSheet({required this.post});

  @override
  State<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<_CommentsSheet> {
  final ctrl = TextEditingController();

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  void _send() {
    final t = ctrl.text.trim();
    if (t.isEmpty) return;
    setState(() {
      widget.post.comments.add(_Comment("tú", t));
      ctrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.post;
    final h = MediaQuery.of(context).size.height;
    final kb = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: kb),
      child: Container(
        height: h * 0.66,
        decoration: const BoxDecoration(
          color: Color(0xFF121217),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Comentarios · ${p.comments.length}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: p.comments.length,
                itemBuilder: (_, i) {
                  final c = p.comments[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: const Color(0xFF26262C),
                          child: const Icon(Icons.pets,
                              size: 16, color: Colors.white54),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.user,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                c.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => c.liked = !c.liked),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.pets,
                              size: 20,
                              color: c.liked ? _pink : Colors.white30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: ctrl,
                        style: const TextStyle(color: Colors.white),
                        onSubmitted: (_) => _send(),
                        decoration: InputDecoration(
                          hintText: "Escribe un comentario…",
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: const Color(0xFF22222A),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(28),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _send,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: _pink,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send_rounded,
                            color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareSheet extends StatelessWidget {
  final void Function(String label) onPick;
  const _ShareSheet({required this.onPick});

  @override
  Widget build(BuildContext context) {
    final items = [
      [Icons.favorite_rounded, "Mis matches"],
      [Icons.chat_rounded, "WhatsApp"],
      [Icons.link_rounded, "Copiar enlace"],
      [Icons.ios_share_rounded, "Más"],
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: Color(0xFF121217),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "Enviar a",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.map((e) {
                return GestureDetector(
                  onTap: () => onPick(e[1] as String),
                  child: Column(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: const BoxDecoration(
                          color: Color(0xFF22222A),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(e[0] as IconData,
                            color: Colors.white, size: 26),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        e[1] as String,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
