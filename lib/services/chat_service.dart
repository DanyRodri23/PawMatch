import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  static final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  /// Crear chat entre 2 usuarios
  static Future<void> createChat({
    required String chatId,
    required List<String> participants,
  }) async {
    final doc =
        _db.collection('chats').doc(chatId);

    final exists =
        await doc.get();

    if (!exists.exists) {
      await doc.set({
        "participants": participants,
        "lastMessage": "",
        "updatedAt":
            FieldValue.serverTimestamp(),
      });
    }
  }

  /// Enviar mensaje
  static Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    String type = "text",
    String? url,
    int? duration,
  }) async {
    final ref = _db.collection('chats').doc(chatId);

    // El id del chat es "uidA_uidB" (ordenados): de ahí salen los participantes.
    // Primero se crea/actualiza el chat (las reglas lo necesitan para
    // permitir los mensajes) y luego se agrega el mensaje.
    final participants =
        chatId.contains('_') ? chatId.split('_') : <String>[senderId];

    await ref.set({
      "participants": participants,
      "lastMessage": text,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await ref.collection('messages').add({
      "senderId": senderId,
      "text": text,
      "type": type,
      if (url != null) "url": url,
      if (duration != null) "duration": duration,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// Escuchar mensajes realtime
  static Stream<QuerySnapshot>
      getMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy(
          "createdAt",
          descending: false,
        )
        .snapshots();
  }

  /// Escuchar chats realtime
  static Stream<QuerySnapshot>
      getChats() {
    return _db
        .collection('chats')
        .orderBy(
          "updatedAt",
          descending: true,
        )
        .snapshots();
  }
}