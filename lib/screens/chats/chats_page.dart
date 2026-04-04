import 'package:flutter/material.dart';
import '../../data/app_data.dart';
import 'chat_detail_page.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {

    final chats = [...AppData.chats];

    chats.sort((a, b) =>
        (b["time"] ?? "").compareTo(a["time"] ?? ""));

    return Scaffold(
      backgroundColor: Colors.black, // 🔥 DARK MODE

      body: SafeArea(
        child: Column(
          children: [

            /// 🔥 HEADER
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  Text(
                    "Mensajes",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // 🔥 blanco
                    ),
                  ),
                ],
              ),
            ),

            /// 🔥 SI NO HAY CHATS
            if (chats.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "No tienes mensajes aún 🐶",
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              )

            /// 🔥 LISTA
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: chats.length,

                  itemBuilder: (context, index) {

                    final chat = chats[index];

                    final lastMessage = chat["lastMessage"] ?? "";
                    final isAudio = lastMessage.contains("🎤");

                    /// 🔥 PROTECCIÓN
                    final image = chat["image"];

                    return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 300 + (index * 50)),
                      tween: Tween<double>(begin: 0, end: 1),

                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },

                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatDetailPage(
                                name: chat["name"] ?? "",
                                image: chat["image"] ?? "",
                              ),
                            ),
                          );
                        },

                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05), // 🔥 glass
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),

                          child: Row(
                            children: [

                              /// FOTO
                              Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.grey[900],
                                    backgroundImage: image != null
                                        ? NetworkImage(image)
                                        : null,
                                  ),

                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              const SizedBox(width: 12),

                              /// INFO
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            chat["name"] ?? "",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),

                                        const SizedBox(width: 5),

                                        const Icon(Icons.verified,
                                            color: Colors.blue, size: 16),
                                      ],
                                    ),

                                    const SizedBox(height: 4),

                                    Row(
                                      children: [

                                        if (isAudio)
                                          const Icon(Icons.play_arrow,
                                              size: 16,
                                              color: Colors.white54),

                                        if (isAudio)
                                          const SizedBox(width: 4),

                                        Expanded(
                                          child: Text(
                                            isAudio
                                                ? "Audio"
                                                : lastMessage,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white54,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              /// DERECHA
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [

                                  Text(
                                    chat["time"] ?? "",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white38,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  if ((chat["unread"] ?? 0) > 0)
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        chat["unread"].toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}