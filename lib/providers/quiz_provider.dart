// lib/providers/quiz_provider.dart
import 'package:flutter/foundation.dart';
import '../models/question.dart';
import '../services/firestore_service.dart';

class QuizProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool? _selectedAnswer;
  bool _isLoading = true;
  String? _errorMessage;

  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  bool? get selectedAnswer => _selectedAnswer;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Question get currentQuestion => _questions[_currentIndex];

  void initialize() {
    _firestoreService.getQuestions().listen(
      (questions) {
        _questions = questions;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = 'Error loading questions: $error';
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void checkAnswer(bool userAnswer) {
    if (_selectedAnswer != null) return;

    _selectedAnswer = userAnswer;
    if (userAnswer == _questions[_currentIndex].isCorrect) {
      _score++;
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedAnswer = null;
      notifyListeners();
    }
  }

  void resetQuiz() {
    _currentIndex = 0;
    _score = 0;
    _selectedAnswer = null;
    notifyListeners();
  }

  double getProgress() {
    return _currentIndex / _questions.length;
  }
}