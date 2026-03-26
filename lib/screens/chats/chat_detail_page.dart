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

  /// 🔥 AUDIO DESACTIVADO (solo visual)
  bool isRecording = false;
  int recordSeconds = 0;
  Timer? timer;

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

  /// 🎤 AUDIO (DESACTIVADO)
  void startRecording() {
    // ❌ ya no hace nada real
    setState(() {
      isRecording = true;
    });
  }

  void stopRecording() {
    // ❌ no guarda audio ni mensaje
    setState(() {
      isRecording = false;
    });
  }

  void sendMessage() {
    if (controller.text.trim().isEmpty) return;

    final msg = {
      "text": controller.text,
      "isMe": true,
      "time": AppData.getTime(),
      "status": "sent",
    };

    final chat = this.chat;

    setState(() {
      chat["messages"].add(msg);
      chat["lastMessage"] = controller.text;
      chat["time"] = AppData.getTime();
    });

    controller.clear();

    /// 🔥 SIMULAR WHATSAPP
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
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  /// 🔥 ICONO CHECK
  Widget buildCheck(String status) {
    if (status == "sent") {
      return const Icon(Icons.check, size: 16, color: Colors.white70);
    } else if (status == "delivered") {
      return const Icon(Icons.done_all, size: 16, color: Colors.white70);
    } else {
      return const Icon(Icons.done_all, size: 16, color: Colors.blue);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.image),
            ),
            const SizedBox(width: 10),
            Text(widget.name,
                style: const TextStyle(color: Colors.black)),
          ],
        ),
      ),

      body: Column(
        children: [

          /// 💬 MENSAJES
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(15),
              itemCount: messages.length,

              itemBuilder: (context, index) {

                final msg = messages[index];
                final isMe = msg["isMe"];
                final text = msg["text"];

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,

                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: isMe
                          ? const Color(0xffFF9F1C)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        /// TEXTO
                        Text(
                          text,
                          style: TextStyle(
                            color: isMe
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),

                        const SizedBox(height: 4),

                        /// CHECK
                        if (isMe)
                          buildCheck(msg["status"] ?? "sent"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// 🎤 INDICADOR VISUAL
          if (isRecording)
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.red.withValues(alpha: 0.1),
              child: const Text("Grabando..."),
            ),

          /// 📩 INPUT PRO
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,

            child: Row(
              children: [

                /// 🎤 BOTÓN (SOLO VISUAL)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isRecording = !isRecording;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isRecording ? Colors.red : Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isRecording ? Icons.mic : Icons.mic_none,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                /// INPUT
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Mensaje...",
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                /// BOTÓN ENVIAR
                GestureDetector(
                  onTap: sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xffFF9F1C),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}