class PetProfileData {
  static Map<String, dynamic> pet = {
    "name": "Max",

    "age": 2,

    "ageType": "años",

    "gender": "Macho",

    "isPureBreed": true,

    "breed": "Golden Retriever",

    "pedigree": true,

    "pedigreeCertificate": "",

    "vaccinated": true,

    "vaccineCard": "",

    "verified": true,

    "images": [
      "https://placedog.net/500?id=1",
    ],

    "traits": [
      "Juguetón",
      "Cariñoso",
      "Activo",
    ],

    "description":
        "Perro juguetón y sociable que ama correr en el parque.",

    "lookingFor":
        "Compañero de juego",
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
    List<String>? images,
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
      pet["ageType"] = ageType;
    }

    if (gender != null) {
      pet["gender"] = gender;
    }

    if (isPureBreed != null) {
      pet["isPureBreed"] = isPureBreed;
    }

    if (breed != null) {
      pet["breed"] = breed;
    }

    if (pedigree != null) {
      pet["pedigree"] = pedigree;
    }

    if (pedigreeCertificate != null) {
      pet["pedigreeCertificate"] =
          pedigreeCertificate;
    }

    if (vaccinated != null) {
      pet["vaccinated"] = vaccinated;
    }

    if (vaccineCard != null) {
      pet["vaccineCard"] = vaccineCard;
    }

    if (verified != null) {
      pet["verified"] = verified;
    }

    if (images != null) {
      pet["images"] = images;
    }

    if (traits != null) {
      pet["traits"] = traits;
    }

    if (description != null) {
      pet["description"] = description;
    }

    if (lookingFor != null) {
      pet["lookingFor"] = lookingFor;
    }
  }
}