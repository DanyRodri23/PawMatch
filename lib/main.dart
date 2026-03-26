import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
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

  final recorder = AudioRecorder();
  final player = AudioPlayer();

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

  /// 🎤 GRABAR AUDIO (FIX)
  Future<void> startRecording() async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await recorder.start(
      const RecordConfig(),
      path: path,
    );

    setState(() {
      isRecording = true;
      recordSeconds = 0;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => recordSeconds++);
    });
  }

  /// 🛑 DETENER AUDIO
  Future<void> stopRecording() async {
    timer?.cancel();

    final path = await recorder.stop();

    setState(() => isRecording = false);

    if (path != null) {

      final msg = {
        "audio": path,
        "isMe": true,
        "time": AppData.getTime(),
        "status": "sent",
      };

      chat["messages"].add(msg);
      chat["lastMessage"] = "🎤 Audio";
      chat["time"] = AppData.getTime();

      Future.delayed(const Duration(seconds: 1), () {
        msg["status"] = "delivered";
        setState(() {});
      });

      Future.delayed(const Duration(seconds: 2), () {
        msg["status"] = "seen";
        setState(() {});
      });

      setState(() {});
    }

    scrollToBottom();
  }

  /// ▶️ REPRODUCIR AUDIO
  Future<void> playAudio(String path) async {
    await player.play(DeviceFileSource(path));
  }

  /// 📩 MENSAJE TEXTO
  void sendMessage() {
    if (controller.text.trim().isEmpty) return;

    final msg = {
      "text": controller.text,
      "isMe": true,
      "time": AppData.getTime(),
      "status": "sent",
    };

    setState(() {
      chat["messages"].add(msg);
      chat["lastMessage"] = controller.text;
      chat["time"] = AppData.getTime();
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
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

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
        title: Text(widget.name, style: const TextStyle(color: Colors.black)),
      ),

      body: Column(
        children: [

          /// MENSAJES
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(15),
              itemCount: messages.length,

              itemBuilder: (context, index) {

                final msg = messages[index];
                final isMe = msg["isMe"];
                final isAudio = msg["audio"] != null;

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,

                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xffFF9F1C) : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        if (isAudio)
                          GestureDetector(
                            onTap: () => playAudio(msg["audio"]),
                            child: const Icon(Icons.play_arrow),
                          )
                        else
                          Text(
                            msg["text"],
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),

                        const SizedBox(height: 4),

                        if (isMe)
                          buildCheck(msg["status"] ?? "sent"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// GRABANDO
          if (isRecording)
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.red.withValues(alpha: 0.1),
              child: Text("Grabando... $recordSeconds s"),
            ),

          /// INPUT
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,

            child: Row(
              children: [

                GestureDetector(
                  onLongPressStart: (_) => startRecording(),
                  onLongPressEnd: (_) => stopRecording(),
                  child: const Icon(Icons.mic),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Mensaje...",
                      border: InputBorder.none,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: sendMessage,
                  child: const Icon(Icons.send),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}