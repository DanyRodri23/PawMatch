class AppData {

  /// 🔥 LIKES
  static List<Map<String, dynamic>> likedPets = [];

  static void addLike(Map<String, dynamic> pet) {
    final exists = likedPets.any((p) => p["name"] == pet["name"]);

    if (!exists) {
      likedPets.add(pet);
    }
  }

  static void clearLikes() {
    likedPets.clear();
  }

  /// 🔥 CHATS
  static List<Map<String, dynamic>> chats = [];

  /// 🕒 FORMATO DE HORA
  static String getTime() {
    final now = DateTime.now();
    return "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
  }

  /// 🔥 CREAR CHAT
  static void createChat(Map<String, dynamic> pet) {

    final exists = chats.any((c) => c["name"] == pet["name"]);

    if (!exists) {
      chats.insert(0, {
        "name": pet["name"],
        "image": pet["images"][0],
        "lastMessage": "¡Hicieron match! 🐾",
        "messages": [
          {
            "text": "¡Hola! 🐶",
            "isMe": false,
            "time": getTime(),
          }
        ],
        "time": getTime(),
        "typing": false,
      });
    }
  }

  /// 🔥 ENVIAR MENSAJE
  static void sendMessage(String name, String message) {

    final index = chats.indexWhere((c) => c["name"] == name);

    if (index != -1) {

      final chat = chats[index];

      chat["messages"].add({
        "text": message,
        "isMe": true,
        "time": getTime(),
      });

      /// 🔥 DETECTAR AUDIO
      if (message.startsWith("🎤")) {
        chat["lastMessage"] = "🎤 Audio";
      } else {
        chat["lastMessage"] = message;
      }

      chat["time"] = getTime();

      /// 🔥 SUBIR CHAT ARRIBA
      chats.removeAt(index);
      chats.insert(0, chat);
    }
  }

  /// 🔥 RESPUESTA AUTOMÁTICA PRO
  static void autoReply(String name) {

    final chat = chats.firstWhere(
      (c) => c["name"] == name,
      orElse: () => {},
    );

    if (chat.isNotEmpty) {

      chat["typing"] = true;

      Future.delayed(const Duration(seconds: 2), () {

        chat["typing"] = false;

        chat["messages"].add({
          "text": "¡Qué lindo! 🐾",
          "isMe": false,
          "time": getTime(),
        });

        chat["lastMessage"] = "¡Qué lindo! 🐾";
        chat["time"] = getTime();
      });
    }
  }
}