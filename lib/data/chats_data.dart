class ChatsData {
  static List<Map<String, dynamic>> chats = [];

  static List<String> blockedUsers = [];
  static List<String> reports = [];

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

    final newMessage = {
      "text": message,
      "isMe": true,
      "time": DateTime.now(),
    };

    (chat["messages"] as List).add(newMessage);

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

  static Map<String, dynamic>? getChatById(
    String chatId,
  ) {
    final exists = chats.any(
      (chat) => chat["id"] == chatId,
    );

    if (!exists) return null;

    return chats.firstWhere(
      (chat) => chat["id"] == chatId,
    );
  }

  static DateTime? getMatchDate(
    String chatId,
  ) {
    final chat = getChatById(chatId);

    if (chat == null) return null;

    return chat["matchDate"];
  }

  static void removeChatById(
    String chatId,
  ) {
    chats.removeWhere(
      (chat) => chat["id"] == chatId,
    );
  }

  static void blockUser(
    String chatId,
  ) {
    blockedUsers.add(chatId);
    removeChatById(chatId);
  }

  static void reportUser(
    String chatId,
  ) {
    reports.add(chatId);
  }
}