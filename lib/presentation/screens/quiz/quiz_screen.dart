import 'package:e_quizzmath/presentation/providers/quiz_provider.dart';
import 'package:e_quizzmath/presentation/widgets/quiz/quiz_question_actions.dart';
import 'package:e_quizzmath/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: QuizProvider()..loadQuestions(),
      child: const QuizView(),
    );
  }
}

class QuizView extends StatefulWidget {
  const QuizView({super.key});

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView> {
  late final QuizProvider quizProvider;

  @override
  void initState() {
    super.initState();
    quizProvider = context.read<QuizProvider>();
    quizProvider.startTimer();
  }

  GestureTapCallback _onTapOption() {
    return () => showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('¿Estás seguro de salir del cuestionario?'),
            content: const Text(
                'Si sales del cuestionario, perderás todo tu progreso.'),
            actions: [
              TextButton(
                onPressed: () => context.pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => context.pop(true),
                child: const Text('Si'),
              ),
            ],
          ),
        ).then(
          (value) => {if (value == true) context.pop()},
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vectores'),
        leading: GestureDetector(
          onTap: _onTapOption(),
          child: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            // Question Number and Timer
            QuizQuestionNumberAndProgress(),
            SizedBox(height: 20),

            // Question
            Expanded(child: QuizQuestion()),

            // Actions
            QuizQuestionActions(),
          ],
        ),
      ),
      floatingActionButton: const _CustomFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _CustomFloatingActionButton extends StatelessWidget {
  const _CustomFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    final quizProvider = context.watch<QuizProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: false,
          child: Row(
            children: [
              FloatingActionButton(
                heroTag: 1,
                onPressed: () {
                  // quizProvider.nextQuestion();
                  // show snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: (quizProvider.isCorrectOptionSelected())
                          ? Row(
                              children: [
                                Image.asset('assets/gifs/quiz/approved.gif',
                                    width: 30, height: 30),
                                const SizedBox(width: 10),
                                const Text('Correcto'),
                              ],
                            )
                          : const Text('Incorrecto'),
                    ),
                  );
                },
                child: const Icon(Icons.navigate_next_rounded),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }
}
