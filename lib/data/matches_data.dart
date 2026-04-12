import 'likes_data.dart';

class MatchesData {
  static List<Map<String, dynamic>> matches = [];

  static bool isMatch(Map<String, dynamic> pet) {
    return LikesData.receivedLikes.contains(pet) &&
        LikesData.sentLikes.contains(pet);
  }

  static void createMatch(Map<String, dynamic> pet) {
    if (isMatch(pet) && !matches.contains(pet)) {
      matches.add(pet);

      LikesData.removeReceivedLike(pet);
      LikesData.removeSentLike(pet);
    }
  }

  static void removeMatch(Map<String, dynamic> pet) {
    matches.remove(pet);
  }

  static bool hasMatch(Map<String, dynamic> pet) {
    return matches.contains(pet);
  }
}