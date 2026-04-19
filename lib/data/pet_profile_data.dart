class PetProfileData {
  static Map<String, dynamic> pet = {
    /// IDENTIDAD
    "name": "Max",
    "age": 2,
    "ageType": "años",
    "gender": "Macho",

    /// RAZA
    "isPureBreed": true,
    "breed": "Golden Retriever",

    /// DOCUMENTOS
    "pedigree": true,
    "pedigreeCertificate": "",

    /// SALUD
    "vaccinated": true,
    "vaccineCard": "",

    /// ESTADO
    "verified": true,
    "profileCompleted": true,
    "likes": 0,
    "matches": 0,

    /// UBICACIÓN
    "location": "Heredia, Costa Rica",
    "latitude": null,
    "longitude": null,

    /// MULTIMEDIA
    "images": [
      "https://placedog.net/500?id=1",
    ],

    "videos": <String>[],

    /// PERSONALIDAD
    "traits": [
      "Juguetón",
      "Cariñoso",
      "Activo",
    ],

    /// DESCRIPCIÓN
    "description":
        "Perro juguetón y sociable que ama correr en el parque.",

    /// QUÉ BUSCA
    "lookingFor":
        "Compañero de juego",

    /// FECHAS
    "createdAt":
        DateTime.now(),
    "updatedAt":
        DateTime.now(),
  };

  static void updatePet({
    String? name,
    int? age,
    String? ageType,
    String? gender,
    bool? isPureBreed,
    String? breed,
    bool? pedigree,
    String? pedigreeCertificate,
    bool? vaccinated,
    String? vaccineCard,
    bool? verified,
    bool? profileCompleted,
    int? likes,
    int? matches,
    String? location,
    double? latitude,
    double? longitude,
    List<String>? images,
    List<String>? videos,
    List<String>? traits,
    String? description,
    String? lookingFor,
  }) {
    if (name != null) {
      pet["name"] = name;
    }

    if (age != null) {
      pet["age"] = age;
    }

    if (ageType != null) {
      pet["ageType"] =
          ageType;
    }

    if (gender != null) {
      pet["gender"] =
          gender;
    }

    if (isPureBreed != null) {
      pet["isPureBreed"] =
          isPureBreed;
    }

    if (breed != null) {
      pet["breed"] = breed;
    }

    if (pedigree != null) {
      pet["pedigree"] =
          pedigree;
    }

    if (pedigreeCertificate !=
        null) {
      pet["pedigreeCertificate"] =
          pedigreeCertificate;
    }

    if (vaccinated != null) {
      pet["vaccinated"] =
          vaccinated;
    }

    if (vaccineCard != null) {
      pet["vaccineCard"] =
          vaccineCard;
    }

    if (verified != null) {
      pet["verified"] =
          verified;
    }

    if (profileCompleted !=
        null) {
      pet["profileCompleted"] =
          profileCompleted;
    }

    if (likes != null) {
      pet["likes"] = likes;
    }

    if (matches != null) {
      pet["matches"] =
          matches;
    }

    if (location != null) {
      pet["location"] =
          location;
    }

    if (latitude != null) {
      pet["latitude"] =
          latitude;
    }

    if (longitude != null) {
      pet["longitude"] =
          longitude;
    }

    if (images != null) {
      pet["images"] =
          images;
    }

    if (videos != null) {
      pet["videos"] =
          videos;
    }

    if (traits != null) {
      pet["traits"] =
          traits;
    }

    if (description != null) {
      pet["description"] =
          description;
    }

    if (lookingFor != null) {
      pet["lookingFor"] =
          lookingFor;
    }

    pet["updatedAt"] =
        DateTime.now();
  }

  static void resetPet() {
    pet = {
      "name": "",
      "age": 0,
      "ageType": "años",
      "gender": "",
      "isPureBreed": false,
      "breed": "",
      "pedigree": false,
      "pedigreeCertificate": "",
      "vaccinated": false,
      "vaccineCard": "",
      "verified": false,
      "profileCompleted":
          false,
      "likes": 0,
      "matches": 0,
      "location": "",
      "latitude": null,
      "longitude": null,
      "images": <String>[],
      "videos": <String>[],
      "traits": <String>[],
      "description": "",
      "lookingFor": "",
      "createdAt":
          DateTime.now(),
      "updatedAt":
          DateTime.now(),
    };
  }
}