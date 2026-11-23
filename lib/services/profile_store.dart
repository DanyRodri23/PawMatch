import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../data/pet_profile_data.dart';
import '../data/user_data.dart';
import '../data/user_profile_data.dart';
import 'discover_service.dart';

/// Guarda y carga el perfil del dueño y de su mascota en Firebase
/// (colección "users", documento = uid del usuario).
class ProfileStore {
  static DocumentReference<Map<String, dynamic>>? _doc() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    return FirebaseFirestore.instance.collection('users').doc(user.uid);
  }

  /// Firestore devuelve Timestamp; la app usa DateTime.
  static dynamic _fromFirestore(dynamic value) {
    if (value is Timestamp) return value.toDate();

    if (value is Map) {
      return value.map(
        (k, v) => MapEntry(k.toString(), _fromFirestore(v)),
      );
    }

    if (value is List) return value.map(_fromFirestore).toList();

    return value;
  }

  static List<String> _strings(dynamic value) {
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return <String>[];
  }

  /// Carga el perfil del usuario que inició sesión.
  /// Si es un usuario nuevo, empieza con un perfil vacío.
  static Future<void> load() async {
    final authUser = FirebaseAuth.instance.currentUser;
    if (authUser == null) return;

    // Siempre se parte de cero, así no se mezclan datos entre cuentas.
    PetProfileData.resetPet();
    UserProfileData.clearProfile();

    UserData.resetFor(uid: authUser.uid, phone: authUser.phoneNumber);

    UserProfileData.user["id"] = authUser.uid;
    UserProfileData.user["name"] = authUser.displayName ?? "";

    try {
      // Si Firebase tarda demasiado, la app sigue con el perfil vacío
      // en vez de quedarse cargando para siempre.
      final snap = await _doc()!.get().timeout(const Duration(seconds: 8));
      final data = snap.data();

      if (data == null) return;

      // Nombre guardado al crear la cuenta.
      final nombre = data["nombre"];
      if (nombre is String && nombre.isNotEmpty) {
        UserProfileData.user["name"] = nombre;
      }

      final owner = data["ownerProfile"];
      if (owner is Map) {
        UserProfileData.user.addAll(
          Map<String, dynamic>.from(_fromFirestore(owner) as Map),
        );
        UserProfileData.user["images"] =
            _strings(UserProfileData.user["images"]);
      }

      final pet = data["petProfile"];
      if (pet is Map) {
        PetProfileData.pet.addAll(
          Map<String, dynamic>.from(_fromFirestore(pet) as Map),
        );
        PetProfileData.pet["images"] = _strings(PetProfileData.pet["images"]);
        PetProfileData.pet["videos"] = _strings(PetProfileData.pet["videos"]);
        PetProfileData.pet["traits"] = _strings(PetProfileData.pet["traits"]);
      }
    } catch (e) {
      debugPrint("No se pudo cargar el perfil: $e");
    } finally {
      // Las edades se calculan con la fecha de hoy.
      PetProfileData.refreshAge();
      UserProfileData.refreshAge();
    }
  }

  /// Guarda el perfil actual (dueño + mascota). Nunca lanza errores.
  static Future<void> save() async {
    final doc = _doc();
    if (doc == null) return;

    try {
      await doc.set({
        "ownerProfile": UserProfileData.user,
        "petProfile": PetProfileData.pet,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Perfil público de la mascota (lo ven los demás en Descubre).
      await DiscoverService.publish();
    } catch (e) {
      debugPrint("No se pudo guardar el perfil: $e");
    }
  }

  /// SOLO PARA PRUEBAS: borra el perfil guardado de este usuario
  /// (dueño + mascota) para poder repetir el registro.
  static Future<void> resetForTesting() async {
    final doc = _doc();

    try {
      if (doc != null) {
        await doc.update({
          "ownerProfile": FieldValue.delete(),
          "petProfile": FieldValue.delete(),
        });
      }
    } catch (e) {
      debugPrint("No se pudo reiniciar el perfil: $e");
    }

    PetProfileData.resetPet();
    UserProfileData.clearProfile();
  }
}
