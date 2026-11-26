import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../data/chats_data.dart';
import '../data/likes_data.dart';
import '../data/matches_data.dart';
import '../data/pet_profile_data.dart';
import '../data/user_profile_data.dart';

/// Mascotas reales en Firebase.
///
/// - `pets/{uid}`      → perfil PÚBLICO de la mascota (+ datos públicos del dueño).
///                       Nunca lleva la cédula ni el selfie del dueño.
/// - `swipes/{de}_{a}` → un "me gusta" (liked: true) o "no" (liked: false).
/// - `matches/{a}_{b}` → match cuando los dos se gustaron (ids ordenados).
class DiscoverService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static String? get myUid => FirebaseAuth.instance.currentUser?.uid;

  // ---------------------------------------------------------------
  // PUBLICAR MI MASCOTA
  // ---------------------------------------------------------------

  /// Campos de la mascota que otros usuarios pueden ver.
  static const List<String> _publicPetFields = [
    "name", "age", "ageType", "birthDate", "gender", "isPureBreed", "breed",
    "pedigree", "pedigreeStatus", "pedigreeCertificate",
    "vaccinated", "vaccineStatus", "vaccineCard",
    "size", "energy", "neutered", "goodWith",
    "hideAge", "hideDistance", "smartPhotos",
    "location", "images", "videos", "traits", "description", "lookingFor",
  ];

  static Future<void> publish() async {
    final uid = myUid;
    if (uid == null) return;
    final pet = PetProfileData.pet;
    if (pet["profileCompleted"] != true) return;

    try {
      final user = UserProfileData.user;
      final data = <String, dynamic>{};
      for (final k in _publicPetFields) {
        if (pet.containsKey(k) && pet[k] != null) data[k] = pet[k];
      }

      // "approved" solo lo pone PawMatch (consola/administrador), nunca la app.
      // Si ya está aprobado en el servidor, al omitirlo se conserva.
      if (data["pedigreeStatus"] == "approved") data.remove("pedigreeStatus");
      if (data["vaccineStatus"] == "approved") data.remove("vaccineStatus");

      data["uid"] = uid;
      data["active"] = true;
      data["owner"] = {
        "name": user["name"] ?? "",
        "images": user["images"] is List ? user["images"] : <String>[],
        if (user["verifyStatus"] != "approved")
          "verifyStatus": user["verifyStatus"] ?? "none",
        "province": user["province"] ?? "",
        "city": user["city"] ?? "",
        "bio": user["bio"] ?? "",
        "instagram": user["instagram"] ?? "",
        "age": user["age"],
        "gender": user["gender"],
        "showGender": user["showGender"] != false,
      };
      data["updatedAt"] = FieldValue.serverTimestamp();

      await _db.collection("pets").doc(uid).set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint("No se pudo publicar la mascota: $e");
    }
  }

  // ---------------------------------------------------------------
  // LEER MASCOTAS
  // ---------------------------------------------------------------

  static dynamic _fromFirestore(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is Map) {
      return v.map((k, x) => MapEntry(k.toString(), _fromFirestore(x)));
    }
    if (v is List) return v.map(_fromFirestore).toList();
    return v;
  }

  /// Convierte un documento de `pets` al formato que usa la app.
  static Map<String, dynamic> _toPet(String uid, Map<String, dynamic> raw) {
    final m = Map<String, dynamic>.from(_fromFirestore(raw) as Map);
    m["id"] = uid;
    m["uid"] = uid;
    m["images"] = (m["images"] is List)
        ? (m["images"] as List).map((e) => e.toString()).toList()
        : <String>[];
    m["traits"] = (m["traits"] is List)
        ? (m["traits"] as List).map((e) => e.toString()).toList()
        : <String>[];
    final loc = (m["location"] ?? "").toString();
    m["distance"] = loc.isEmpty ? "Cerca de ti" : loc;
    m["pedigree"] = m["pedigreeStatus"] == "approved";
    m["vaccinated"] = m["vaccineStatus"] == "approved";
    final owner = m["owner"];
    m["verified"] = owner is Map && owner["verifyStatus"] == "approved";
    return m;
  }

  /// Ids a los que ya les di me gusta o no.
  static Future<Set<String>> _mySwiped() async {
    final uid = myUid;
    if (uid == null) return {};
    final q = await _db.collection("swipes").where("from", isEqualTo: uid).get();
    return q.docs.map((d) => (d.data()["to"] ?? "").toString()).toSet();
  }

  /// Mascotas que todavía no he visto (sin la mía).
  static Future<List<Map<String, dynamic>>> loadDeck() async {
    final uid = myUid;
    if (uid == null) return [];
    try {
      final swiped = await _mySwiped();
      final q = await _db
          .collection("pets")
          .where("active", isEqualTo: true)
          .limit(100)
          .get();

      final out = <Map<String, dynamic>>[];
      for (final d in q.docs) {
        if (d.id == uid || swiped.contains(d.id)) continue;
        out.add(_toPet(d.id, d.data()));
      }
      return out;
    } catch (e) {
      debugPrint("No se pudieron cargar las mascotas: $e");
      return [];
    }
  }

  // ---------------------------------------------------------------
  // ME GUSTA / NO / MATCH
  // ---------------------------------------------------------------

  static String matchId(String a, String b) {
    final l = [a, b]..sort();
    return "${l[0]}_${l[1]}";
  }

  /// Guarda mi decisión. Devuelve true si es un MATCH (los dos se gustaron).
  static Future<bool> swipe(String otherUid, {required bool liked}) async {
    final uid = myUid;
    if (uid == null) return false;

    try {
      await _db.collection("swipes").doc("${uid}_$otherUid").set({
        "from": uid,
        "to": otherUid,
        "liked": liked,
        "createdAt": FieldValue.serverTimestamp(),
      });
      if (!liked) return false;

      final back = await _db.collection("swipes").doc("${otherUid}_$uid").get();
      final theyLiked = back.exists && back.data()?["liked"] == true;
      if (!theyLiked) return false;

      await _db.collection("matches").doc(matchId(uid, otherUid)).set({
        "participants": [uid, otherUid],
        "createdAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint("No se pudo guardar el me gusta: $e");
      return false;
    }
  }

  /// ¿Esta mascota ya me dio like? (para marcar "te dio like" en la tarjeta)
  static Future<bool> likedMe(String otherUid) async {
    final uid = myUid;
    if (uid == null) return false;
    try {
      final d = await _db.collection("swipes").doc("${otherUid}_$uid").get();
      return d.exists && d.data()?["liked"] == true;
    } catch (_) {
      return false;
    }
  }

  // ---------------------------------------------------------------
  // CARGAR MIS LIKES RECIBIDOS Y MIS MATCHES
  // ---------------------------------------------------------------

  static Future<Map<String, dynamic>?> _petById(String uid) async {
    final d = await _db.collection("pets").doc(uid).get();
    final data = d.data();
    if (data == null) return null;
    return _toPet(d.id, data);
  }

  static StreamSubscription? _inboxSub;

  /// Escucha todos mis chats: cuando llega un mensaje, la lista y el aviso se actualizan solos.
  static void startInbox() {
    final uid = myUid;
    _inboxSub?.cancel();
    if (uid == null) return;

    _inboxSub = _db
        .collection("chats")
        .where("participants", arrayContains: uid)
        .snapshots()
        .listen((snap) async {
      var changed = false;
      for (final d in snap.docs) {
        final data = d.data();
        final last = (data["lastMessage"] ?? "").toString();
        if (last.isEmpty) continue;

        final parts = List<String>.from(data["participants"] ?? []);
        final other = parts.firstWhere((p) => p != uid, orElse: () => "");
        if (other.isEmpty) continue;

        var chat = ChatsData.getChatById(other);
        if (chat == null) {
          final pet = await _petById(other);
          if (pet == null) continue;
          ChatsData.createChat(pet);
          chat = ChatsData.getChatById(other);
          if (chat == null) continue;
          final idx = MatchesData.matches.indexWhere((m) => m["id"] == other);
          if (idx >= 0) {
            chat["matchDate"] = MatchesData.matches[idx]["matchDate"];
            MatchesData.matches.removeAt(idx);
          }
        } else {
          MatchesData.matches.removeWhere((m) => m["id"] == other);
        }

        final unreadMap = data["unread"];
        final unread =
            (unreadMap is Map && unreadMap[uid] is num) ? (unreadMap[uid] as num).toInt() : 0;
        final at = data["updatedAt"];
        final when = at is Timestamp ? at.toDate() : DateTime.now();

        final typingMap = data["typing"];
        chat["typing"] = typingMap is Map && typingMap[other] == true;
        chat["lastMessage"] = last;
        chat["unread"] = unread;
        chat["updatedAt"] = when;
        chat["time"] =
            "${when.hour}:${when.minute.toString().padLeft(2, '0')}";
        changed = true;
      }
      if (changed) ChatsData.changes.value++;
    }, onError: (e) => debugPrint("Error escuchando chats: $e"));
  }

  static Future<void> loadLikesAndMatches() async {
    final uid = myUid;
    if (uid == null) return;

    LikesData.receivedLikes.clear();
    LikesData.sentLikes.clear();
    MatchesData.matches.clear();
    ChatsData.chats.clear();

    try {
      // Matches
      final ms = await _db
          .collection("matches")
          .where("participants", arrayContains: uid)
          .get();
      final matchedIds = <String>{};
      for (final m in ms.docs) {
        final parts = List<String>.from(m.data()["participants"] ?? []);
        final other = parts.firstWhere((p) => p != uid, orElse: () => "");
        if (other.isEmpty) continue;
        matchedIds.add(other);
        final pet = await _petById(other);
        if (pet == null) continue;
        final at = m.data()["createdAt"];
        final matchDate = at is Timestamp ? at.toDate() : DateTime.now();

        // ¿Ya hay conversación con mensajes? Entonces va a "Mensajes", no a "Nuevos matches".
        final msgs = await _db
            .collection("chats")
            .doc(m.id)
            .collection("messages")
            .orderBy("createdAt", descending: true)
            .limit(50)
            .get();

        if (msgs.docs.isNotEmpty) {
          final last = msgs.docs.first.data();
          final unread = msgs.docs
              .where((d) =>
                  d.data()["senderId"] != uid && d.data()["seen"] != true)
              .length;
          ChatsData.createChat(pet);
          final chat = ChatsData.getChatById(pet["id"]);
          if (chat != null) {
            chat["lastMessage"] = (last["text"] ?? "").toString();
            chat["unread"] = unread;
            chat["matchDate"] = matchDate;
            chat["time"] = "";
          }
        } else {
          MatchesData.matches.add({...pet, "matchDate": matchDate});
        }
      }

      // Likes que recibí y aún no respondí
      final swiped = await _mySwiped();
      final recv = await _db
          .collection("swipes")
          .where("to", isEqualTo: uid)
          .where("liked", isEqualTo: true)
          .get();
      for (final d in recv.docs) {
        final from = (d.data()["from"] ?? "").toString();
        if (from.isEmpty || swiped.contains(from) || matchedIds.contains(from)) {
          continue;
        }
        final pet = await _petById(from);
        if (pet != null) LikesData.receivedLikes.add(pet);
      }
    } catch (e) {
      debugPrint("No se pudieron cargar likes y matches: $e");
    }
  }
}
