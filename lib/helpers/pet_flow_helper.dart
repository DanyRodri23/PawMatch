import '../data/pet_profile_data.dart';

class PetFlowHelper {
  static bool get isBreed =>
      PetProfileData.pet["isPureBreed"] == true;

  static bool get vaccinated =>
      PetProfileData.pet["vaccinated"] == true;

  /// TOTAL SEGÚN RUTA
  static int get totalSteps {
    if (isBreed && vaccinated) return 11;
    if (isBreed && !vaccinated) return 10;
    if (!isBreed && vaccinated) return 9;
    return 8;
  }

  /// PASO ACTUAL
  static int getStep(String screen) {
    /// PERRO DE RAZA
    if (isBreed) {
      switch (screen) {
        case "breed":
          return 5;

        case "pedigree":
          return 6;

        case "vaccines":
          return 7;

        case "vaccineCard":
          return 8;

        case "photos":
          return vaccinated ? 9 : 8;

        case "personality":
          return vaccinated ? 10 : 9;

        case "goal":
          return vaccinated ? 11 : 10;
      }
    }

    /// MESTIZO
    else {
      switch (screen) {
        case "vaccines":
          return 5;

        case "vaccineCard":
          return 6;

        case "photos":
          return vaccinated ? 7 : 6;

        case "personality":
          return vaccinated ? 8 : 7;

        case "goal":
          return vaccinated ? 9 : 8;
      }
    }

    return 1;
  }
}