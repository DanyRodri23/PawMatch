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
    String? messageId,
  }) async {
    final ref = _db.collection('chats').doc(chatId);

    // El id del chat es "uidA_uidB" (ordenados): de ahí salen los participantes.
    // Primero se crea/actualiza el chat (las reglas lo necesitan para
    // permitir los mensajes) y luego se agrega el mensaje.
    final participants =
        chatId.contains('_') ? chatId.split('_') : <String>[senderId];

    final others = participants.where((p) => p != senderId).toList();

    await ref.set({
      "participants": participants,
      "lastMessage": text,
      "lastSender": senderId,
      "updatedAt": FieldValue.serverTimestamp(),
      if (others.isNotEmpty)
        "unread": {others.first: FieldValue.increment(1)},
    }, SetOptions(merge: true));

    final msgRef = messageId != null
        ? ref.collection('messages').doc(messageId)
        : ref.collection('messages').doc();

    await msgRef.set({
      "senderId": senderId,
      "text": text,
      "type": type,
      if (url != null) "url": url,
      if (duration != null) "duration": duration,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  /// Id nuevo para un mensaje (se crea antes de enviarlo para no duplicarlo).
  static String newMessageId(String chatId) =>
      _db.collection('chats').doc(chatId).collection('messages').doc().id;

  /// Avisa si estoy escribiendo (se ve como "escribiendo…" en el otro teléfono).
  static Future<void> setTyping({
    required String chatId,
    required String uid,
    required bool typing,
  }) async {
    final participants =
        chatId.contains('_') ? chatId.split('_') : <String>[uid];
    await _db.collection('chats').doc(chatId).set({
      "participants": participants,
      "typing": {uid: typing},
    }, SetOptions(merge: true));
  }

  /// Editar un mensaje mío: se ve editado en los dos teléfonos.
  static Future<void> editMessage({
    required String chatId,
    required String messageId,
    required String text,
    bool isLast = false,
  }) async {
    await _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({"text": text, "edited": true});
    if (isLast) {
      await _db
          .collection('chats')
          .doc(chatId)
          .set({"lastMessage": text}, SetOptions(merge: true));
    }
  }

  /// Eliminar para todos: el mensaje queda como "eliminado" en los dos teléfonos.
  static Future<void> deleteForAll({
    required String chatId,
    required String messageId,
    bool isLast = false,
  }) async {
    await _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      "deleted": true,
      "text": "",
      "type": "text",
      "url": FieldValue.delete(),
      "duration": FieldValue.delete(),
    });
    if (isLast) {
      await _db.collection('chats').doc(chatId).set(
          {"lastMessage": "Se eliminó este mensaje"},
          SetOptions(merge: true));
    }
  }

  /// Eliminar para mí: solo se oculta en mi teléfono (y sigue oculto al reabrir).
  static Future<void> hideForMe({
    required String chatId,
    required String messageId,
    required String uid,
  }) async {
    await _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      "hiddenFor": FieldValue.arrayUnion([uid]),
    });
  }

  /// Pone en 0 mis mensajes sin leer de este chat.
  static Future<void> clearUnread(String chatId, String uid) async {
    await _db.collection('chats').doc(chatId).set({
      "unread": {uid: 0},
    }, SetOptions(merge: true));
  }

  /// Escuchar el chat completo (para saber si el otro está escribiendo).
  static Stream<DocumentSnapshot<Map<String, dynamic>>> chatDoc(
      String chatId) {
    return _db.collection('chats').doc(chatId).snapshots();
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