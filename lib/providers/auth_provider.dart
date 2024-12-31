import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      var result = await _authService.signIn(email, password);
      _user = result?.user;
      return result;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      var result = await _authService.signUp(email, password);
      _user = result?.user;
      return result;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}