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
    receivedLikes.remove(pet);
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