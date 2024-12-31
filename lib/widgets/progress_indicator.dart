// lib/widgets/progress_indicator.dart
import 'package:flutter/material.dart';

class QuizProgressIndicator extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;

  const QuizProgressIndicator({
    Key? key,
    required this.currentQuestion,
    required this.totalQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: currentQuestion / totalQuestions,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(const Color.fromARGB(255, 2, 10, 58)),
          minHeight: 10,
        ),
        SizedBox(height: 8),
        Text(
          'Question ${currentQuestion + 1} of $totalQuestions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}