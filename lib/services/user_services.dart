import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final FirebaseFirestore _db =
      FirebaseFirestore.instance;

  static final FirebaseAuth _auth =
      FirebaseAuth.instance;

  static Future<void> saveUserProfile({
    required Map<String, dynamic> data,
  }) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _db
        .collection("users")
        .doc(user.uid)
        .set({
      ...data,
      "uid": user.uid,
      "email": user.email,
      "updatedAt":
          FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}