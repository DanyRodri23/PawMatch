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
  }) async {
    final ref =
        _db.collection('chats')
            .doc(chatId);

    await ref
        .collection('messages')
        .add({
      "senderId": senderId,
      "text": text,
      "createdAt":
          FieldValue.serverTimestamp(),
    });

    await ref.update({
      "lastMessage": text,
      "updatedAt":
          FieldValue.serverTimestamp(),
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