import 'dart:async';
import 'package:flutter/material.dart';

import '../../data/chats_data.dart';
import '../../data/matches_data.dart';
import '../match/pet_detail_screen.dart';
import '../../services/chat_service.dart';

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
  State<ChatDetailPage> createState() =>
      _ChatDetailPageState();
}

class _ChatDetailPageState
    extends State<ChatDetailPage> {

  final TextEditingController controller =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

      StreamSubscription? chatSubscription;
      List<Map<String, dynamic>> liveMessages = [];

      String get chatId =>
        widget.matchPet?["id"] ?? widget.name;    

  Map<String, dynamic>? get currentChat {
    final exists = ChatsData.chats.any(
      (chat) => chat["name"] == widget.name,
    );

    if (!exists) return null;

    return ChatsData.chats.firstWhere(
      (chat) => chat["name"] == widget.name,
    );
  }

  List<Map<String, dynamic>> get messages {
    final chat = currentChat;

    if (chat == null) return [];

    return List<Map<String, dynamic>>.from(
      chat["messages"] ?? [],
    );
  }

  String getCurrentTime() {
    final now = DateTime.now();

    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  String getRelativeMatchTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      return "Hoy";
    }

    if (difference.inDays == 1) {
      return "Ayer";
    }

    if (difference.inDays < 7) {
      return "Hace ${difference.inDays} días";
    }

    if (difference.inDays < 30) {
      final weeks =
          (difference.inDays / 7).floor();

      return weeks == 1
          ? "Hace 1 semana"
          : "Hace $weeks semanas";
    }

    if (difference.inDays < 365) {
      final months =
          (difference.inDays / 30).floor();

      return months == 1
          ? "Hace 1 mes"
          : "Hace $months meses";
    }

    final years =
        (difference.inDays / 365).floor();

    return years == 1
        ? "Hace 1 año"
        : "Hace $years años";
  }

  void openPetProfile() {
    Map<String, dynamic>? petData;

    if (widget.fromMatch &&
        widget.matchPet != null) {
      petData = widget.matchPet;
    } else {
      final chat = currentChat;

      if (chat != null) {
        petData = chat["petData"];
      }
    }

    if (petData == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            PetDetailScreen(
          pet: petData!,
        ),
      ),
    );
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

    if (pet != null) {
      ChatsData.reportUser(pet["id"]);
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Reporte enviado correctamente",
        ),
      ),
    );
  }

  void showSafetyTools() {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          const Color(0xFF111111),
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.all(20),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration:
                      BoxDecoration(
                    color: Colors.white24,
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Herramientas de seguridad",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _sheetOption(
                  "Cancelar Match",
                  "Ya no te interesa, elimínalo de tus matches",
                  cancelMatch,
                ),
                _sheetOption(
                  "Bloquear",
                  "No verás perfiles ni ellos te verán",
                  blockUser,
                ),
                _sheetOption(
                  "Denunciar",
                  "No te preocupes, lo contaremos",
                  reportUser,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _sheetOption(
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      onTap: onTap,
      contentPadding:
          EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight:
              FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.white54,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white38,
        size: 16,
      ),
    );
  }

  Future<void> sendMessage() async {
  final text = controller.text.trim();

  if (text.isEmpty) return;

  // Mantiene tu lógica de crear chat desde match
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

    if (widget.matchPet != null) {
      MatchesData.removeMatch(widget.matchPet!);
    }
  }

  final chat = currentChat;
  if (chat == null) return;

  final newMessage = {
    "text": text,
    "isMe": true,
    "time": getCurrentTime(),
    "status": "sent",
  };

  // Mantiene UI local (checks y hora)
  setState(() {
    (chat["messages"] as List).add(newMessage);
    chat["lastMessage"] = text;
    chat["time"] = getCurrentTime();
  });

  controller.clear();

  //Firebase (nuevo)
  await ChatService.sendMessage(
    chatId: chatId,
    senderId: "me",
    text: text,
  );

  // Estados visuales
  Future.delayed(const Duration(seconds: 1), () {
    newMessage["status"] = "delivered";
    if (mounted) setState(() {});
  });

  Future.delayed(const Duration(seconds: 2), () {
    newMessage["status"] = "seen";
    if (mounted) setState(() {});
  });

  scrollToBottom();
}

  void scrollToBottom() {
    Future.delayed(
      const Duration(
        milliseconds: 250,
      ),
      () {
        if (!scrollController.hasClients) {
          return;
        }

        scrollController.animateTo(
          scrollController.position
              .maxScrollExtent,
          duration:
              const Duration(
            milliseconds: 350,
          ),
          curve: Curves.easeOut,
        );
      },
    );
  }

  Widget buildCheck(String status) {
    if (status == "sent") {
      return const Icon(
        Icons.check,
        size: 14,
        color: Colors.white70,
      );
    }

    if (status == "delivered") {
      return const Icon(
        Icons.done_all,
        size: 14,
        color: Colors.white70,
      );
    }

    return const Icon(
      Icons.done_all,
      size: 14,
      color:
          Colors.lightBlueAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF050505),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildDivider(),
            Expanded(
              child:
                  _buildMessagesList(),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        18,
      ),
      child: Column(
        children: [
          Row(
            children: [
              _circleButton(
                Icons.arrow_back_ios_new,
                () => Navigator.pop(
                  context,
                ),
              ),
              const Spacer(),
              _circleButton(
                Icons.more_horiz,
                showSafetyTools,
              ),
            ],
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: openPetProfile,
            child: CircleAvatar(
              radius: 34,
              backgroundImage:
                  NetworkImage(
                widget.image,
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: openPetProfile,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white
                    .withValues(
                  alpha: 0.05,
                ),
                borderRadius:
                    BorderRadius.circular(
                  30,
                ),
                border: Border.all(
                  color: Colors.white10,
                ),
              ),
              child: Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Text(
                    widget.name,
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.verified,
                    size: 16,
                    color:
                        Colors.blueAccent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: Colors.white.withValues(
        alpha: 0.06,
      ),
    );
  }

  Widget _buildMessagesList() {
    final chat = currentChat;

    final DateTime? matchDate = widget.fromMatch
        ? (widget.matchPet?["matchDate"] as DateTime?)
        : (chat?["matchDate"] as DateTime?);
        
    return ListView.builder(
      controller: scrollController,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 24,
      ),
      itemCount: messages.length + 1,
      itemBuilder:
          (context, index) {
        if (index == 0) {
          return Padding(
            padding:
                const EdgeInsets.only(
              bottom: 26,
            ),
            child: Column(
              children: [
                Text(
                  "HICISTE MATCH CON ${widget.name.toUpperCase()}",
                  style:
                      const TextStyle(
                    color:
                        Colors.white54,
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  matchDate != null
                      ? getRelativeMatchTime(
                          matchDate,
                        )
                      : "",
                  style:
                      const TextStyle(
                    color:
                        Colors.white30,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          );
        }

        final msg =
            messages[index - 1];

        final isMe =
            msg["isMe"] == true;

        return Align(
          alignment: isMe
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                constraints:
                    const BoxConstraints(
                  maxWidth: 280,
                ),
                margin:
                    const EdgeInsets.only(
                  bottom: 4,
                ),
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration:
                    BoxDecoration(
                  gradient: isMe
                      ? const LinearGradient(
                          colors: [
                            Color(0xFF2F6BFF),
                            Color(0xFF4A8DFF),
                          ],
                        )
                      : null,
                  color: isMe
                      ? null
                      : Colors.white
                          .withValues(
                        alpha: 0.06,
                      ),
                  borderRadius:
                      BorderRadius.circular(
                    24,
                  ),
                ),
                child: Text(
                  msg["text"] ?? "",
                  style: TextStyle(
                    color: isMe
                        ? Colors.white
                        : Colors.white70,
                    fontSize: 15,
                  ),
                ),
              ),
              if (isMe)
                Padding(
                  padding:
                      const EdgeInsets.only(
                    right: 8,
                    bottom: 14,
                  ),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Text(
                        msg["time"] ?? "",
                        style:
                            const TextStyle(
                          color:
                              Colors.white30,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 4),
                      buildCheck(
                        msg["status"] ??
                            "sent",
                      ),
                    ],
                  ),
                )
              else
                const SizedBox(
                  height: 14,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return SafeArea(
      top: false,
      child: Padding(
        padding:
            const EdgeInsets.fromLTRB(
          14,
          8,
          14,
          14,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                decoration:
                    BoxDecoration(
                  color: Colors.white
                      .withValues(
                    alpha: 0.05,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),
                ),
                child: TextField(
                  controller:
                      controller,
                  style:
                      const TextStyle(
                    color:
                        Colors.white,
                  ),
                  decoration:
                      const InputDecoration(
                    hintText:
                        "Escribe un mensaje",
                    hintStyle:
                        TextStyle(
                      color:
                          Colors.white38,
                    ),
                    border:
                        InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: sendMessage,
              child: Container(
                width: 52,
                height: 52,
                decoration:
                    const BoxDecoration(
                  shape:
                      BoxShape.circle,
                  gradient:
                      LinearGradient(
                    colors: [
                      Color(0xFF2F6BFF),
                      Color(0xFF4A8DFF),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color:
                      Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white
              .withValues(
            alpha: 0.05,
          ),
          border: Border.all(
            color: Colors.white10,
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white70,
        ),
      ),
    );
  }
}