import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Parques y hoteles favoritos (se guardan en el celular).
/// kind: "park" | "hotel".
class FavoritesData {
  static final ValueNotifier<int> version = ValueNotifier<int>(0);

  static final List<Map<String, dynamic>> _items = [];
  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString("favorites_v1");
      if (raw != null) {
        final list = jsonDecode(raw) as List;
        _items
          ..clear()
          ..addAll(list.map((e) => Map<String, dynamic>.from(e as Map)));
      }
    } catch (_) {}
    _loaded = true;
    version.value++;
  }

  static Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("favorites_v1", jsonEncode(_items));
    } catch (_) {}
  }

  static List<Map<String, dynamic>> byKind(String kind) =>
      _items.where((e) => e["kind"] == kind).toList();

  static int get count => _items.length;

  static bool isFavorite(String kind, Map item) => _items.any(
      (e) => e["kind"] == kind && e["data"]?["name"] == item["name"]);

  static void toggle(String kind, Map item) {
    final i = _items.indexWhere(
        (e) => e["kind"] == kind && e["data"]?["name"] == item["name"]);
    if (i >= 0) {
      _items.removeAt(i);
    } else {
      _items.add({"kind": kind, "data": Map<String, dynamic>.from(item)});
    }
    version.value++;
    _save();
  }
}
