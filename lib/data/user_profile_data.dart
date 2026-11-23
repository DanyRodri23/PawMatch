import '../helpers/age_helper.dart';
import 'user_data.dart';
import '../services/profile_store.dart';

class UserProfileData {
  /// DATOS GLOBALES DEL USUARIO
  static Map<String, dynamic> user = {
    "id": "user_001",

    /// BÁSICOS
    "name": "Daniel",
    "age": 21,
    "gender": "Masculino",
    "showGender": true,

    /// PERFIL
    "bio":
        "Amante de los animales y listo para encontrar la mejor conexión para mi mascota.",
    "instagram": "@daniel",
    "verified": false,
    // Verificación de identidad: "none" | "pending" | "approved"
    "verifyStatus": "none",
    "selfieUrl": "",
    "idUrl": "",
    "joinedDate": "2026",

    /// UBICACIÓN
    "country": "Costa Rica",
    "province": "Heredia",
    "city": "San Isidro",

    /// FOTOS
    "images": <String>[],

    /// CONFIGURACIÓN
    "notifications": true,
    "darkMode": true,
    "showOnline": true,

    /// ESTADÍSTICAS
    "likes": 0,
    "matches": 0,
    "superLikes": 0,

    /// PLAN
    "plan": "Free",
  };

  // ==================================================
  // UPDATE GENERAL (COMPATIBLE CON TODOS TUS ARCHIVOS)
  // ==================================================
  static void updateUser({
    String? name,
    int? age,
    String? gender,
    String? location,
    String? bio,
    String? instagram,
    bool? verified,
    bool? showGender,
    List<String>? images,
    DateTime? birthDate,
  }) {
    if (birthDate != null) {
      user["birthDate"] = birthDate;
      user["age"] = AgeHelper.yearsBetween(birthDate, DateTime.now());
    }
    if (name != null) user["name"] = name;
    if (age != null && birthDate == null) user["age"] = age;
    if (gender != null) user["gender"] = gender;

    if (location != null) {
      user["city"] = location;
    }

    if (bio != null) user["bio"] = bio;
    if (instagram != null) user["instagram"] = instagram;
    if (verified != null) user["verified"] = verified;
    if (showGender != null) user["showGender"] = showGender;
    if (images != null) user["images"] = images;
  
    ProfileStore.save();
  }

  // ==================================================
  // PERFIL
  // ==================================================
  static void updateProfile({
    String? name,
    String? bio,
    String? instagram,
    bool? verified,
    bool? showGender,
  }) {
    if (name != null) user["name"] = name;
    if (bio != null) user["bio"] = bio;
    if (instagram != null) user["instagram"] = instagram;
    if (verified != null) user["verified"] = verified;
    if (showGender != null) user["showGender"] = showGender;
  
    ProfileStore.save();
  }

  /// Recalcula la edad del dueño según su fecha de nacimiento.
  static void refreshAge() {
    final b = user["birthDate"] is DateTime
        ? user["birthDate"]
        : UserData.profile["birthDate"];
    if (b is DateTime) {
      final a = AgeHelper.yearsBetween(b, DateTime.now());
      user["birthDate"] = b;
      user["age"] = a;
      UserData.profile["age"] = a;
    }
  }

  // ==================================================
  // VERIFICACIÓN DE IDENTIDAD
  // ==================================================
  static void updateVerification({
    String? status,
    String? selfieUrl,
    String? idUrl,
  }) {
    if (selfieUrl != null) user["selfieUrl"] = selfieUrl;
    if (idUrl != null) user["idUrl"] = idUrl;
    if (status != null) {
      user["verifyStatus"] = status;
      // Solo una revisión aprobada marca el perfil como verificado.
      user["verified"] = status == "approved";
    }

    ProfileStore.save();
  }

  // ==================================================
  // PERSONALES
  // ==================================================
  static void updatePersonal({
    int? age,
    String? gender,
  }) {
    if (age != null) user["age"] = age;
    if (gender != null) user["gender"] = gender;
  
    ProfileStore.save();
  }

  // ==================================================
  // UBICACIÓN
  // ==================================================
  static void updateLocation({
    String? country,
    String? province,
    String? city,
  }) {
    if (country != null) user["country"] = country;
    if (province != null) user["province"] = province;
    if (city != null) user["city"] = city;
  
    ProfileStore.save();
  }

  // ==================================================
  // FOTOS
  // ==================================================
  static void updateImages(
    List<String> images,
  ) {
    user["images"] = images;
  
    ProfileStore.save();
  }

  static void addImage(
    String path,
  ) {
    final List<String> images =
        List<String>.from(
      user["images"],
    );

    images.add(path);

    user["images"] = images;
  
    ProfileStore.save();
  }

  static void removeImage(
    int index,
  ) {
    final List<String> images =
        List<String>.from(
      user["images"],
    );

    if (index >= 0 &&
        index < images.length) {
      images.removeAt(index);
    }

    user["images"] = images;
  
    ProfileStore.save();
  }

  static void setMainImage(
    int index,
  ) {
    final List<String> images =
        List<String>.from(
      user["images"],
    );

    if (index >= 0 &&
        index < images.length) {
      final selected =
          images[index];

      images.removeAt(index);
      images.insert(0, selected);
    }

    user["images"] = images;
  
    ProfileStore.save();
  }

  // ==================================================
  // PREMIUM
  // ==================================================
  static void changePlan(
    String plan,
  ) {
    user["plan"] = plan;
  
    ProfileStore.save();
  }

  // ==================================================
  // RESET PERFIL
  // ==================================================
  static void clearProfile() {
    user = {
      "id": "user_001",
      "name": "",
      "age": 18,
      "gender": "",
      "showGender": true,
      "bio": "",
      "instagram": "",
      "verified": false,
      "joinedDate": "2026",
      "country": "",
      "province": "",
      "city": "",
      "images": <String>[],
      "notifications": true,
      "darkMode": true,
      "showOnline": true,
      "likes": 0,
      "matches": 0,
      "superLikes": 0,
      "plan": "Free",
    };
  }
}