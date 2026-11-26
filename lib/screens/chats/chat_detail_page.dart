import 'dart:async';
import 'dart:io';
import 'dart:ui' show ImageFilter;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:video_player/video_player.dart';

import 'package:cloud_firestore/cloud_firestore.dart'
    show QuerySnapshot, Timestamp;

import '../../data/chats_data.dart';
import '../../data/matches_data.dart';
import '../../services/chat_service.dart';
import '../../services/discover_service.dart';
import '../../services/cloudinary_service.dart';
import '../../widgets/paw_pattern.dart';
import '../../widgets/pet_badge_row.dart';
import '../match/pet_detail_screen.dart';

const Color _bg = Color(0xFF0B0B0F);
const Color _bubble = Color(0xFF1E1E25);
const Color _pink = Color(0xFFFF4D8D);
const Color _coral = Color(0xFFFF7A6B);
const Color _seen = Color(0xFF53BDEB);

class ChatDetailPage extends StatefulWidget {
  final String name;
  final String image;
  final bool fromMatch;
  final Map<String, dynamic>? matchPet;

  const ChatDetailPage({
    super.key,
    required this.name,
    required this.image,
    this.fromMatch = false,
    this.matchPet,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _rec = AudioRecorder();

  StreamSubscription? chatSubscription;
  StreamSubscription? _typingSub;
  Timer? _typingTimer;
  bool _iAmTyping = false;
  bool _otherTyping = false;

  String? get _otherUid => widget.matchPet?["id"]?.toString();

  /// Mensaje que se está editando (null = escribiendo uno nuevo).
  Map<String, dynamic>? editing;

  /// Mensaje al que se está respondiendo.
  Map<String, dynamic>? replying;

  /// Modo selección para eliminar (como WhatsApp).
  bool selecting = false;
  final Set<int> _selected = {};

  bool recording = false;
  bool recLocked = false; // grabación fija (desliza hacia arriba)
  bool _cancelArmed = false;
  bool _lockArmed = false;
  double _dx = 0;
  double _dy = 0;
  Future<void>? _recStart;
  int recSeconds = 0;
  Timer? _recTimer;

  /// Chat real: "uidA_uidB" ordenado (el mismo para los dos dueños).
  String get chatId {
    final other = (widget.matchPet?["id"] ?? widget.name).toString();
    final me = DiscoverService.myUid;
    if (me == null || widget.matchPet == null) return other;
    return DiscoverService.matchId(me, other);
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
      _onTypingChanged();
    });

    chatSubscription = ChatService.getMessages(chatId).listen(
      _onMessages,
      onError: (e) => debugPrint("Error leyendo mensajes: $e"),
    );

    _typingSub = ChatService.chatDoc(chatId).listen(
      (doc) {
        final other = _otherUid;
        final t = doc.data()?["typing"];
        final value = other != null && t is Map && t[other] == true;
        if (value != _otherTyping && mounted) {
          setState(() => _otherTyping = value);
        }
      },
      onError: (e) => debugPrint("Error leyendo 'escribiendo': $e"),
    );
  }

  // ----------------------------------------------- escribiendo… y mensajes

  void _setTyping(bool value) {
    final me = DiscoverService.myUid;
    if (me == null || widget.matchPet == null) return;
    if (_iAmTyping == value) return;
    _iAmTyping = value;
    ChatService.setTyping(chatId: chatId, uid: me, typing: value)
        .catchError((e) => debugPrint("No se pudo avisar que escribo: $e"));
  }

  void _onTypingChanged() {
    final hasText = controller.text.trim().isNotEmpty;
    _typingTimer?.cancel();
    if (!hasText) {
      _setTyping(false);
      return;
    }
    _setTyping(true);
    _typingTimer = Timer(const Duration(seconds: 3), () => _setTyping(false));
  }

  /// Recibe los mensajes de Firebase y agrega los que todavía no están en pantalla.
  void _onMessages(QuerySnapshot snap) {
    if (widget.matchPet == null) return;
    final me = DiscoverService.myUid;
    if (me == null) return;

    final chat = _ensureChat() ?? currentChat;
    if (chat == null) return;
    final list = chat["messages"] as List;

    var changed = false;
    for (final d in snap.docs) {
      final data = d.data() as Map<String, dynamic>;
      final mine = data["senderId"] == me;
      final type = (data["type"] ?? "text").toString();
      final text = (data["text"] ?? "").toString();

      final alreadyThere = list.any((m) => m is Map && m["id"] == d.id) ||
          (mine &&
              list.any((m) =>
                  m is Map &&
                  m["id"] == null &&
                  m["isMe"] == true &&
                  m["type"] == type &&
                  m["text"] == text));
      if (alreadyThere) continue;

      final ts = data["createdAt"];
      final when = ts is Timestamp ? ts.toDate() : DateTime.now();

      list.add({
        "id": d.id,
        "type": type,
        "text": text,
        "isMe": mine,
        "time":
            "${when.hour}:${when.minute.toString().padLeft(2, '0')}",
        "sentAt": when,
        "status": mine ? "delivered" : "seen",
        if (data["url"] != null) "url": data["url"],
        if (data["duration"] != null) "duration": data["duration"],
        "uploading": false,
      });
      changed = true;
    }

    if (!changed) return;

    list.sort((a, b) {
      final x = (a is Map ? a["sentAt"] : null);
      final y = (b is Map ? b["sentAt"] : null);
      if (x is DateTime && y is DateTime) return x.compareTo(y);
      return 0;
    });

    if (list.isNotEmpty && list.last is Map) {
      chat["lastMessage"] = (list.last as Map)["text"];
    }
    if (mounted) {
      setState(() {});
      scrollToBottom();
    }
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _setTyping(false);
    _typingSub?.cancel();
    chatSubscription?.cancel();
    _recTimer?.cancel();
    _rec.dispose();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- datos

  Map<String, dynamic>? get currentChat {
    final exists = ChatsData.chats.any((c) => c["name"] == widget.name);
    if (!exists) return null;
    return ChatsData.chats.firstWhere((c) => c["name"] == widget.name);
  }

  List<Map<String, dynamic>> get messages {
    final chat = currentChat;
    if (chat == null) return [];
    return List<Map<String, dynamic>>.from(chat["messages"] ?? []);
  }

  Map<String, dynamic>? get _petData {
    if (widget.matchPet != null) return widget.matchPet;
    final d = currentChat?["petData"];
    return d is Map<String, dynamic> ? d : null;
  }

  String getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  String getRelativeMatchTime(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays < 1) return "Hoy";
    if (difference.inDays == 1) return "Ayer";
    if (difference.inDays < 7) return "Hace ${difference.inDays} días";
    if (difference.inDays < 30) {
      final w = (difference.inDays / 7).floor();
      return w == 1 ? "Hace 1 semana" : "Hace $w semanas";
    }
    if (difference.inDays < 365) {
      final m = (difference.inDays / 30).floor();
      return m == 1 ? "Hace 1 mes" : "Hace $m meses";
    }
    final y = (difference.inDays / 365).floor();
    return y == 1 ? "Hace 1 año" : "Hace $y años";
  }

  /// Crea el chat la primera vez que se escribe desde un match.
  Map<String, dynamic>? _ensureChat() {
    if (widget.fromMatch && currentChat == null) {
      ChatsData.createChat({
        "id": widget.matchPet?["id"] ?? widget.name,
        "name": widget.name,
        "image": widget.image,
        "images": [widget.image],
        "pedigree": widget.matchPet?["pedigree"] ?? true,
        "messages": [],
        "lastMessage": "",
        "time": "",
        "unread": 0,
        "petData": widget.matchPet,
      });

      final created = currentChat;
      final originalDate = widget.matchPet?["matchDate"];
      if (created != null && originalDate != null) {
        created["matchDate"] = originalDate;
      }
      if (widget.matchPet != null) {
        MatchesData.removeMatch(widget.matchPet!);
      }
    }
    return currentChat;
  }

  // ---------------------------------------------------------- navegación

  void openPetProfile() {
    final petData = _petData;
    if (petData == null) return;
    PetDetailScreen.open(context, petData);
  }

  void cancelMatch() {
    final pet = widget.matchPet;
    if (pet != null) {
      MatchesData.removeMatch(pet);
      ChatsData.removeChatById(pet["id"]);
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void blockUser() {
    final pet = widget.matchPet;
    if (pet != null) {
      MatchesData.removeMatch(pet);
      ChatsData.blockUser(pet["id"]);
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void reportUser() {
    final pet = widget.matchPet;
    if (pet != null) ChatsData.reportUser(pet["id"]);
    Navigator.pop(context);
    _snack("Reporte enviado correctamente");
  }

  void _snack(String t) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t), duration: const Duration(seconds: 2)),
    );
  }

  void showSafetyTools() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121217),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Herramientas de seguridad",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _sheetOption("Cancelar Match",
                  "Ya no te interesa, elimínalo de tus matches", cancelMatch),
              _sheetOption("Bloquear",
                  "No verás perfiles ni ellos te verán", blockUser),
              _sheetOption(
                  "Denunciar", "No te preocupes, lo contaremos", reportUser),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetOption(String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54)),
      trailing: const Icon(Icons.arrow_forward_ios,
          color: Colors.white38, size: 16),
    );
  }

  // ------------------------------------------------------------- envío

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (!mounted || !scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  /// Estados: sent (✓) → delivered (✓✓ gris) → seen (✓✓ azul).
  /// Por ahora son simulados; serán reales cuando haya dos usuarios en Firebase.
  void _simulateStatus(Map<String, dynamic> msg) {
    Future.delayed(const Duration(seconds: 1), () {
      if (msg["deleted"] == true) return;
      msg["status"] = "delivered";
      if (mounted) setState(() {});
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (msg["deleted"] == true) return;
      msg["status"] = "seen";
      if (mounted) setState(() {});
    });
  }

  String _preview(String type, String text) {
    switch (type) {
      case "image":
        return "📷 Foto";
      case "video":
        return "🎥 Video";
      case "audio":
        return "🎤 Nota de voz";
      default:
        return text;
    }
  }

  Map<String, dynamic>? _push(String type, String text,
      {String? path, int? duration, bool uploading = false}) {
    final chat = _ensureChat();
    if (chat == null) return null;

    final msg = <String, dynamic>{
      "id": ChatService.newMessageId(chatId),
      "type": type,
      "text": _preview(type, text),
      "isMe": true,
      "time": getCurrentTime(),
      "sentAt": DateTime.now(),
      "status": "sent",
      if (path != null) "path": path,
      if (duration != null) "duration": duration,
      "uploading": uploading,
    };

    setState(() {
      (chat["messages"] as List).add(msg);
      chat["lastMessage"] = msg["text"];
      chat["time"] = getCurrentTime();
    });
    scrollToBottom();
    return msg;
  }

  Future<void> sendText() async {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    // Editar un mensaje ya enviado.
    if (editing != null) {
      final m = editing!;
      setState(() {
        m["text"] = text;
        m["edited"] = true;
        editing = null;
        final chat = currentChat;
        if (chat != null) {
          final list = chat["messages"] as List;
          if (list.isNotEmpty && identical(list.last, m)) {
            chat["lastMessage"] = text;
          }
        }
      });
      controller.clear();
      return;
    }

    final msg = _push("text", text);
    if (msg == null) return;
    if (replying != null) {
      msg["replyTo"] = {
        "text": _previewOf(replying!),
        "isMe": replying!['isMe'] == true,
      };
      setState(() => replying = null);
    }
    controller.clear();

    try {
      await ChatService.sendMessage(
        chatId: chatId,
        senderId: DiscoverService.myUid ?? "me",
        text: text,
        messageId: msg["id"]?.toString(),
      );
    } catch (e) {
      debugPrint("No se pudo guardar el mensaje en Firebase: $e");
    }
    _simulateStatus(msg);
  }

  Future<void> _sendMedia(File file, String type, {int? duration}) async {
    final msg = _push(type, "", path: file.path, duration: duration, uploading: true);
    if (msg == null) return;

    try {
      final url = await CloudinaryService.uploadMedia(
        file,
        resourceType: type == "image" ? "image" : "video",
      );

      if (url == null) throw Exception("sin url");

      msg["url"] = url;
      msg["uploading"] = false;
      if (mounted) setState(() {});

      try {
        await ChatService.sendMessage(
          chatId: chatId,
          senderId: DiscoverService.myUid ?? "me",
          text: msg["text"],
          type: type,
          url: url,
          duration: duration,
          messageId: msg["id"]?.toString(),
        );
      } catch (e) {
        debugPrint("No se pudo guardar el archivo en Firebase: $e");
      }
      _simulateStatus(msg);
    } catch (e) {
      debugPrint("Error subiendo archivo: $e");
      final chat = currentChat;
      if (chat != null) (chat["messages"] as List).remove(msg);
      if (mounted) setState(() {});
      _snack("No se pudo enviar. Revisa tu conexión e inténtalo de nuevo.");
    }
  }

  // ----------------------------------------------------- fotos y videos

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final x = await _picker.pickImage(source: source, imageQuality: 80);
      if (x != null) await _sendMedia(File(x.path), "image");
    } catch (e) {
      _snack("No se pudo abrir la ${source == ImageSource.camera ? "cámara" : "galería"}.");
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    try {
      final x = await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 2),
      );
      if (x != null) await _sendMedia(File(x.path), "video");
    } catch (e) {
      _snack("No se pudo abrir el video.");
    }
  }

  void _attachSheet() {
    Widget item(IconData icon, Color color, String label, VoidCallback onTap) {
      return GestureDetector(
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
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
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  item(Icons.photo_library_rounded, Colors.purpleAccent,
                      "Fotos", () => _pickPhoto(ImageSource.gallery)),
                  item(Icons.videocam_rounded, Colors.orangeAccent, "Videos",
                      () => _pickVideo(ImageSource.gallery)),
                  item(Icons.photo_camera_rounded, Colors.pinkAccent,
                      "Cámara", () => _pickPhoto(ImageSource.camera)),
                  item(Icons.movie_creation_rounded, Colors.lightBlueAccent,
                      "Grabar", () => _pickVideo(ImageSource.camera)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------- audio

  Future<void> _startRecording() async {
    try {
      if (!await _rec.hasPermission()) {
        _snack("Activa el permiso del micrófono para enviar notas de voz.");
        return;
      }
      final dir = await getTemporaryDirectory();
      final path =
          "${dir.path}/pm_${DateTime.now().millisecondsSinceEpoch}.m4a";
      await _rec.start(const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path);

      recSeconds = 0;
      _recTimer?.cancel();
      _recTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => recSeconds++);
      });
      setState(() => recording = true);
    } catch (e) {
      _snack("No se pudo empezar a grabar.");
    }
  }

  void _micDown() {
    HapticFeedback.mediumImpact();
    _cancelArmed = false;
    _lockArmed = false;
    _dx = 0;
    _dy = 0;
    _recStart = _startRecording();
  }

  void _micMove(Offset d) {
    if (!recording || recLocked) return;
    final cancel = d.dx < -110;
    final lock = d.dy < -90;
    if ((cancel && !_cancelArmed) || (lock && !_lockArmed)) {
      HapticFeedback.selectionClick();
    }
    setState(() {
      _dx = d.dx;
      _dy = d.dy;
      _cancelArmed = cancel;
      _lockArmed = lock && !cancel;
    });
  }

  Future<void> _micUp() async {
    await _recStart;
    if (!recording || recLocked) return;
    if (_cancelArmed) {
      HapticFeedback.heavyImpact();
      await _stopRecording(send: false);
    } else if (_lockArmed) {
      setState(() {
        recLocked = true;
        _dx = 0;
        _dy = 0;
      });
    } else {
      await _stopRecording(send: true);
    }
  }

  Future<void> _stopRecording({required bool send}) async {
    _recTimer?.cancel();
    final seconds = recSeconds;
    String? path;
    try {
      if (send) {
        path = await _rec.stop();
      } else {
        await _rec.cancel();
      }
    } catch (e) {
      debugPrint("Error al parar grabación: $e");
    }
    if (mounted) {
      setState(() {
        recording = false;
        recLocked = false;
        _cancelArmed = false;
        _lockArmed = false;
        _dx = 0;
        _dy = 0;
      });
    }

    if (send && path != null && seconds >= 1) {
      await _sendMedia(File(path), "audio", duration: seconds);
    } else if (send) {
      _snack("Mantén la grabación un poco más.");
    }
  }

  // ---------------------------------------------------------- burbuja

  final Map<int, GlobalKey> _bubbleKeys = {};
  GlobalKey _keyFor(Map m) =>
      _bubbleKeys.putIfAbsent(identityHashCode(m), () => GlobalKey());

  Widget _bubbleBox(Map<String, dynamic> msg, double maxW) {
    final isMe = msg["isMe"] == true;
    final deleted = msg["deleted"] == true;
    final status = "${msg["status"] ?? "sent"}";
    return Container(
                  constraints: BoxConstraints(maxWidth: maxW),
                  margin: const EdgeInsets.only(bottom: 3),
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                  decoration: BoxDecoration(
                    gradient: isMe && !deleted
                        ? const LinearGradient(colors: [_pink, _coral])
                        : null,
                    color: isMe && !deleted ? null : _bubble,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isMe ? 20 : 5),
                      bottomRight: Radius.circular(isMe ? 5 : 20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (msg["replyTo"] is Map && !deleted)
                        _replyQuote(msg["replyTo"] as Map, isMe),
                      _content(msg, deleted),
                      const SizedBox(height: 3),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (msg["edited"] == true && !deleted)
                            const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Text(
                                "editado",
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 10.5,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          Text(
                            "${msg["time"] ?? ""}",
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 10.5,
                            ),
                          ),
                          if (isMe && !deleted) ...[
                            const SizedBox(width: 4),
                            if (msg["uploading"] == true)
                              const Icon(Icons.schedule,
                                  size: 14, color: Colors.white70)
                            else
                              _checks(status),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
  }

  Widget _replyQuote(Map r, bool isMe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: isMe ? Colors.white : _pink,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            r["isMe"] == true ? "Tú" : widget.name,
            style: TextStyle(
              color: isMe ? Colors.white : _pink,
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            "${r["text"]}",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  String _previewOf(Map m) {
    switch ("${m["type"] ?? "text"}") {
      case "image":
        return "📷 Foto";
      case "video":
        return "🎥 Video";
      case "audio":
        return "🎤 Nota de voz";
      default:
        return "${m["text"] ?? ""}";
    }
  }

  // ---------------------------------------------- acciones de un mensaje

  bool _canEdit(Map<String, dynamic> m) {
    final at = m["sentAt"];
    if (at is! DateTime) return false;
    return DateTime.now().difference(at).inMinutes < 15;
  }

  void _messageMenu(Map<String, dynamic> m) {
    if (m["deleted"] == true || m["uploading"] == true) return;

    final ctx = _keyFor(m).currentContext;
    final box = ctx?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final origin = box.localToGlobal(Offset.zero);
    final rect = origin & box.size;

    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 180),
        reverseTransitionDuration: const Duration(milliseconds: 140),
        pageBuilder: (routeCtx, anim, __) => _menuOverlay(routeCtx, anim, m, rect),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  Widget _menuOverlay(BuildContext routeCtx, Animation<double> anim,
      Map<String, dynamic> m, Rect rect) {
    final media = MediaQuery.of(routeCtx);
    final isMe = m["isMe"] == true;
    final isText = (m["type"] ?? "text") == "text";
    final maxW = media.size.width * 0.76;

    final items = <List<dynamic>>[
      ["Responder", Icons.reply_rounded, Colors.white, () => setState(() => replying = m)],
      if (isText)
        [
          "Copiar",
          Icons.copy_rounded,
          Colors.white,
          () {
            Clipboard.setData(ClipboardData(text: "${m["text"]}"));
            _snack("Mensaje copiado");
          }
        ],
      if (isMe && isText)
        [
          "Editar",
          Icons.edit_rounded,
          Colors.white,
          () {
            if (!_canEdit(m)) {
              _snack("Solo puedes editar durante los primeros 15 minutos.");
              return;
            }
            setState(() {
              replying = null;
              editing = m;
            });
            controller.text = "${m["text"]}";
            controller.selection =
                TextSelection.collapsed(offset: controller.text.length);
          }
        ],
      [
        "Eliminar",
        Icons.delete_outline_rounded,
        const Color(0xFFFF6B7A),
        () => setState(() {
              selecting = true;
              _selected
                ..clear()
                ..add(identityHashCode(m));
            })
      ],
    ];

    const reactions = ["👍", "❤️", "😂", "😮", "😢", "🙏"];
    const barH = 58.0;
    const menuW = 250.0;
    final menuH = items.length * 52.0 + 12;
    final total = barH + 10 + rect.height + 10 + menuH;

    double top = rect.top - barH - 10;
    final minTop = media.padding.top + 8;
    final maxTop = media.size.height - media.padding.bottom - total - 8;
    if (top > maxTop) top = maxTop;
    if (top < minTop) top = minTop;

    final bubbleTop = top + barH + 10;
    final menuTop = bubbleTop + rect.height + 10;

    double alignLeft(double w) {
      final l = isMe ? rect.right - w : rect.left;
      return l.clamp(10.0, media.size.width - w - 10).toDouble();
    }

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () => Navigator.pop(routeCtx),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Container(color: Colors.black.withValues(alpha: 0.45)),
              ),
            ),
          ),

          // reacciones
          Positioned(
            top: top,
            left: alignLeft(6 * 46.0 + 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: barH,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2E),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  for (final e in reactions)
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(routeCtx);
                        setState(() {
                          if (m["reaction"] == e) {
                            m.remove("reaction");
                          } else {
                            m["reaction"] = e;
                          }
                        });
                      },
                      child: SizedBox(
                        width: 46,
                        child: Center(
                          child: Text(
                            e,
                            style: TextStyle(
                              fontSize: m["reaction"] == e ? 34 : 29,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // el mensaje, en su lugar
          Positioned(
            top: bubbleTop,
            left: rect.left,
            child: IgnorePointer(
              child: _bubbleBox(m, maxW),
            ),
          ),

          // menú
          Positioned(
            top: menuTop,
            left: alignLeft(menuW),
            child: Container(
              width: menuW,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2E),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final it in items)
                    InkWell(
                      onTap: () {
                        Navigator.pop(routeCtx);
                        (it[3] as VoidCallback)();
                      },
                      child: SizedBox(
                        height: 52,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  it[0] as String,
                                  style: TextStyle(
                                    color: it[2] as Color,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              Icon(it[1] as IconData,
                                  color: it[2] as Color, size: 22),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Como en WhatsApp: eliminar para todos (si es tuyo) o solo para ti.
  void _deleteDialog(Map<String, dynamic> m) {
    final isMe = m["isMe"] == true;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121217),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "¿Eliminar mensaje?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              if (isMe)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.delete_forever_rounded,
                      color: Colors.redAccent),
                  title: const Text("Eliminar para todos",
                      style: TextStyle(color: Colors.redAccent)),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      m["deleted"] = true;
                      m["text"] = "Eliminaste este mensaje";
                      m["type"] = "text";
                      m.remove("url");
                      m.remove("path");
                      m.remove("duration");
                      final chat = currentChat;
                      if (chat != null) {
                        final list = chat["messages"] as List;
                        if (list.isNotEmpty && identical(list.last, m)) {
                          chat["lastMessage"] = "Eliminaste este mensaje";
                        }
                      }
                    });
                  },
                ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading:
                    const Icon(Icons.delete_outline_rounded, color: Colors.white),
                title: const Text("Eliminar para mí",
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() {
                    final chat = currentChat;
                    if (chat != null) {
                      (chat["messages"] as List).removeWhere((e) => identical(e, m));
                    }
                  });
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.close_rounded, color: Colors.white54),
                title: const Text("Cancelar",
                    style: TextStyle(color: Colors.white70)),
                onTap: () => Navigator.pop(ctx),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------------- UI

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !selecting,
      onPopInvoked: (didPop) {
        if (!didPop && selecting) {
          setState(() {
            selecting = false;
            _selected.clear();
          });
        }
      },
      child: Scaffold(
        backgroundColor: _bg,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              selecting ? _selectHeader() : _buildHeader(),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.06)),
              Expanded(
                child: Stack(
                  children: [
                    const Positioned.fill(child: IgnorePointer(child: PawPattern())),
                    _buildMessagesList(),
                  ],
                ),
              ),
              selecting ? _selectBar() : _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  void _exitSelection() => setState(() {
        selecting = false;
        _selected.clear();
      });

  Widget _selectHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: _bubble,
            backgroundImage:
                widget.image.isEmpty ? null : NetworkImage(widget.image),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _circleButton(Icons.close_rounded, _exitSelection),
        ],
      ),
    );
  }

  Widget _selectBar() {
    final n = _selected.length;
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 8, 14, 12),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2E),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: n == 0 ? null : _deleteSelected,
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.delete_outline_rounded,
                size: 28,
                color: n == 0 ? Colors.white30 : Colors.white,
              ),
            ),
            const Spacer(),
            Text(
              n == 1 ? "1 seleccionado" : "$n seleccionados",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Hoja "¿Quieres eliminar este mensaje?" (como WhatsApp).
  void _deleteSelected() {
    final chat = currentChat;
    if (chat == null) return;
    final all = (chat["messages"] as List).cast<Map<String, dynamic>>();
    final chosen =
        all.where((m) => _selected.contains(identityHashCode(m))).toList();
    if (chosen.isEmpty) return;

    // "Eliminar para todos" solo si TODOS los elegidos son tuyos.
    final canAll = chosen.every((m) => m["isMe"] == true && m["deleted"] != true);
    final plural = chosen.length > 1;

    Widget option(String label, VoidCallback onTap) => InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFFF4D5E),
                fontSize: 18,
              ),
            ),
          ),
        );

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const SizedBox(width: 54),
                  Expanded(
                    child: Text(
                      plural
                          ? "¿Quieres eliminar\nestos mensajes?"
                          : "¿Quieres eliminar\neste mensaje?",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3A3A3E),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: Colors.white, size: 28),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF262628),
                  borderRadius: BorderRadius.circular(26),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    if (canAll) ...[
                      option("Eliminar para todos", () {
                        Navigator.pop(ctx);
                        setState(() {
                          for (final m in chosen) {
                            m["deleted"] = true;
                            m["text"] = "Eliminaste este mensaje";
                            m["type"] = "text";
                            m.remove("url");
                            m.remove("path");
                            m.remove("duration");
                            m.remove("reaction");
                            m.remove("replyTo");
                          }
                          final list = chat["messages"] as List;
                          if (list.isNotEmpty && chosen.contains(list.last)) {
                            chat["lastMessage"] = "Eliminaste este mensaje";
                          }
                          selecting = false;
                          _selected.clear();
                        });
                      }),
                      const Divider(
                          color: Colors.white12, height: 1, indent: 20, endIndent: 20),
                    ],
                    option("Eliminar para mí", () {
                      Navigator.pop(ctx);
                      setState(() {
                        (chat["messages"] as List)
                            .removeWhere((e) => chosen.contains(e));
                        selecting = false;
                        _selected.clear();
                      });
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final pet = _petData;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
      child: Row(
        children: [
          _circleButton(Icons.arrow_back_ios_new, () => Navigator.pop(context)),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: openPetProfile,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF4D8D), Color(0xFFFFB347)],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: _bubble,
                      backgroundImage: widget.image.isEmpty
                          ? null
                          : NetworkImage(widget.image),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          _otherTyping ? "escribiendo…" : "Toca para ver perfil",
                          style: TextStyle(
                            color: _otherTyping
                                ? const Color(0xFF53BDEB)
                                : Colors.white54,
                            fontSize: 12,
                            fontStyle: _otherTyping
                                ? FontStyle.italic
                                : FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (pet != null) PetBadgeRow(pet: pet, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          _circleButton(Icons.more_horiz, showSafetyTools),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: _bubble),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _checks(String status, {Color? base}) {
    if (status == "sent") {
      return Icon(Icons.check, size: 15, color: base ?? Colors.white70);
    }
    return Icon(
      Icons.done_all,
      size: 15,
      color: status == "seen" ? _seen : (base ?? Colors.white70),
    );
  }

  Widget _buildMessagesList() {
    final chat = currentChat;
    final shown = messages;

    final DateTime? matchDate = widget.fromMatch
        ? (widget.matchPet?["matchDate"] as DateTime?)
        : (chat?["matchDate"] as DateTime?);

    final maxW = MediaQuery.of(context).size.width * 0.76;

    // Último mensaje mío: muestra "Visto / Entregado / Enviado".
    int lastMine = -1;
    for (int i = shown.length - 1; i >= 0; i--) {
      if (shown[i]["isMe"] == true && shown[i]["deleted"] != true) {
        lastMine = i;
        break;
      }
    }

    return ListView.builder(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      itemCount: shown.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _bubble,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.pets, color: _pink, size: 18),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          "¡Hicieron match con ${widget.name}!",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (matchDate != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    getRelativeMatchTime(matchDate),
                    style: const TextStyle(color: Colors.white30, fontSize: 11),
                  ),
                ],
              ],
            ),
          );
        }

        final i = index - 1;
        final msg = shown[i];
        final isMe = msg["isMe"] == true;
        final deleted = msg["deleted"] == true;
        final status = "${msg["status"] ?? "sent"}";

        final row = Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onLongPress: () => _messageMenu(msg),
                child: KeyedSubtree(
                  key: _keyFor(msg),
                  child: _bubbleBox(msg, maxW),
                ),
              ),
              if (msg["reaction"] != null && !deleted)
                Transform.translate(
                  offset: const Offset(0, -8),
                  child: Container(
                    margin: EdgeInsets.only(
                        left: isMe ? 0 : 10, right: isMe ? 10 : 0, bottom: 2),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2E),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _bg, width: 2),
                    ),
                    child: Text("${msg["reaction"]}",
                        style: const TextStyle(fontSize: 15)),
                  ),
                ),
              if (isMe && i == lastMine && msg["uploading"] != true)
                Padding(
                  padding: const EdgeInsets.only(right: 6, bottom: 8),
                  child: Text(
                    status == "seen"
                        ? "Visto"
                        : status == "delivered"
                            ? "Entregado"
                            : "Enviado",
                    style: TextStyle(
                      color: status == "seen" ? _seen : Colors.white38,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                const SizedBox(height: 8),
            ],
          ),
        );

        if (!selecting) return row;

        final key = identityHashCode(msg);
        final sel = _selected.contains(key);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() {
            sel ? _selected.remove(key) : _selected.add(key);
          }),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 26,
                height: 26,
                margin: const EdgeInsets.only(right: 12, left: 2, bottom: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: sel ? Colors.white : Colors.transparent,
                  border: Border.all(
                      color: sel ? Colors.white : Colors.white38, width: 2),
                ),
                child: sel
                    ? const Icon(Icons.check_rounded,
                        size: 18, color: Colors.black)
                    : null,
              ),
              Expanded(child: IgnorePointer(child: row)),
            ],
          ),
        );
      },
    );
  }

  Widget _content(Map<String, dynamic> msg, bool deleted) {
    final type = "${msg["type"] ?? "text"}";

    if (deleted) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.block, size: 15, color: Colors.white38),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                msg["isMe"] == true
                    ? "Eliminaste este mensaje"
                    : "Se eliminó este mensaje",
                style: const TextStyle(
                  color: Colors.white54,
                  fontStyle: FontStyle.italic,
                  fontSize: 14.5,
                ),
              ),
            ),
          ],
        ),
      );
    }

    switch (type) {
      case "image":
        return _imageContent(msg);
      case "video":
        return _videoContent(msg);
      case "audio":
        return _AudioBubble(
          key: ValueKey(msg.hashCode),
          url: msg["url"] as String?,
          path: msg["path"] as String?,
          seconds: (msg["duration"] as int?) ?? 0,
          uploading: msg["uploading"] == true,
          mine: msg["isMe"] == true,
        );
      default:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Text(
            "${msg["text"] ?? ""}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15.5,
              height: 1.25,
            ),
          ),
        );
    }
  }

  Widget _mediaBox({required Widget child, required bool uploading}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 230,
        height: 230,
        child: Stack(
          fit: StackFit.expand,
          children: [
            child,
            if (uploading)
              Container(
                color: Colors.black45,
                child: const Center(
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _imageContent(Map<String, dynamic> msg) {
    final url = msg["url"] as String?;
    final path = msg["path"] as String?;
    final uploading = msg["uploading"] == true;

    final img = url != null
        ? Image.network(url, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: _bubble))
        : (path != null
            ? Image.file(File(path), fit: BoxFit.cover)
            : Container(color: _bubble));

    return GestureDetector(
      onTap: uploading
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => _ImageViewer(url: url, path: path),
                ),
              ),
      child: _mediaBox(child: img, uploading: uploading),
    );
  }

  Widget _videoContent(Map<String, dynamic> msg) {
    final url = msg["url"] as String?;
    final uploading = msg["uploading"] == true;

    final thumb = url != null
        ? Image.network(
            url.replaceAll(
              RegExp(r'\.(mp4|mov|m4v|webm|3gp)$', caseSensitive: false),
              '.jpg',
            ),
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: const Color(0xFF12121A)),
          )
        : Container(color: const Color(0xFF12121A));

    return GestureDetector(
      onTap: (uploading || url == null)
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => _VideoPage(url: url)),
              ),
      child: _mediaBox(
        uploading: uploading,
        child: Stack(
          fit: StackFit.expand,
          children: [
            thumb,
            if (!uploading)
              Center(
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 34),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _mmss(int s) =>
      "${(s ~/ 60)}:${(s % 60).toString().padLeft(2, '0')}";

  Widget _buildInputArea() {
    final hasText = controller.text.trim().isNotEmpty;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (editing != null)
            Container(
              margin: const EdgeInsets.fromLTRB(14, 6, 14, 0),
              padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
              decoration: BoxDecoration(
                color: _bubble,
                borderRadius: BorderRadius.circular(16),
                border: const Border(left: BorderSide(color: _pink, width: 4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.edit_rounded, color: _pink, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Editando: ${editing!["text"]}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() => editing = null);
                      controller.clear();
                    },
                    icon: const Icon(Icons.close, color: Colors.white54),
                  ),
                ],
              ),
            ),
          if (replying != null && editing == null)
            Container(
              margin: const EdgeInsets.fromLTRB(14, 6, 14, 0),
              padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
              decoration: BoxDecoration(
                color: _bubble,
                borderRadius: BorderRadius.circular(16),
                border: const Border(left: BorderSide(color: _pink, width: 4)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          replying!["isMe"] == true ? "Tú" : widget.name,
                          style: const TextStyle(
                            color: _pink,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          _previewOf(replying!),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => replying = null),
                    icon: const Icon(Icons.close, color: Colors.white54),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: (recording && recLocked) ? _recordingBar() : _composer(hasText),
          ),
        ],
      ),
    );
  }

  Widget _composer(bool hasText) {
    final rec = recording && !recLocked;
    final double slide = _dx.clamp(-150.0, 0.0).toDouble();
    final double lockProgress = (-_dy / 90).clamp(0.0, 1.0).toDouble();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          children: [
            rec
                ? const SizedBox(width: 0)
                : GestureDetector(
                    onTap: _attachSheet,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                          color: _bubble, shape: BoxShape.circle),
                      child: const Icon(Icons.add_rounded,
                          color: Colors.white, size: 26),
                    ),
                  ),
            SizedBox(width: rec ? 0 : 8),
            Expanded(
              child: rec
                  ? Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: _bubble,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          _cancelArmed
                              ? const Icon(Icons.delete_rounded,
                                  color: Colors.redAccent, size: 22)
                              : const _BlinkDot(),
                          const SizedBox(width: 10),
                          Text(
                            _mmss(recSeconds),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Opacity(
                            opacity: (1 + slide / 150).clamp(0.2, 1.0).toDouble(),
                            child: Transform.translate(
                              offset: Offset(slide * 0.5, 0),
                              child: Text(
                                _cancelArmed
                                    ? "Suelta para cancelar"
                                    : "‹  Desliza para cancelar",
                                style: TextStyle(
                                  color: _cancelArmed
                                      ? Colors.redAccent
                                      : Colors.white54,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.only(left: 18, right: 6),
                      decoration: BoxDecoration(
                        color: _bubble,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              minLines: 1,
                              maxLines: 5,
                              style: const TextStyle(color: Colors.white),
                              textCapitalization:
                                  TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                hintText: "Mensaje",
                                hintStyle: TextStyle(color: Colors.white38),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (!hasText && editing == null)
                            IconButton(
                              onPressed: () => _pickPhoto(ImageSource.camera),
                              icon: const Icon(Icons.photo_camera_rounded,
                                  color: Colors.white60),
                            ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(width: 8),
            _micButton(hasText, rec),
          ],
        ),

        // Candado: sube con el dedo y se fija la grabación
        if (rec)
          Positioned(
            right: 0,
            bottom: 62 + lockProgress * 24,
            child: Container(
              width: 46,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: _lockArmed ? _pink : _bubble,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    _lockArmed ? Icons.lock_rounded : Icons.lock_open_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(height: 6),
                  const Icon(Icons.keyboard_arrow_up_rounded,
                      color: Colors.white54, size: 22),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _micButton(bool hasText, bool rec) {
    final sendMode = hasText || editing != null;
    return GestureDetector(
      onTap: sendMode
          ? sendText
          : () => _snack("Mantén presionado el micrófono para grabar."),
      onLongPressStart: sendMode ? null : (_) => _micDown(),
      onLongPressMoveUpdate:
          sendMode ? null : (d) => _micMove(d.offsetFromOrigin),
      onLongPressEnd: sendMode ? null : (_) => _micUp(),
      onLongPressCancel: sendMode
          ? null
          : () {
              if (recording && !recLocked) _stopRecording(send: false);
            },
      child: AnimatedScale(
        scale: rec ? 1.5 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(colors: [_pink, _coral]),
            boxShadow: rec
                ? [
                    BoxShadow(
                      color: _pink.withValues(alpha: 0.5),
                      blurRadius: 20,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            editing != null
                ? Icons.check_rounded
                : (hasText ? Icons.send_rounded : Icons.mic_rounded),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _recordingBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _stopRecording(send: false),
          child: Container(
            width: 50,
            height: 50,
            decoration:
                const BoxDecoration(color: _bubble, shape: BoxShape.circle),
            child: const Icon(Icons.delete_outline_rounded,
                color: Colors.redAccent),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: _bubble,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                const _BlinkDot(),
                const SizedBox(width: 10),
                Text(
                  _mmss(recSeconds),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Grabando nota de voz…",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () => _stopRecording(send: true),
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [_pink, _coral]),
            ),
            child: const Icon(Icons.send_rounded, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _BlinkDot extends StatefulWidget {
  const _BlinkDot();

  @override
  State<_BlinkDot> createState() => _BlinkDotState();
}

class _BlinkDotState extends State<_BlinkDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.25, end: 1.0).animate(_c),
      child: Container(
        width: 11,
        height: 11,
        decoration: const BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Burbuja de nota de voz con reproducción.
class _AudioBubble extends StatefulWidget {
  final String? url;
  final String? path;
  final int seconds;
  final bool uploading;
  final bool mine;

  const _AudioBubble({
    super.key,
    required this.url,
    required this.path,
    required this.seconds,
    required this.uploading,
    required this.mine,
  });

  @override
  State<_AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<_AudioBubble> {
  final AudioPlayer _player = AudioPlayer();
  bool playing = false;
  Duration position = Duration.zero;
  Duration total = Duration.zero;
  final List<StreamSubscription> _subs = [];

  @override
  void initState() {
    super.initState();
    total = Duration(seconds: widget.seconds);
    _subs.add(_player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          playing = false;
          position = Duration.zero;
        });
      }
    }));
    _subs.add(_player.onPositionChanged.listen((p) {
      if (mounted) setState(() => position = p);
    }));
    _subs.add(_player.onDurationChanged.listen((d) {
      if (mounted && d.inMilliseconds > 0) setState(() => total = d);
    }));
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (widget.uploading) return;
    try {
      if (playing) {
        await _player.pause();
        setState(() => playing = false);
      } else {
        if (position == Duration.zero) {
          final Source src = widget.url != null
              ? UrlSource(widget.url!)
              : DeviceFileSource(widget.path!);
          await _player.play(src);
        } else {
          await _player.resume();
        }
        setState(() => playing = true);
      }
    } catch (e) {
      debugPrint("Error reproduciendo audio: $e");
    }
  }

  String _fmt(Duration d) =>
      "${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    final progress = total.inMilliseconds == 0
        ? 0.0
        : (position.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
    const bars = 26;

    return SizedBox(
      width: 220,
      child: Row(
        children: [
          GestureDetector(
            onTap: _toggle,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: widget.uploading
                  ? const Padding(
                      padding: EdgeInsets.all(11),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Icon(
                      playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 26,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(bars, (i) {
                      final h = 6.0 + ((i * 7 + 3) % 5) * 4.0;
                      final active = (i / bars) <= progress && progress > 0;
                      return Expanded(
                        child: Center(
                          child: Container(
                            width: 2.5,
                            height: h,
                            decoration: BoxDecoration(
                              color: active
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  playing || position > Duration.zero
                      ? _fmt(position)
                      : _fmt(total),
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final String? url;
  final String? path;
  const _ImageViewer({this.url, this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          maxScale: 5,
          child: url != null
              ? Image.network(url!)
              : Image.file(File(path!)),
        ),
      ),
    );
  }
}

class _VideoPage extends StatefulWidget {
  final String url;
  const _VideoPage({required this.url});

  @override
  State<_VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<_VideoPage> {
  late final VideoPlayerController _c;
  bool ready = false;

  @override
  void initState() {
    super.initState();
    _c = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => ready = true);
        _c.play();
      });
    _c.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: !ready
            ? const CircularProgressIndicator(color: Colors.white)
            : GestureDetector(
                onTap: () => _c.value.isPlaying ? _c.pause() : _c.play(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _c.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          VideoPlayer(_c),
                          if (!_c.value.isPlaying)
                            Container(
                              width: 70,
                              height: 70,
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.play_arrow_rounded,
                                  color: Colors.white, size: 46),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: VideoProgressIndicator(
                        _c,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: _pink,
                          bufferedColor: Colors.white24,
                          backgroundColor: Colors.white12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
