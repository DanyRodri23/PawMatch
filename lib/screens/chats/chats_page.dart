import 'package:flutter/material.dart';
import '../../data/matches_data.dart';
import '../../data/chats_data.dart';
import 'chat_detail_page.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    ChatsData.changes.addListener(_refresh);
  }

  @override
  void dispose() {
    ChatsData.changes.removeListener(_refresh);
    super.dispose();
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
      final weeks = (difference.inDays / 7).floor();

      return weeks == 1
          ? "Hace 1 semana"
          : "Hace $weeks semanas";
    }

    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();

      return months == 1
          ? "Hace 1 mes"
          : "Hace $months meses";
    }

    final years = (difference.inDays / 365).floor();

    return years == 1
        ? "Hace 1 año"
        : "Hace $years años";
  }

  String _img(Map<String, dynamic> pet) {
    final images = pet["images"];
    if (images is List && images.isNotEmpty) return "${images[0]}";
    return "${pet["image"] ?? ""}";
  }

  @override
  Widget build(BuildContext context) {
    final matches = [...MatchesData.matches];
    // Un chat solo aparece en "Mensajes" cuando ya tiene al menos un mensaje.
    final chats = ChatsData.chats
        .where((c) =>
            ((c["messages"] ?? []) as List).isNotEmpty ||
            "${c["lastMessage"] ?? ""}".isNotEmpty)
        .toList();

    chats.sort((a, b) {
      final x = a["updatedAt"];
      final y = b["updatedAt"];
      if (x is DateTime && y is DateTime) return y.compareTo(x);
      return (b["time"] ?? "").toString().compareTo((a["time"] ?? "").toString());
    });

    final bottom = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0F),
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(20, 12, 20, bottom + 24),
          children: [
            const Text(
              "Chat",
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              "Nuevos matches",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            if (matches.isEmpty)
              Container(
                height: 96,
                decoration: BoxDecoration(
                  color: const Color(0xFF16161C),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Center(
                  child: Text(
                    "Cuando hagas match, aparecerá aquí",
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                ),
              )
            else
              SizedBox(
                height: 186,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final pet = matches[index];
                    final image = _img(pet);
                    final DateTime? matchDate = pet["matchDate"] as DateTime?;

                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatDetailPage(
                              name: pet["name"] ?? "",
                              image: image,
                              fromMatch: true,
                              matchPet: pet,
                            ),
                          ),
                        );
                        setState(() {});
                      },
                      child: Container(
                        width: 112,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 132,
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: Colors.pinkAccent,
                                  width: 2.5,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: SizedBox.expand(
                                  child: image.isEmpty
                                      ? Container(
                                          color: const Color(0xFF16161C))
                                      : Image.network(
                                          image,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                            color: const Color(0xFF16161C),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              pet["name"] ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (matchDate != null)
                              Text(
                                getRelativeMatchTime(matchDate),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 26),
            const Text(
              "Mensajes",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            if (chats.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: Column(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 64,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Aún no tienes mensajes",
                      style: TextStyle(color: Colors.white54, fontSize: 15),
                    ),
                  ],
                ),
              )
            else
              ...chats.map((chat) {
                final messages = List<Map<String, dynamic>>.from(
                  chat["messages"] ?? [],
                );
                final previewText = messages.isNotEmpty
                    ? messages.last["text"] ?? ""
                    : chat["lastMessage"] ?? "";
                final typing = chat["typing"] == true;
                final unread = (chat["unread"] ?? 0) is num &&
                    (chat["unread"] as num) > 0;
                final image = "${chat["image"] ?? ""}";

                return InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatDetailPage(
                          name: chat["name"] ?? "",
                          image: image,
                          fromMatch: false,
                          matchPet: chat["petData"],
                        ),
                      ),
                    );
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 31,
                          backgroundColor: const Color(0xFF16161C),
                          backgroundImage:
                              image.isEmpty ? null : NetworkImage(image),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chat["name"] ?? "",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                typing ? "escribiendo…" : "$previewText",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontStyle: typing
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                  color: typing
                                      ? const Color(0xFF53BDEB)
                                      : unread
                                      ? Colors.white
                                      : Colors.white54,
                                  fontWeight: unread
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (unread)
                          Container(
                            width: 11,
                            height: 11,
                            decoration: const BoxDecoration(
                              color: Colors.pinkAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
