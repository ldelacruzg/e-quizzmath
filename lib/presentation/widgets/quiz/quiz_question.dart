import 'package:e_quizzmath/presentation/providers/quiz_provider.dart';
import 'package:e_quizzmath/presentation/widgets/quiz/quiz_question_option.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizQuestion extends StatelessWidget {
  const QuizQuestion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final question = quizProvider.currentQuestion;

    return Column(
      children: [
        // Question
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            question.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Options
        Column(
          children: [
            ...question.options.map((option) {
              return Column(
                children: [
                  QuizQuestionOption(text: option.text, index: option.index),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }
}
