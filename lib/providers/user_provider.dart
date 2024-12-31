// lib/providers/user_provider.dart
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/firestore_service.dart';

class UserProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  UserModel? _userModel;
  bool _isLoading = false;

  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;

  Future<void> loadUser(String uid) async {
    _isLoading = true;
    notifyListeners();

    _firestoreService.getUserStream(uid).listen(
      (userModel) {
        _userModel = userModel;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> updateHighScore(String uid, int newScore) async {
    await _firestoreService.updateUserScore(uid, newScore);
  }

  Future<void> updateProfile({
    String? avatarUrl,
    String? preferredTheme,
  }) async {
    if (_userModel == null) return;

    try {
      final updatedUser = _userModel!.copyWith(
        avatarUrl: avatarUrl,
        preferredTheme: preferredTheme,
      );

      await _firestoreService.updateUser(updatedUser);
      _userModel = updatedUser; // Update local state
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }
}