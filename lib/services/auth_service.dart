import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      return result;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }

  // Sign up with email and password
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      
      // Create user document in Firestore
      await _firestoreService.createUser(UserModel(
        uid: result.user!.uid,
        email: email,
      ));
      
      return result;
    } catch (e) {
      print('Sign up error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Get current user
  User? get currentUser => _auth.currentUser;
}