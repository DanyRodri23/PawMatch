import 'user_profile_data.dart';

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

    _mirrorToProfile(
      name: name,
      gender: gender,
      showGender: showGender,
      age: age,
      birthDate: birthDate,
      images: images,
    );
  }

  /// El onboarding guarda aquí, pero las pantallas de perfil leen
  /// UserProfileData. Se copian los datos para que siempre coincidan.
  static void _mirrorToProfile({
    String? name,
    String? gender,
    bool? showGender,
    int? age,
    DateTime? birthDate,
    List<dynamic>? images,
  }) {
    String? mappedGender;
    if (gender != null) {
      if (gender == "Hombre") {
        mappedGender = "Masculino";
      } else if (gender == "Mujer") {
        mappedGender = "Femenino";
      } else {
        mappedGender = "Prefiero no decir";
      }
    }

    UserProfileData.updateUser(
      name: name,
      age: age,
      gender: mappedGender,
      showGender: showGender,
      images: images?.map((e) => e.toString()).toList(),
    );

    if (birthDate != null) {
      UserProfileData.user["birthDate"] = birthDate;
    }
  }

  /// Deja los datos del onboarding limpios para el usuario que inició sesión
  /// (sin los datos de ejemplo).
  static void resetFor({required String uid, String? phone}) {
    profile = {
      "uid": uid,
      "phone": phone ?? "",
      "birthDate": null,
      "age": 0,
      "name": "",
      "gender": "",
      "showGender": true,
      "location": "",
      "latitude": null,
      "longitude": null,
      "verified": false,
      "images": <dynamic>[],
    };
  }
}