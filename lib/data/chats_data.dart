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
        "lastMessage": "",
        "messages": [],
        "unread": 0,
        "time": "Ahora",
        "verified": pet["pedigree"] ?? false,
      });
    }
  }

  static void sendMessage(String chatId, String message) {
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

  static List<Map<String, dynamic>> getMessages(String chatId) {
    final chat = chats.firstWhere(
      (chat) => chat["id"] == chatId,
    );

    return List<Map<String, dynamic>>.from(chat["messages"]);
  }

  static void markAsRead(String chatId) {
    final chat = chats.firstWhere(
      (chat) => chat["id"] == chatId,
    );

    chat["unread"] = 0;
  }
}