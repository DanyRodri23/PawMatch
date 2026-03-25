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

  void sendMessage() {
    if (controller.text.trim().isEmpty) return;

    setState(() {
      AppData.sendMessage(widget.name, controller.text);
    });

    AppData.autoReply(widget.name);

    controller.clear();
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
            const SizedBox(width: 5),
            const Icon(Icons.verified, color: Colors.blue, size: 18),
          ],
        ),
      ),

      body: Column(
        children: [

          /// 🔥 MENSAJES
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: messages.length,
              itemBuilder: (context, index) {

                final msg = messages[index];
                final isMe = msg["isMe"];

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,

                  child: FractionallySizedBox(
                    widthFactor: 0.7, // 🔥 CLAVE (sin errores)

                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.all(14),

                      decoration: BoxDecoration(
                        color: isMe
                            ? const Color(0xffFF9F1C)
                            : Colors.white,

                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(18),
                          topRight: const Radius.circular(18),
                          bottomLeft:
                              Radius.circular(isMe ? 18 : 4),
                          bottomRight:
                              Radius.circular(isMe ? 4 : 18),
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 5,
                          )
                        ],
                      ),

                      child: Text(
                        msg["text"],
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          /// 🔥 INPUT
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 8),

            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 5)
              ],
            ),

            child: Row(
              children: [

                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15),

                    decoration: BoxDecoration(
                      color: const Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Escribe un mensaje...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                GestureDetector(
                  onTap: sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xffFF9F1C),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.send, color: Colors.white),
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