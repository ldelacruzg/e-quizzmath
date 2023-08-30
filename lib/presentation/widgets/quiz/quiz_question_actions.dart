import 'package:e_quizzmath/presentation/providers/leaderboard_provider.dart';
import 'package:e_quizzmath/presentation/providers/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class QuizQuestionActions extends StatefulWidget {
  const QuizQuestionActions({super.key});

  @override
  State<QuizQuestionActions> createState() => _QuizQuestionActionsState();
}

class _QuizQuestionActionsState extends State<QuizQuestionActions> {
  bool isNextButtonVisible = false;
  late QuizProvider quizProvider;
  late LeaderboardProvider leaderboardProvider;

  void _nextQuestion() {
    quizProvider.nextQuestion();
    quizProvider.createAndAssignAQuestion();
    setState(() {
      isNextButtonVisible = false;
    });
  }

  void _showMessage({
    required String message,
    String description = '',
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    final snackbar = SnackBar(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: const TextStyle(fontSize: 16)),
          Visibility(
            visible: description.isNotEmpty,
            child: Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  void _checkAnswer() {
    if (quizProvider.isCorrectOptionSelected()) {
      _showMessage(
        message: '¡Correcto!',
        backgroundColor: Colors.green,
      );
    } else {
      _showMessage(
        message: '¡Incorrecto!',
        description:
            'La respuesta correcta es: ${quizProvider.correctOptionText}',
        backgroundColor: Colors.red,
      );
    }

    quizProvider.updateSelectedAnswer();
    quizProvider.updateAnswerAssignedQuestion();

    setState(() {
      isNextButtonVisible = true;
    });
  }

  void _finishedQuiz() async {
    quizProvider.endQuiz();
    quizProvider.updateQuizFinished();
    if (!(await leaderboardProvider.isCompeting)) {
      quizProvider
          .createNewScore(await leaderboardProvider.getCurrentLeaderboard());
    } else {
      quizProvider.updateScoreFinished(
          await leaderboardProvider.getCurrentUserLeaderboard());
    }
  }

  @override
  Widget build(BuildContext context) {
    quizProvider = context.watch<QuizProvider>();
    leaderboardProvider = context.watch<LeaderboardProvider>();

    return Row(
      children: [
        Visibility(
          visible: !isNextButtonVisible,
          child: Expanded(
            child: FilledButton(
              onPressed: quizProvider.anyOptionSelected() ? _checkAnswer : null,
              child: const Text('COMPROBAR'),
            ),
          ),
        ),
        Visibility(
          visible: isNextButtonVisible && !quizProvider.isLastQuestion(),
          child: Expanded(
            child: FilledButton(
              onPressed: _nextQuestion,
              child: const Text('SIGUIENTE'),
            ),
          ),
        ),
        Visibility(
          visible: isNextButtonVisible && quizProvider.isLastQuestion(),
          child: Expanded(
            child: FilledButton(
              onPressed: () {
                _finishedQuiz();
                context.push('/quiz/result');
              },
              child: const Text('FINALIZAR'),
            ),
          ),
        )
      ],
    );
  }
}
