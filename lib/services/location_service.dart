import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../data/user_data.dart';
import '../data/user_profile_data.dart';

enum LocationStatus {
  ok,
  denied,
  deniedForever,
  serviceOff,
  outsideCountry,
  failed,
}

class LocationResult {
  final LocationStatus status;
  final String? province;

  const LocationResult(this.status, [this.province]);
}

class _Ref {
  final String province;
  final double lat;
  final double lon;

  const _Ref(this.province, this.lat, this.lon);
}

/// Detecta en qué provincia de Costa Rica está la persona.
/// Solo se guarda la provincia, nunca la ubicación exacta.
class LocationService {
  static const String country = "Costa Rica";

  /// Cabeceras de cantón: se usa el punto más cercano para saber la provincia
  /// (más preciso que usar solo las capitales de provincia).
  static const List<_Ref> _refs = [
    // SAN JOSÉ
    _Ref("San José", 9.9328, -84.0795),
    _Ref("San José", 9.9189, -84.1397),
    _Ref("San José", 9.8966, -84.0684),
    _Ref("San José", 9.8467, -84.3092),
    _Ref("San José", 9.6600, -84.0300),
    _Ref("San José", 9.8586, -84.0970),
    _Ref("San José", 9.9138, -84.2538),
    _Ref("San José", 9.9560, -84.0560),
    _Ref("San José", 9.9322, -84.1814),
    _Ref("San José", 9.9022, -84.1022),
    _Ref("San José", 10.0233, -84.0083),
    _Ref("San José", 9.7500, -84.1900),
    _Ref("San José", 9.9570, -84.0820),
    _Ref("San José", 9.9640, -84.0480),
    _Ref("San José", 9.9340, -84.0500),
    _Ref("San José", 9.7600, -84.4800),
    _Ref("San José", 9.6667, -83.9667),
    _Ref("San José", 9.9170, -84.0330),
    _Ref("San José", 9.3730, -83.7040),
    // ALAJUELA
    _Ref("Alajuela", 10.0163, -84.2116),
    _Ref("Alajuela", 10.0870, -84.4690),
    _Ref("Alajuela", 10.0720, -84.3120),
    _Ref("Alajuela", 9.9400, -84.5300),
    _Ref("Alajuela", 9.9780, -84.3770),
    _Ref("Alajuela", 10.0990, -84.3830),
    _Ref("Alajuela", 10.0570, -84.4330),
    _Ref("Alajuela", 10.0840, -84.2330),
    _Ref("Alajuela", 9.9120, -84.5240),
    _Ref("Alajuela", 10.3240, -84.4270),
    _Ref("Alajuela", 10.1860, -84.4000),
    _Ref("Alajuela", 10.0900, -84.3500),
    _Ref("Alajuela", 10.8990, -85.0170),
    _Ref("Alajuela", 11.0340, -84.7110),
    _Ref("Alajuela", 10.6680, -84.8270),
    _Ref("Alajuela", 10.4670, -84.6430),
    // CARTAGO
    _Ref("Cartago", 9.8644, -83.9194),
    _Ref("Cartago", 9.8380, -83.8650),
    _Ref("Cartago", 9.9000, -83.9900),
    _Ref("Cartago", 9.9000, -83.7300),
    _Ref("Cartago", 9.9040, -83.6830),
    _Ref("Cartago", 9.9500, -83.8100),
    _Ref("Cartago", 9.9100, -83.8900),
    _Ref("Cartago", 9.8400, -83.9400),
    // HEREDIA
    _Ref("Heredia", 9.9984, -84.1165),
    _Ref("Heredia", 10.0200, -84.1230),
    _Ref("Heredia", 9.9780, -84.0980),
    _Ref("Heredia", 10.0370, -84.1500),
    _Ref("Heredia", 10.0000, -84.1000),
    _Ref("Heredia", 10.0350, -84.0980),
    _Ref("Heredia", 9.9760, -84.1840),
    _Ref("Heredia", 9.9980, -84.1550),
    _Ref("Heredia", 9.9920, -84.0970),
    _Ref("Heredia", 10.4560, -83.9990),
    // GUANACASTE
    _Ref("Guanacaste", 10.6346, -85.4407),
    _Ref("Guanacaste", 10.1480, -85.4520),
    _Ref("Guanacaste", 10.2600, -85.5830),
    _Ref("Guanacaste", 10.5260, -85.2530),
    _Ref("Guanacaste", 10.4400, -85.6100),
    _Ref("Guanacaste", 10.4260, -85.0930),
    _Ref("Guanacaste", 10.2900, -84.9990),
    _Ref("Guanacaste", 10.4670, -84.9690),
    _Ref("Guanacaste", 9.9720, -85.2400),
    _Ref("Guanacaste", 11.0700, -85.6300),
    _Ref("Guanacaste", 10.0700, -85.4090),
    // PUNTARENAS
    _Ref("Puntarenas", 9.9763, -84.8384),
    _Ref("Puntarenas", 9.9890, -84.6640),
    _Ref("Puntarenas", 9.1700, -83.3330),
    _Ref("Puntarenas", 10.0900, -84.7300),
    _Ref("Puntarenas", 8.9800, -83.5300),
    _Ref("Puntarenas", 9.4310, -84.1620),
    _Ref("Puntarenas", 8.6390, -83.1640),
    _Ref("Puntarenas", 8.8230, -82.9590),
    _Ref("Puntarenas", 9.5240, -84.3220),
    _Ref("Puntarenas", 8.6580, -82.9400),
    _Ref("Puntarenas", 9.6150, -84.6310),
    _Ref("Puntarenas", 10.3000, -84.8200),
    _Ref("Puntarenas", 9.8200, -84.9300),
    // LIMÓN
    _Ref("Limón", 9.9907, -83.0360),
    _Ref("Limón", 10.2160, -83.7870),
    _Ref("Limón", 10.1000, -83.5090),
    _Ref("Limón", 9.6160, -82.8300),
    _Ref("Limón", 10.0770, -83.2930),
    _Ref("Limón", 10.2130, -83.6880),
  ];

  static const List<String> provinces = [
    "San José",
    "Alajuela",
    "Cartago",
    "Heredia",
    "Guanacaste",
    "Puntarenas",
    "Limón",
  ];

  /// Provincia del punto más cercano, o null si no está en Costa Rica.
  static String? provinceFor(double lat, double lon) {
    String? best;
    double bestKm = double.infinity;

    for (final r in _refs) {
      final km = Geolocator.distanceBetween(lat, lon, r.lat, r.lon) / 1000;
      if (km < bestKm) {
        bestKm = km;
        best = r.province;
      }
    }

    return bestKm <= 120 ? best : null;
  }

  /// Pide permiso (si hace falta) y detecta la provincia.
  static Future<LocationResult> detect({bool askPermission = true}) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return const LocationResult(LocationStatus.serviceOff);
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied && askPermission) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        return const LocationResult(LocationStatus.deniedForever);
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.unableToDetermine) {
        return const LocationResult(LocationStatus.denied);
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      ).timeout(const Duration(seconds: 15));

      final province = provinceFor(position.latitude, position.longitude);

      if (province == null) {
        return const LocationResult(LocationStatus.outsideCountry);
      }

      return LocationResult(LocationStatus.ok, province);
    } catch (e) {
      debugPrint("No se pudo obtener la ubicación: $e");
      return const LocationResult(LocationStatus.failed);
    }
  }

  /// Guarda la provincia en el perfil (no la ubicación exacta).
  static void saveProvince(String province) {
    UserData.updateProfile(location: "$province, $country");

    UserProfileData.updateLocation(
      country: country,
      province: province,
      city: province,
    );
  }

  static DateTime? _lastRefresh;

  /// Si la persona se movió de provincia, se actualiza sola.
  /// No pide permisos ni interrumpe: si no hay permiso, no hace nada.
  static Future<void> refreshIfNeeded({bool force = false}) async {
    final last = _lastRefresh;

    if (!force &&
        last != null &&
        DateTime.now().difference(last) < const Duration(minutes: 20)) {
      return;
    }

    _lastRefresh = DateTime.now();

    final result = await detect(askPermission: false);

    if (result.status != LocationStatus.ok || result.province == null) return;

    if (UserProfileData.user["province"] != result.province) {
      saveProvince(result.province!);
    }
  }
}
