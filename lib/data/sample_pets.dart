/// Datos completos de las mascotas de ejemplo (luego vendrán de Firebase),
/// para que su perfil se vea igual de completo que el tuyo.
class SamplePets {
  static const Map<String, Map<String, dynamic>> _byName = {
    "Luna": {
      "gender": "Hembra", "breed": "Golden Retriever", "isPureBreed": true,
      "vaccineStatus": "approved", "pedigreeStatus": "approved",
      "lookingFor": "Reproducción", "size": "Grande", "energy": "Moderado",
      "neutered": "No", "goodWith": ["Perros", "Niños"],
      "traits": ["Cariñosa", "Sociable", "Juguetona"],
      "description": "Dulce y muy sociable. Le encanta nadar y que le tiren la pelota en el parque.",
      "location": "Heredia, Costa Rica",
    },
    "Max": {
      "gender": "Macho", "breed": "Husky", "isPureBreed": true,
      "vaccineStatus": "approved", "pedigreeStatus": "approved",
      "lookingFor": "Amistad", "size": "Grande", "energy": "Muy activo",
      "neutered": "Sí", "goodWith": ["Perros", "Gatos", "Niños"],
      "traits": ["Aventurero", "Activo", "Leal"],
      "description": "Siempre listo para una caminata larga. Busca amigos con energía para correr juntos.",
      "location": "San José, Costa Rica",
    },
    "Rocky": {
      "gender": "Macho", "breed": "Labrador", "isPureBreed": false,
      "vaccineStatus": "none",
      "lookingFor": "Compañero de juego", "size": "Mediano", "energy": "Muy activo",
      "neutered": "No", "goodWith": ["Perros"],
      "traits": ["Juguetón", "Travieso", "Cariñoso"],
      "description": "Un cachorro lleno de energía que ama morder sus juguetes y hacer nuevos amigos.",
      "location": "Alajuela, Costa Rica",
    },
    "Nala": {
      "gender": "Hembra", "breed": "Poodle", "isPureBreed": true,
      "vaccineStatus": "approved", "pedigreeStatus": "approved",
      "lookingFor": "Reproducción", "size": "Pequeño", "energy": "Tranquilo",
      "neutered": "No", "goodWith": ["Perros", "Adultos mayores"],
      "traits": ["Elegante", "Tranquila", "Inteligente"],
      "description": "Tranquila y muy educada. Disfruta los paseos cortos y las caricias.",
      "location": "Cartago, Costa Rica",
    },
  };

  /// Devuelve el perfil con los datos que le falten rellenados.
  static Map<String, dynamic> full(Map<String, dynamic> pet) {
    final extra = _byName[(pet["name"] ?? "").toString()];
    if (extra == null) return pet;
    final out = Map<String, dynamic>.from(pet);
    extra.forEach((k, v) {
      final cur = out[k];
      if (cur == null || (cur is String && cur.isEmpty)) out[k] = v;
    });
    return out;
  }
}
