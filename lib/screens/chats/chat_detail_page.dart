import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/app_data.dart';

class ChatDetailPage extends StatefulWidget {
  final String name;
  final String image;

  const ChatDetailPage({
    super.key,
    required this.name,
    required this.image,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  bool isRecording = false;

  List<Map<String, dynamic>> get messages {
    final chat = AppData.chats.firstWhere(
      (c) => c["name"] == widget.name,
      orElse: () => {},
    );

    if (chat.isNotEmpty) {
      return List<Map<String, dynamic>>.from(chat["messages"]);
    }

    return [];
  }

  Map<String, dynamic> get chat {
    return AppData.chats.firstWhere(
      (c) => c["name"] == widget.name,
      orElse: () => {},
    );
  }

  void sendMessage() {
    if (controller.text.trim().isEmpty) return;

    final msg = {
      "text": controller.text,
      "isMe": true,
      "time": AppData.getTime(),
      "status": "sent",
    };

    final currentChat = chat;

    setState(() {
      currentChat["messages"].add(msg);
      currentChat["lastMessage"] = controller.text;
      currentChat["time"] = AppData.getTime();
    });

    controller.clear();

    Future.delayed(const Duration(seconds: 1), () {
      msg["status"] = "delivered";
      setState(() {});
    });

    Future.delayed(const Duration(seconds: 2), () {
      msg["status"] = "seen";
      setState(() {});
    });

    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (!scrollController.hasClients) return;

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  Widget buildCheck(String status) {
    if (status == "sent") {
      return const Icon(Icons.check, size: 14, color: Colors.white70);
    } else if (status == "delivered") {
      return const Icon(Icons.done_all, size: 14, color: Colors.white70);
    }

    return const Icon(Icons.done_all, size: 14, color: Colors.lightBlueAccent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070D),

      body: SafeArea(
        child: Column(
          children: [

            /// HEADER CUSTOM
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
              child: Column(
                children: [

                  Row(
                    children: [

                      _circleButton(
                        Icons.arrow_back_ios_new,
                        () => Navigator.pop(context),
                      ),

                      const Spacer(),

                      _circleButton(
                        Icons.more_horiz,
                        () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  CircleAvatar(
                    radius: 34,
                    backgroundImage: NetworkImage(widget.image),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white10,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Text(
                          widget.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(width: 6),

                        const Icon(
                          Icons.verified,
                          size: 16,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.06),
            ),

            /// MENSAJES
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                itemCount: messages.length + 1,
                itemBuilder: (context, index) {

                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Column(
                        children: [

                          Text(
                            "HICISTE MATCH CON ${widget.name.toUpperCase()}",
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Hoy, ${AppData.getTime()}",
                            style: const TextStyle(
                              color: Colors.white30,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final msg = messages[index - 1];
                  final isMe = msg["isMe"];

                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment:
                          isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [

                        Container(
                          constraints: const BoxConstraints(
                            maxWidth: 280,
                          ),
                          margin: const EdgeInsets.only(bottom: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
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
                                : Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isMe
                                    ? Colors.blue.withValues(alpha: 0.25)
                                    : Colors.black.withValues(alpha: 0.25),
                                blurRadius: 15,
                              )
                            ],
                          ),
                          child: Text(
                            msg["text"],
                            style: TextStyle(
                              color:
                                  isMe ? Colors.white : Colors.white70,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ),

                        if (isMe)
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8,
                              bottom: 14,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Text(
                                  msg["time"] ?? "",
                                  style: const TextStyle(
                                    color: Colors.white30,
                                    fontSize: 11,
                                  ),
                                ),

                                const SizedBox(width: 4),

                                buildCheck(
                                  msg["status"] ?? "sent",
                                ),
                              ],
                            ),
                          )
                        else
                          const SizedBox(height: 14),
                      ],
                    ),
                  );
                },
              ),
            ),

            /// INPUT AREA
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
                child: Row(
                  children: [

                    _inputActionButton(Icons.gif_box_outlined),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white10,
                          ),
                        ),
                        child: TextField(
                          controller: controller,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Escribe un mensaje",
                            hintStyle: TextStyle(
                              color: Colors.white38,
                            ),
                            border: InputBorder.none,
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
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF2F6BFF),
                              Color(0xFF4A8DFF),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.35),
                              blurRadius: 15,
                            )
                          ],
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                        ),
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

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: Colors.white70),
      ),
    );
  }

  Widget _inputActionButton(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white10),
      ),
      child: Icon(icon, color: Colors.white70),
    );
  }
}