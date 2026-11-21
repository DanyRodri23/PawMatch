import '../data/pet_profile_data.dart';

class PetFlowHelper {
  static bool get isBreed => PetProfileData.pet["isPureBreed"] == true;

  static bool get vaccinated => PetProfileData.pet["vaccinated"] == true;

  /// La barra siempre se mide sobre la ruta más larga (11 pasos).
  static const int totalSteps = 11;

  /// Posición de cada pantalla en la ruta completa.
  /// Los pasos que no aplican (raza, pedigrí, carnet) simplemente se saltan.
  static int getStep(String screen) {
    switch (screen) {
      case "name":
        return 1;
      case "age":
        return 2;
      case "gender":
        return 3;
      case "breedType":
        return 4;
      case "breed":
        return 5;
      case "pedigree":
        return 6;
      case "vaccines":
        return 7;
      case "vaccineCard":
        return 8;
      case "photos":
        return 9;
      case "personality":
        return 10;
      case "goal":
        return 11;
    }

    return 1;
  }
}
