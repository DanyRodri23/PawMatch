class LikesData {
  /// Likes que recibes
  static List<Map<String, dynamic>> receivedLikes = [];

  /// Likes que envías
  static List<Map<String, dynamic>> sentLikes = [];

  static void receiveLike(Map<String, dynamic> pet) {
    if (!receivedLikes.contains(pet)) {
      receivedLikes.add(pet);
    }
  }

  static void sendLike(Map<String, dynamic> pet) {
    if (!sentLikes.contains(pet)) {
      sentLikes.add(pet);
    }
  }

  static void removeReceivedLike(Map<String, dynamic> pet) {
    // Se quita por id (no por objeto) para que funcione desde cualquier pantalla.
    receivedLikes.removeWhere((p) => p["id"] == pet["id"]);
  }

  static void removeSentLike(Map<String, dynamic> pet) {
    sentLikes.remove(pet);
  }

  static bool hasReceivedLike(Map<String, dynamic> pet) {
    return receivedLikes.contains(pet);
  }

  static bool hasSentLike(Map<String, dynamic> pet) {
    return sentLikes.contains(pet);
  }
}