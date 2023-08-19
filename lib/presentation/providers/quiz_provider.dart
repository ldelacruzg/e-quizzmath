import 'package:e_quizzmath/domain/topic/entities/question.dart';
<<<<<<< HEAD
import 'package:e_quizzmath/domain/topic/entities/quiz_timer.dart';
=======
>>>>>>> 18c4ff6 (feat: add the operation of the questionnaire)
import 'package:e_quizzmath/infrastructure/models/local_question_model.dart';
import 'package:e_quizzmath/shared/data/local_questions.dart';
import 'package:flutter/material.dart';

class QuizProvider with ChangeNotifier {
  bool initialLoading = true;
  int currentQuestionIndex = 0;
  List<Question> questions = [];
<<<<<<< HEAD
  QuizTimer quizTimer = QuizTimer();
=======
>>>>>>> 18c4ff6 (feat: add the operation of the questionnaire)

  Question get currentQuestion => questions[currentQuestionIndex];

  String get correctOptionText =>
      currentQuestion.options[currentQuestion.correctAnswer].text;

<<<<<<< HEAD
  String get timer {
    final minutes = quizTimer.time.inMinutes;
    final seconds = quizTimer.time.inSeconds % 60;

    final secondsStr = seconds < 10 ? '0$seconds' : '$seconds';

    return '${minutes}min ${secondsStr}s';
  }

  void startTimer() {
    Stream<int>.periodic(const Duration(seconds: 1), (seconds) => seconds + 1)
        .listen(
      (time) {
        quizTimer.time = Duration(seconds: time);
        notifyListeners();
      },
    );
  }

  void switchTimer() {
    quizTimer.isRunning = !quizTimer.isRunning;
    notifyListeners();
  }

=======
>>>>>>> 18c4ff6 (feat: add the operation of the questionnaire)
  bool isLastQuestion() {
    return currentQuestionIndex == questions.length - 1;
  }

  bool anyOptionSelected() {
    return currentQuestion.options.any((option) => option.isSelected);
  }

  void selectOption(int index) {
    final options = currentQuestion.options;
    for (int i = 0; i < options.length; i++) {
      final option = options[i];
      if (i == index) {
        option.isSelected = true;
      } else {
        option.isSelected = false;
      }
    }
    notifyListeners();
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      currentQuestionIndex++;
      notifyListeners();
    }
  }

  bool isCorrectOptionSelected() {
    final seletedOption =
        currentQuestion.options.firstWhere((option) => option.isSelected).index;
    final correctOption = currentQuestion.correctAnswer;

    return seletedOption == correctOption;
  }

  void loadQuestions() async {
    //await Future.delayed(const Duration(seconds: 2));
    final List<Question> questions = localQuestions
        .map((e) => LocalQuestionModel.fromJson(e).toQuestionEntity())
        .toList();

    this.questions.addAll(questions);
    initialLoading = false;
    notifyListeners();
  }
}
