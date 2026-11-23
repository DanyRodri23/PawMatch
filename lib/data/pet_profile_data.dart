import '../helpers/age_helper.dart';
import '../services/profile_store.dart';

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
    "pedigreeStatus": "none",

    /// SALUD
    "vaccinated": true,
    "vaccineCard": "",
    "vaccineStatus": "none",

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
    String? pedigreeStatus,
    String? vaccineStatus,
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
    DateTime? birthDate,
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

    if (pedigreeStatus != null) {
      pet["pedigreeStatus"] = pedigreeStatus;
    }

    if (vaccineStatus != null) {
      pet["vaccineStatus"] = vaccineStatus;
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

    // La edad se guarda como fecha de nacimiento para que avance sola.
    if (birthDate != null) {
      pet["birthDate"] = birthDate;
      refreshAge();
    } else if (age != null || ageType != null) {
      final a = (pet["age"] as num?)?.toInt() ?? 0;
      final u = (pet["ageType"] ?? "años").toString();
      pet["birthDate"] = AgeHelper.birthFromAge(a, u);
    }

    pet["updatedAt"] =
        DateTime.now();
  
    ProfileStore.save();
  }

  /// Guarda campos sueltos (tamaño, energía, etc.).
  static void setFields(Map<String, dynamic> fields) {
    pet.addAll(fields);
    pet["updatedAt"] = DateTime.now();
    ProfileStore.save();
  }

  /// Recalcula "age" y "ageType" según la fecha de nacimiento y la fecha de hoy.
  static void refreshAge() {
    final b = pet["birthDate"];
    if (b is DateTime) {
      final r = AgeHelper.petAge(b);
      pet["age"] = r.value;
      pet["ageType"] = r.unit;
    } else {
      final a = pet["age"];
      if (a is num && a > 0) {
        pet["birthDate"] = AgeHelper.birthFromAge(
          a.toInt(),
          (pet["ageType"] ?? "años").toString(),
        );
      }
    }
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
      "pedigreeStatus": "none",
      "vaccinated": false,
      "vaccineCard": "",
      "vaccineStatus": "none",
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
      "birthDate": null,
      "size": "",
      "energy": "",
      "neutered": "",
      "goodWith": <String>[],
      "createdAt":
          DateTime.now(),
      "updatedAt":
          DateTime.now(),
    };
  }
}