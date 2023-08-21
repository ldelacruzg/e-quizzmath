import 'package:e_quizzmath/presentation/providers/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizQuestionNumberAndProgress extends StatelessWidget {
  const QuizQuestionNumberAndProgress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();
    final currentQuestionNumber = quizProvider.currentQuestionIndex + 1;
    final totalQuestions = quizProvider.questions.length;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Question Number
            Text(
              '${currentQuestionNumber.toString()}/${totalQuestions.toString()}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),

            // Timer
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.yellow.shade50,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer_rounded,
                    size: 20,
                    color: Colors.yellow.shade800,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    quizProvider.timer,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Progress Bar
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: currentQuestionNumber / totalQuestions,
                  minHeight: 15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
