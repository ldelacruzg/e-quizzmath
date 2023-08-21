import 'package:e_quizzmath/presentation/providers/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizQuestionOption extends StatelessWidget {
  final String text;
  final int index;

  const QuizQuestionOption(
      {super.key, required this.text, required this.index});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final quizProvider = context.watch<QuizProvider>();
    final option = quizProvider.currentQuestion.options[index];

    return GestureDetector(
      onTap: () {
        if (quizProvider.currentQuestion.selectedAnswer != -1) return;
        quizProvider.selectOption(index);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                option.isSelected ? colorScheme.primary : Colors.grey.shade500,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: option.isSelected ? colorScheme.primary : Colors.black,
                ),
              ),
            ),
            Icon(
              option.isSelected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: option.isSelected ? colorScheme.primary : Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
