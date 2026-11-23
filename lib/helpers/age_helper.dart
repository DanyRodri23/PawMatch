/// Calcula edades a partir de la fecha de nacimiento, para que se actualicen solas.
class AgeHelper {
  /// Meses completos entre [birth] y [now].
  static int monthsBetween(DateTime birth, DateTime now) {
    int m = (now.year - birth.year) * 12 + (now.month - birth.month);
    if (now.day < birth.day) m--;
    return m < 0 ? 0 : m;
  }

  /// Años completos (cumpleaños) entre [birth] y [now].
  static int yearsBetween(DateTime birth, DateTime now) {
    int y = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      y--;
    }
    return y < 0 ? 0 : y;
  }

  /// Fecha de nacimiento aproximada a partir de "4 meses" / "2 años".
  static DateTime birthFromAge(int age, String unit, [DateTime? now]) {
    final n = now ?? DateTime.now();
    final months = unit == "meses" ? age : age * 12;
    int y = n.year;
    int m = n.month - months;
    while (m <= 0) {
      m += 12;
      y--;
    }
    final lastDay = DateTime(y, m + 1, 0).day;
    return DateTime(y, m, n.day > lastDay ? lastDay : n.day);
  }

  /// Edad de una mascota: menos de 12 meses se muestra en meses; luego en años.
  static ({int value, String unit}) petAge(DateTime birth, [DateTime? now]) {
    final n = now ?? DateTime.now();
    final months = monthsBetween(birth, n);
    if (months < 12) return (value: months, unit: "meses");
    return (value: yearsBetween(birth, n), unit: "años");
  }

  /// "4 meses", "1 año", "3 años".
  static String petAgeText(int value, String unit) {
    if (unit == "meses") return value == 1 ? "1 mes" : "$value meses";
    return value == 1 ? "1 año" : "$value años";
  }
}
