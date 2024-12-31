// lib/widgets/answer_buttons.dart
import 'package:flutter/material.dart';

class AnswerButtons extends StatelessWidget {
  final Function(bool) onAnswerSelected;
  final bool? selectedAnswer;
  final bool? isCorrect;

  const AnswerButtons({
    Key? key,
    required this.onAnswerSelected,
    this.selectedAnswer,
    this.isCorrect,
  }) : super(key: key);

  Color _getButtonColor(bool isTrue) {
    return selectedAnswer == isTrue
            ? (isCorrect == isTrue ? Colors.teal : Colors.deepOrange)
            : Colors.blueGrey;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildAnswerButton(true),
        _buildAnswerButton(false),
      ],
    );
  }

  Widget _buildAnswerButton(bool isTrue) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: _getButtonColor(isTrue),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent, // Use transparent to allow AnimatedContainer's color
          shadowColor: Colors.transparent, // Remove shadow to avoid overriding
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        ),
        onPressed: selectedAnswer == null
            ? () => onAnswerSelected(isTrue)
            : null,
        child: Text(
          isTrue ? 'VRAI' : 'FAUX',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
