import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveChatHistory(String question, String answer) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users')
          .doc(user.uid)
          .collection('chatHistory')
          .add({
        'question': question,
        'answer': answer,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<List<Map<String, dynamic>>> getChatHistory() {
    User? user = _auth.currentUser;
    if (user != null) {
      return _firestore.collection('users')
          .doc(user.uid)
          .collection('chatHistory')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => doc.data())
              .toList());
    }
    return const Stream.empty();
  }

  Future<void> clearChatHistory() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final chatCollection = _firestore.collection('users')
          .doc(user.uid)
          .collection('chatHistory');

      final snapshot = await chatCollection.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }
  }
}
