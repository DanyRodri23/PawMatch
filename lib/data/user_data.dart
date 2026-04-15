class UserData {
  static Map<String, dynamic> profile = {
    "uid": "demo_user_001",

    "phone": "+506 7173-8448",

    "birthDate": DateTime(2004, 1, 1),

    "age": 21,

    "name": "Daniel",

    "gender": "Hombre",

    "showGender": true,

    "location": "Heredia, Costa Rica",

    "latitude": null,

    "longitude": null,

    "verified": true,

    "images": <dynamic>[
      "https://i.pravatar.cc/500?img=1",
    ],
  };

  static void updateProfile({
    String? uid,
    String? phone,
    DateTime? birthDate,
    int? age,
    String? name,
    String? gender,
    bool? showGender,
    String? location,
    double? latitude,
    double? longitude,
    bool? verified,
    List<dynamic>? images,
  }) {
    if (uid != null) {
      profile["uid"] = uid;
    }

    if (phone != null) {
      profile["phone"] = phone;
    }

    if (birthDate != null) {
      profile["birthDate"] = birthDate;
    }

    if (age != null) {
      profile["age"] = age;
    }

    if (name != null) {
      profile["name"] = name;
    }

    if (gender != null) {
      profile["gender"] = gender;
    }

    if (showGender != null) {
      profile["showGender"] = showGender;
    }

    if (location != null) {
      profile["location"] = location;
    }

    if (latitude != null) {
      profile["latitude"] = latitude;
    }

    if (longitude != null) {
      profile["longitude"] = longitude;
    }

    if (verified != null) {
      profile["verified"] = verified;
    }

    if (images != null) {
      profile["images"] = images;
    }
  }
}