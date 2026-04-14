class ChatsData {
  static List<Map<String, dynamic>> chats = [];

  static void createChat(Map<String, dynamic> pet) {
    if (!chats.any((chat) => chat["id"] == pet["id"])) {
      chats.add({
        "id": pet["id"],
        "name": pet["name"],

        "image": (pet["images"] != null &&
                pet["images"] is List &&
                pet["images"].isNotEmpty)
            ? pet["images"][0]
            : "",

        "images": pet["images"] ?? [],

        "petData": pet,

        "lastMessage": "",

        "messages": [],

        "unread": 0,

        "time": "Ahora",

        "verified": pet["pedigree"] ?? false,

        /// NUEVO → FECHA DE MATCH
        "matchDate": DateTime.now(),
      });
    }
  }

  static void sendMessage(
    String chatId,
    String message,
  ) {
    final chat = chats.firstWhere(
      (chat) => chat["id"] == chatId,
    );

    (chat["messages"] as List).add({
      "text": message,
      "isMe": true,
      "time": DateTime.now(),
    });

    chat["lastMessage"] = message;

    chat["time"] = "Ahora";
  }

  static List<Map<String, dynamic>> getMessages(
    String chatId,
  ) {
    final chat = chats.firstWhere(
      (chat) => chat["id"] == chatId,
    );

    return List<Map<String, dynamic>>.from(
      chat["messages"],
    );
  }

  static void markAsRead(String chatId) {
    final chat = chats.firstWhere(
      (chat) => chat["id"] == chatId,
    );

    chat["unread"] = 0;
  }

  /// NUEVO → OBTENER CHAT COMPLETO
  static Map<String, dynamic>? getChatById(
    String chatId,
  ) {
    final exists = chats.any(
      (chat) => chat["id"] == chatId,
    );

    if (!exists) {
      return null;
    }

    return chats.firstWhere(
      (chat) => chat["id"] == chatId,
    );
  }

  /// NUEVO → OBTENER FECHA MATCH
  static DateTime? getMatchDate(
    String chatId,
  ) {
    final chat = getChatById(chatId);

    if (chat == null) {
      return null;
    }

    return chat["matchDate"];
  }
}