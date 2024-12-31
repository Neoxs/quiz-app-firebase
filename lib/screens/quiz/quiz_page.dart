import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../services/analytics_service.dart';
import '../../models/question.dart';
import '../../widgets/question_card.dart';
import '../../widgets/answer_buttons.dart';
import '../../widgets/score_display.dart';
import '../../widgets/progress_indicator.dart';
import '../../widgets/user_avatar.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  final AnalyticsService _analyticsService = AnalyticsService();
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  int _currentIndex = 0;
  int _score = 0;
  List<Question> _questions = [];
  bool? _selectedAnswer;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      setState(() => _isLoading = true);
      _firestoreService.getQuestions().listen(
        (questions) {
          setState(() {
            _questions = questions;
            _isLoading = false;
          });
        },
        onError: (error) {
          setState(() {
            _errorMessage = 'Error loading questions: $error';
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _checkAnswer(bool userAnswer) async {
    if (_selectedAnswer != null) return;

    setState(() => _selectedAnswer = userAnswer);
    bool isCorrect = userAnswer == _questions[_currentIndex].isCorrect;

    // Play sound effect
    await _audioPlayer.play(AssetSource(
      isCorrect ? 'sounds/correct.mp3' : 'sounds/wrong.mp3'
    ));

    if (isCorrect) {
      setState(() => _score++);
    }

    // // Log analytics
    // await _analyticsService.logQuestionAnswered(
    //   _questions[_currentIndex].id,
    //   isCorrect
    // );

    // Wait before moving to next question
    await Future.delayed(Duration(seconds: 1));
    _nextQuestion();
  }

  void _nextQuestion() {
    setState(() {
      if (_currentIndex < _questions.length - 1) {
        _currentIndex++;
        _selectedAnswer = null;
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    final percentage = (_score / _questions.length * 100).toStringAsFixed(1);
    
    // // Log final score
    // _analyticsService.logQuizScore(
    //   _authService.currentUser?.uid ?? 'anonymous',
    //   _score,
    //   'general'
    // );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Terminé!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Score: $_score/${_questions.length}'),
              Text('Pourcentage: $percentage%'),
              SizedBox(height: 20),
              Text(
                percentage.contains('100')
                    ? 'Perfect! 🎉'
                    : double.parse(percentage) >= 70
                        ? 'Great job! 👏'
                        : 'Keep practicing! 💪',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                  _score = 0;
                  _selectedAnswer = null;
                });
                Navigator.of(context).pop();
              },
              child: Text('Recommencer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.lightBlue[50]),),
        backgroundColor: Colors.indigo[800],
        actions: [
          UserAvatar(
            avatarUrl: _authService.currentUser?.photoURL,
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.lightBlue[50]),
            onPressed: () => Navigator.pushNamed(context, '/add_question'),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.lightBlue[50]),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (_questions.isEmpty) {
      return Center(child: Text('No questions available'));
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScoreDisplay(
            currentScore: _score,
            totalQuestions: _questions.length,
          ),
          SizedBox(height: 20),
          QuestionCard(question: _questions[_currentIndex]),
          SizedBox(height: 20),
          AnswerButtons(
            onAnswerSelected: _checkAnswer,
            selectedAnswer: _selectedAnswer,
            isCorrect: _selectedAnswer != null 
                ? _questions[_currentIndex].isCorrect 
                : null,
          ),
          SizedBox(height: 20),
          QuizProgressIndicator(
            currentQuestion: _currentIndex,
            totalQuestions: _questions.length,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}