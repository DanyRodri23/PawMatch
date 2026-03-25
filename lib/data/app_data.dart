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

  /// 🔥 CREAR CHAT (desde match)
  static void createChat(Map<String, dynamic> pet) {

    final exists = chats.any((c) => c["name"] == pet["name"]);

    if (!exists) {
      chats.add({
        "name": pet["name"],
        "image": pet["images"][0],
        "lastMessage": "¡Hicieron match! 🐾",
        "messages": [
          {
            "text": "¡Hola! 🐶",
            "isMe": false,
          }
        ],
        "time": "Ahora"
      });
    }
  }

  /// 🔥 ENVIAR MENSAJE
  static void sendMessage(String name, String message) {

    final chat = chats.firstWhere(
      (c) => c["name"] == name,
      orElse: () => {},
    );

    if (chat.isNotEmpty) {

      chat["messages"].add({
        "text": message,
        "isMe": true,
      });

      chat["lastMessage"] = message;
      chat["time"] = "Ahora";
    }
  }

  /// 🔥 RESPUESTA FAKE (para demo 🔥)
  static void autoReply(String name) {

    final chat = chats.firstWhere(
      (c) => c["name"] == name,
      orElse: () => {},
    );

    if (chat.isNotEmpty) {

      Future.delayed(const Duration(seconds: 1), () {

        chat["messages"].add({
          "text": "¡Qué lindo! 🐾",
          "isMe": false,
        });

      });
    }
  }

}