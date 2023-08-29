import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_quizzmath/domain/topic/entities/question.dart';
import 'package:e_quizzmath/domain/topic/entities/quiz_timer.dart';
import 'package:e_quizzmath/infrastructure/models/local_question_model.dart';
import 'package:e_quizzmath/shared/data/local_questions.dart';
import 'package:flutter/material.dart';

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
  final _quizCollection = FirebaseFirestore.instance.collection('quizzes');
  final _questionsCollection =
      FirebaseFirestore.instance.collection('questions');
  final _usersCollection = FirebaseFirestore.instance.collection('Users');
  final _assignedQuestionsCollection =
      FirebaseFirestore.instance.collection('assigned_questions');
  final _unitsCollection = FirebaseFirestore.instance.collection('units');

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
    final List<Question> questions = localQuestions
        .map((e) => LocalQuestionModel.fromJson(e).toQuestionEntity())
        .toList();

    this.questions.addAll(questions);
    initialLoading = false;
    notifyListeners();
  }

  /// ************************** FIREBASE *****************************
  void createQuiz() async {
    // TODO: load all questions

    // Crea el quiz
    final userReference = _usersCollection.doc('EFkiNDtnHDfqOMuoy7dp');

    final request = await _quizCollection.add({
      'userId': userReference,
      'startDate': DateTime.now(),
    });

    _quizId = request.id;
    _currentQuizRef = _quizCollection.doc(request.id);
  }

  void createAndAssignAQuestion() async {
    // Se crea la pregunta
    final unitReference = _unitsCollection.doc('NdMEdHaayFAvhCr4v5YV');
    final question = await _questionsCollection.add({
      ...currentQuestion.toJson(),
      'unitId': unitReference,
    });

    // Asigna la pregunta al quiz
    final questionRef = _questionsCollection.doc(question.id);
    final assignedQuestion = await _assignedQuestionsCollection.add({
      'quizId': _currentQuizRef,
      'questionId': questionRef,
      'date': DateTime.now(),
    });

    _assignedQuestionId = assignedQuestion.id;
  }

  void updateAnswerAssignedQuestion() async {
    final assignedQuestionRef =
        _assignedQuestionsCollection.doc(_assignedQuestionId);
    Map<String, dynamic> docAssignedQuestion = {
      'answer': currentQuestion.selectedAnswer,
      'points': _getQuestionScore,
    };

    await assignedQuestionRef.update(docAssignedQuestion);
  }

  void updateQuizFinished() async {
    final quizRef = _quizCollection.doc(_quizId);
    Map<String, dynamic> docQuiz = {
      'endDate': DateTime.now(),
      'time': timer,
      'points': totalExp,
      'percentage': accurence,
    };

    await quizRef.update(docQuiz);
  }
}
