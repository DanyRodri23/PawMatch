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
          padding: const EdgeInsets.fromLTRB(
            18,
            10,
            18,
            0,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              /// HEADER PREMIUM
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Chats",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                  ),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.05,
                      ),
                      borderRadius:
                          BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white10,
                      ),
                    ),
                    child: Text(
                      "${matches.length + chats.length}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// NUEVOS MATCHES
              const Text(
                "Nuevos Matches",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              if (matches.isEmpty)
                Container(
                  height: 95,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.03,
                    ),
                    borderRadius:
                        BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white10,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "Sin matches nuevos",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 118,
                  child: ListView.builder(
                    scrollDirection:
                        Axis.horizontal,
                    itemCount: matches.length,
                    itemBuilder:
                        (context, index) {
                      final pet =
                          matches[index];

                      final image =
                          (pet["images"] != null &&
                                  pet["images"]
                                      is List &&
                                  pet["images"]
                                      .isNotEmpty)
                              ? pet["images"][0]
                              : "";

                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ChatDetailPage(
                                name:
                                    pet["name"] ??
                                        "",
                                image: image,
                                fromMatch:
                                    true,
                                matchPet:
                                    pet,
                              ),
                            ),
                          );

                          setState(() {});
                        },
                        child: Container(
                          width: 86,
                          margin:
                              const EdgeInsets.only(
                            right: 14,
                          ),
                          child: Column(
                            children: [

                              Container(
                                padding:
                                    const EdgeInsets
                                        .all(3),
                                decoration:
                                    BoxDecoration(
                                  shape: BoxShape
                                      .circle,
                                  gradient:
                                      const LinearGradient(
                                    colors: [
                                      Color(
                                          0xFFFFC107),
                                      Color(
                                          0xFFFF9800),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors
                                          .orange
                                          .withValues(
                                        alpha:
                                            0.35,
                                      ),
                                      blurRadius:
                                          16,
                                    ),
                                  ],
                                ),
                                child:
                                    CircleAvatar(
                                  radius: 35,
                                  backgroundColor:
                                      Colors
                                          .black,
                                  backgroundImage:
                                      NetworkImage(
                                    image,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                  height: 10),

                              Text(
                                pet["name"] ??
                                    "",
                                maxLines: 1,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style:
                                    const TextStyle(
                                  color: Colors
                                      .white70,
                                  fontSize:
                                      12,
                                  fontWeight:
                                      FontWeight
                                          .w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 30),

              /// MENSAJES
              const Text(
                "Mensajes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              if (chats.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        Icon(
                          Icons
                              .chat_bubble_outline,
                          size: 70,
                          color: Colors.white
                              .withValues(
                            alpha: 0.08,
                          ),
                        ),
                        const SizedBox(
                            height: 14),
                        const Text(
                          "No tienes mensajes aún",
                          style: TextStyle(
                            color:
                                Colors.white54,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    physics:
                        const BouncingScrollPhysics(),
                    itemCount:
                        chats.length,
                    itemBuilder:
                        (context, index) {
                      final chat =
                          chats[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ChatDetailPage(
                                name:
                                    chat["name"] ??
                                        "",
                                image:
                                    chat["image"] ??
                                        "",
                                fromMatch:
                                    false,

                                /// IMPORTANTE
                                matchPet:
                                    chat["petData"],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin:
                              const EdgeInsets.only(
                            bottom: 14,
                          ),
                          padding:
                              const EdgeInsets.all(
                            14,
                          ),
                          decoration:
                              BoxDecoration(
                            color: const Color(
                              0xFF111111,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              24,
                            ),
                            border:
                                Border.all(
                              color:
                                  Colors.white10,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors
                                    .black
                                    .withValues(
                                  alpha:
                                      0.35,
                                ),
                                blurRadius:
                                    14,
                                offset:
                                    const Offset(
                                  0,
                                  8,
                                ),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [

                              Hero(
                                tag: chat[
                                    "name"],
                                child:
                                    CircleAvatar(
                                  radius:
                                      30,
                                  backgroundImage:
                                      NetworkImage(
                                    chat["image"] ??
                                        "",
                                  ),
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

                                    Row(
                                      children: [
                                        Expanded(
                                          child:
                                              Text(
                                            chat["name"] ??
                                                "",
                                            style:
                                                const TextStyle(
                                              color:
                                                  Colors.white,
                                              fontWeight:
                                                  FontWeight.bold,
                                              fontSize:
                                                  16,
                                            ),
                                          ),
                                        ),

                                        if (chat[
                                                "verified"] ==
                                            true)
                                          const Icon(
                                            Icons
                                                .verified,
                                            color:
                                                Colors.blueAccent,
                                            size:
                                                17,
                                          ),
                                      ],
                                    ),

                                    const SizedBox(
                                        height:
                                            6),

                                    Text(
                                      chat["lastMessage"] ??
                                          "",
                                      maxLines:
                                          1,
                                      overflow:
                                          TextOverflow
                                              .ellipsis,
                                      style:
                                          const TextStyle(
                                        color:
                                            Colors.white54,
                                        fontSize:
                                            13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                  width: 12),

                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .end,
                                children: [

                                  Text(
                                    chat["time"] ??
                                        "",
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors.white38,
                                      fontSize:
                                          11,
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                          8),

                                  if ((chat["unread"] ??
                                          0) >
                                      0)
                                    Container(
                                      padding:
                                          const EdgeInsets
                                              .all(
                                        7,
                                      ),
                                      decoration:
                                          const BoxDecoration(
                                        color: Colors
                                            .redAccent,
                                        shape: BoxShape
                                            .circle,
                                      ),
                                      child: Text(
                                        chat["unread"]
                                            .toString(),
                                        style:
                                            const TextStyle(
                                          color:
                                              Colors.white,
                                          fontSize:
                                              10,
                                          fontWeight:
                                              FontWeight.bold,
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