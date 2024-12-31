import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/question.dart';
import '../models/user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Users Collection
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<void> updateUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).update(user.toMap());
  }

  Stream<UserModel> getUserStream(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => UserModel.fromFirestore(doc));
  }

  // Questions Collection
  Future<void> addQuestion(Question question) async {
    await _db.collection('questions').add(question.toMap());
  }

  Stream<List<Question>> getQuestions() {
    return _db.collection('questions').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Question.fromFirestore(doc)).toList();
    });
  }

  Future<void> updateQuestion(Question question) async {
    await _db.collection('questions').doc(question.id).update(question.toMap());
  }

  Future<void> deleteQuestion(String questionId) async {
    await _db.collection('questions').doc(questionId).delete();
  }

  // User Scores
  Future<void> updateUserScore(String uid, int newScore) async {
    DocumentReference userRef = _db.collection('users').doc(uid);
    
    await _db.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userRef);
      if (snapshot.exists) {
        int currentHighScore = (snapshot.data() as Map<String, dynamic>)['highScore'] ?? 0;
        if (newScore > currentHighScore) {
          transaction.update(userRef, {'highScore': newScore});
        }
      }
    });
  }
}