import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_quizzmath/config/firebase/collections_firebase.dart';
import 'package:e_quizzmath/domain/topic/entities/question.dart';
import 'package:e_quizzmath/domain/topic/entities/quiz_timer.dart';
import 'package:e_quizzmath/infrastructure/models/local_question_model.dart';
import 'package:e_quizzmath/shared/data/local_questions.dart';
import 'package:e_quizzmath/shared/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizProvider with ChangeNotifier {
  bool initialLoading = true;
  int currentQuestionIndex = 0;
  List<Question> questions = [];
  QuizTimer quizTimer = QuizTimer();
  StreamSubscription<int>? _streamSubscription;

  // Firebase properties
  DocumentReference? _currentQuizRef;
  String _quizId = '';
  String _assignedQuestionId = '';

  Question get currentQuestion => questions[currentQuestionIndex];

  String get correctOptionText =>
      currentQuestion.options[currentQuestion.correctAnswer].text;

  String get timer {
    final minutes = quizTimer.time.inMinutes;
    final seconds = quizTimer.time.inSeconds % 60;

    final secondsStr = seconds < 10 ? '0$seconds' : '$seconds';

    return '${minutes}min ${secondsStr}s';
  }

  String get shortTimer {
    final minutes = quizTimer.time.inMinutes;
    final seconds = quizTimer.time.inSeconds % 60;

    final minutesStr = minutes < 10 ? '0$minutes' : '$minutes';
    final secondsStr = seconds < 10 ? '0$seconds' : '$seconds';

    return '$minutesStr:$secondsStr';
  }

  double get accurence {
    final correctAnswers = questions
        .where((question) => question.selectedAnswer == question.correctAnswer)
        .length;

    return (correctAnswers / questions.length) * 100;
  }

  int get totalExp {
    final correctAnswers = questions
        .where((question) => question.selectedAnswer == question.correctAnswer)
        .length;

    return correctAnswers * 2;
  }

  int get _getQuestionScore {
    return currentQuestion.selectedAnswer == currentQuestion.correctAnswer
        ? 2
        : 0;
  }

  void reset() {
    initialLoading = true;
    currentQuestionIndex = 0;
    quizTimer = QuizTimer();
    _streamSubscription?.cancel();
    loadQuestions();
    notifyListeners();
  }

  void endQuiz() {
    // pausar timer
    quizTimer.isRunning = false;
    _streamSubscription?.pause();
    notifyListeners();
  }

  void startTimer() {
    _streamSubscription?.cancel();
    _streamSubscription = Stream<int>.periodic(
      const Duration(seconds: 1),
      (seconds) => seconds + 1,
    ).listen(
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

  void updateSelectedAnswer() {
    final seletedOption =
        currentQuestion.options.firstWhere((option) => option.isSelected).index;
    currentQuestion.selectedAnswer = seletedOption;
    notifyListeners();
  }

  void loadQuestions() async {
    //await Future.delayed(const Duration(seconds: 2));
    this.questions.clear();
    final questionIndexes = Funtions.getRandomItems(5, localQuestions.length);
    final questions = questionIndexes
        .map((index) => LocalQuestionModel.fromJson(localQuestions[index])
            .toQuestionEntity())
        .toList();

    this.questions.addAll(questions);
    initialLoading = false;
    notifyListeners();
  }

  /// ************************** FIREBASE *****************************
  void createQuiz() async {
    // TODO: load all questions

    // Crea el quiz
    final prefs = await SharedPreferences.getInstance();
    final userReference =
        collections[Collections.users]!.doc(prefs.getString('login_id'));

    final request = await collections[Collections.quizzes]!.add({
      'userId': userReference,
      'startDate': DateTime.now(),
    });

    _quizId = request.id;
    _currentQuizRef = collections[Collections.quizzes]!.doc(request.id);
  }

  void createAndAssignAQuestion() async {
    // Se crea la pregunta
    final unitReference =
        collections[Collections.units]!.doc('NdMEdHaayFAvhCr4v5YV');

    final question = await collections[Collections.questions]!.add({
      ...currentQuestion.toJson(),
      'unitId': unitReference,
    });

    // Asigna la pregunta al quiz
    final questionRef = collections[Collections.questions]!.doc(question.id);
    final assignedQuestion =
        await collections[Collections.assignedQuestions]!.add({
      'quizId': _currentQuizRef,
      'questionId': questionRef,
      'date': DateTime.now(),
    });

    _assignedQuestionId = assignedQuestion.id;
  }

  void updateAnswerAssignedQuestion() async {
    final assignedQuestionRef =
        collections[Collections.assignedQuestions]!.doc(_assignedQuestionId);
    Map<String, dynamic> docAssignedQuestion = {
      'answer': currentQuestion.selectedAnswer,
      'points': _getQuestionScore,
    };

    await assignedQuestionRef.update(docAssignedQuestion);
  }

  void updateQuizFinished() async {
    final quizRef = collections[Collections.quizzes]!.doc(_quizId);
    Map<String, dynamic> docQuiz = {
      'endDate': DateTime.now(),
      'time': timer,
      'points': totalExp,
      'percentage': accurence,
    };

    await quizRef.update(docQuiz);
  }

  void updateScoreFinished(DocumentReference currentUserLeaderboard) async {
    // actualizar el score
    final doc = await currentUserLeaderboard.get();
    final docUserLeaderboard = doc.data() as Map<String, dynamic>;
    final score = docUserLeaderboard['score'] as int;
    docUserLeaderboard['score'] = score + totalExp;
    await currentUserLeaderboard.update(docUserLeaderboard);
  }

  void createNewScore(DocumentReference currentLeaderboard) async {
    final prefs = await SharedPreferences.getInstance();
    final userReference =
        collections[Collections.users]!.doc(prefs.getString('login_id'));

    await collections[Collections.userLeaderboard]!.add({
      'userId': userReference,
      'leaderboardId': currentLeaderboard,
      'score': totalExp,
      'joinedDate': DateTime.now(),
    });
  }
}
