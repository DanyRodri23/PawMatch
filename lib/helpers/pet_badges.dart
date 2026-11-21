import '../data/pet_profile_data.dart';

/// Estados de un documento: "none" (sin subir), "pending" (en revisión),
/// "approved" (aprobado por PawMatch → insignia azul).
class PetBadges {
  static String pedigree(Map pet) {
    final s = pet["pedigreeStatus"];
    if (s is String && s.isNotEmpty) return s;

    // Mascotas de ejemplo que solo traen el dato "pedigree: true".
    return pet["pedigree"] == true ? "approved" : "none";
  }

  static String vaccine(Map pet) {
    final s = pet["vaccineStatus"];
    if (s is String && s.isNotEmpty) return s;

    return pet["vaccinated"] == true ? "approved" : "none";
  }

  static bool pedigreeApproved(Map pet) => pedigree(pet) == "approved";

  static bool vaccineApproved(Map pet) => vaccine(pet) == "approved";

  /// Solo los perros de raza pueden tener pedigrí.
  static bool canHavePedigree(Map pet) => pet["isPureBreed"] == true;

  // ---- Documentos de la mascota propia ----

  static void setPedigreeDoc(String url) {
    final pet = PetProfileData.pet;
    final previous = (pet["pedigreeCertificate"] ?? "").toString();

    if (url.isEmpty) {
      PetProfileData.updatePet(
        pedigreeCertificate: "",
        pedigreeStatus: "none",
        pedigree: false,
      );
    } else if (url != previous) {
      // Documento nuevo: queda en revisión hasta que PawMatch lo apruebe.
      PetProfileData.updatePet(
        pedigreeCertificate: url,
        pedigreeStatus: "pending",
        pedigree: false,
      );
    }
  }

  static void setVaccineDoc(String url) {
    final pet = PetProfileData.pet;
    final previous = (pet["vaccineCard"] ?? "").toString();

    if (url.isEmpty) {
      PetProfileData.updatePet(
        vaccineCard: "",
        vaccineStatus: "none",
      );
    } else if (url != previous) {
      PetProfileData.updatePet(
        vaccineCard: url,
        vaccineStatus: "pending",
        vaccinated: true,
      );
    }
  }

  /// SOLO PARA PRUEBAS: simula la aprobación de PawMatch.
  static void approvePedigreeForTesting() {
    PetProfileData.updatePet(pedigreeStatus: "approved", pedigree: true);
  }

  static void approveVaccineForTesting() {
    PetProfileData.updatePet(vaccineStatus: "approved");
  }
}
