import 'chats_data.dart';

class MatchesData {
  static List<Map<String, dynamic>> matches = [];

  static void createMatch(Map<String, dynamic> pet) {
    final exists = matches.any(
      (m) => m["id"] == pet["id"],
    );

    // Si ya existe una conversación con mensajes, no vuelve a "Nuevos Matches".
    final chat = ChatsData.getChatById(pet["id"]);
    final alreadyChatting = chat != null &&
        (chat["messages"] as List? ?? []).isNotEmpty;

    if (!exists && !alreadyChatting) {
      matches.add({
        ...Map<String, dynamic>.from(pet),

        /// FECHA DEL MATCH
        "matchDate": DateTime.now(),
      });
    }
  }

  static void removeMatch(Map<String, dynamic> pet) {
    matches.removeWhere(
      (m) => m["id"] == pet["id"],
    );
  }

  static bool hasMatch(Map<String, dynamic> pet) {
    return matches.any(
      (m) => m["id"] == pet["id"],
    );
  }
}