import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  final String questionText;
  final bool isCorrect;
  final String imageUrl;
  final String theme;
  final DateTime createdAt;
  final String createdBy;

  Question({
    this.id = '',
    required this.questionText,
    required this.isCorrect,
    required this.imageUrl,
    this.theme = 'general',
    DateTime? createdAt,
    this.createdBy = '',
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'isCorrect': isCorrect,
      'imageUrl': imageUrl,
      'theme': theme,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }

  factory Question.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Question(
      id: doc.id,
      questionText: data['questionText'] ?? '',
      isCorrect: data['isCorrect'] ?? false,
      imageUrl: data['imageUrl'] ?? '',
      theme: data['theme'] ?? 'general',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: data['createdBy'] ?? '',
    );
  }

  Question copyWith({
    String? id,
    String? questionText,
    bool? isCorrect,
    String? imageUrl,
    String? theme,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return Question(
      id: id ?? this.id,
      questionText: questionText ?? this.questionText,
      isCorrect: isCorrect ?? this.isCorrect,
      imageUrl: imageUrl ?? this.imageUrl,
      theme: theme ?? this.theme,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}