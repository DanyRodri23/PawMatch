import 'package:flutter/foundation.dart';

/// Preferencias de descubrimiento (las mismas que los filtros de Descubre).
/// Por ahora viven en memoria; se guardarán en Firebase más adelante.
class DiscoverPrefs {
  static String gender = "Todos"; // Todos | Macho | Hembra
  static double ageMin = 0;
  static double ageMax = 15;
  static double km = 100; // 100 = sin límite
  static String order = "Equilibradas"; // Equilibradas | Actividad reciente

  /// Sube cada vez que algo cambia, para que Descubre se actualice.
  static final ValueNotifier<int> version = ValueNotifier<int>(0);

  static void changed() => version.value++;
}
