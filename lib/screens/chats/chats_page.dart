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
  @override
  Widget build(BuildContext context) {
    final matches = [...MatchesData.matches];
    final chats = [...ChatsData.chats];

    chats.sort(
      (a, b) => (b["time"] ?? "").compareTo(a["time"] ?? ""),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              const Text(
                "Chats",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 24),

              /// NEW MATCHES
              const Text(
                "Nuevos Matches",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              if (matches.isEmpty)
                const SizedBox(
                  height: 80,
                  child: Center(
                    child: Text(
                      "Sin matches nuevos",
                      style: TextStyle(
                        color: Colors.white38,
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      final pet = matches[index];

                      final image =
                          (pet["images"] != null &&
                                  pet["images"] is List &&
                                  pet["images"].isNotEmpty)
                              ? pet["images"][0]
                              : null;

                      return GestureDetector(
                        onTap: () {
                          /// CREA CHAT SI NO EXISTE
                          ChatsData.createChat(pet);

                          /// QUITA DE MATCHES NUEVOS
                          MatchesData.removeMatch(pet);

                          /// REFRESH UI
                          setState(() {});

                          /// ABRE CHAT
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatDetailPage(
                                name: pet["name"] ?? "",
                                image: image ?? "",
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Column(
                            children: [

                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(26),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.amber,
                                      Colors.orange,
                                    ],
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 34,
                                  backgroundColor: Colors.black,
                                  backgroundImage: image != null
                                      ? NetworkImage(image)
                                      : null,
                                ),
                              ),

                              const SizedBox(height: 8),

                              SizedBox(
                                width: 70,
                                child: Text(
                                  pet["name"] ?? "",
                                  maxLines: 1,
                                  overflow:
                                      TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
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
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              if (chats.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      "No tienes mensajes aún",
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];

                      return GestureDetector(
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
                          margin:
                              const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF111111),
                            borderRadius:
                                BorderRadius.circular(22),
                            border: Border.all(
                              color: Colors.white10,
                            ),
                          ),
                          child: Row(
                            children: [

                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(
                                  chat["image"] ?? "",
                                ),
                              ),

                              const SizedBox(width: 14),

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
                                            style:
                                                const TextStyle(
                                              color:
                                                  Colors.white,
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),

                                        if (chat["verified"] ==
                                            true)
                                          const Icon(
                                            Icons.verified,
                                            color: Colors
                                                .blueAccent,
                                            size: 17,
                                          ),
                                      ],
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      chat["lastMessage"] ?? "",
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis,
                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 12),

                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                children: [

                                  Text(
                                    chat["time"] ?? "",
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white38,
                                      fontSize: 12,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  if ((chat["unread"] ?? 0) >
                                      0)
                                    Container(
                                      padding:
                                          const EdgeInsets
                                              .all(7),
                                      decoration:
                                          const BoxDecoration(
                                        color:
                                            Colors.redAccent,
                                        shape:
                                            BoxShape.circle,
                                      ),
                                      child: Text(
                                        chat["unread"]
                                            .toString(),
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.white,
                                          fontSize: 10,
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}