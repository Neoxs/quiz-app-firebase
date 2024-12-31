import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? avatarUrl;
  final int highScore;
  final String preferredTheme;

  UserModel({
    required this.uid,
    required this.email,
    this.avatarUrl,
    this.highScore = 0,
    this.preferredTheme = 'general',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'avatarUrl': avatarUrl,
      'highScore': highScore,
      'preferredTheme': preferredTheme,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'],
      highScore: map['highScore'] ?? 0,
      preferredTheme: map['preferredTheme'] ?? 'general',
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? avatarUrl,
    int? highScore,
    String? preferredTheme,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      highScore: highScore ?? this.highScore,
      preferredTheme: preferredTheme ?? this.preferredTheme,
    );
  }
}