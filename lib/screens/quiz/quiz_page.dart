import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quiz_app_firebase/services/auth_service.dart';
import '../../providers/auth_provider.dart';
import '../../providers/quiz_provider.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Initialize quiz data
    Future.microtask(() => 
      context.read<QuizProvider>().initialize()
    );
  }

  Future<void> _checkAnswer(bool userAnswer) async {
    QuizProvider quizProvider = context.read<QuizProvider>();
    
    if (quizProvider.selectedAnswer != null) return;

    quizProvider.checkAnswer(userAnswer);
    
    // Play sound effect
    await _audioPlayer.play(AssetSource(
      userAnswer == quizProvider.currentQuestion.isCorrect 
        ? 'sounds/correct.mp3' 
        : 'sounds/wrong.mp3'
    ));

    // Wait before moving to next question
    await Future.delayed(Duration(seconds: 1));
    _nextQuestion();
  }

  void _nextQuestion() {
    QuizProvider quizProvider = context.read<QuizProvider>();
    if (quizProvider.currentIndex < quizProvider.questions.length - 1) {
      quizProvider.nextQuestion();
    } else {
      _showResults();
    }
  }

  void _showResults() {
    QuizProvider quizProvider = context.read<QuizProvider>();
    final percentage = (quizProvider.score / quizProvider.questions.length * 100)
        .toStringAsFixed(1);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quiz Terminé!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Score: ${quizProvider.score}/${quizProvider.questions.length}'),
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
                quizProvider.resetQuiz();
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
        title: Text(widget.title, style: TextStyle(color: Colors.lightBlue[50])),
        backgroundColor: Colors.indigo[800],
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) => UserAvatar(
              avatarUrl: _authService.currentUser?.photoURL,
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.lightBlue[50]),
            onPressed: () => Navigator.pushNamed(context, '/add_question'),
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.lightBlue[50]),
            onPressed: () async {
              await context.read<AuthProvider>().signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (quizProvider.errorMessage != null) {
            return Center(child: Text(quizProvider.errorMessage!));
          }

          if (quizProvider.questions.isEmpty) {
            return Center(child: Text('No questions available'));
          }

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScoreDisplay(
                  currentScore: quizProvider.score,
                  totalQuestions: quizProvider.questions.length,
                ),
                SizedBox(height: 20),
                QuestionCard(question: quizProvider.currentQuestion),
                SizedBox(height: 20),
                AnswerButtons(
                  onAnswerSelected: _checkAnswer,
                  selectedAnswer: quizProvider.selectedAnswer,
                  isCorrect: quizProvider.selectedAnswer != null 
                      ? quizProvider.currentQuestion.isCorrect 
                      : null,
                ),
                SizedBox(height: 20),
                QuizProgressIndicator(
                  currentQuestion: quizProvider.currentIndex,
                  totalQuestions: quizProvider.questions.length,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}