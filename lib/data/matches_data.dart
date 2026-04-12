class MatchesData {
  static List<Map<String, dynamic>> matches = [];

  static void createMatch(Map<String, dynamic> pet) {
    final exists = matches.any(
      (m) => m["id"] == pet["id"],
    );

    if (!exists) {
      matches.add(
        Map<String, dynamic>.from(pet),
      );
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