import 'package:e_quizzmath/shared/enums/question_difficulty_enum.dart';

class Question {
  int id;
  String question;
  List<Option> options;
  int correctAnswer;
  QuestionDifficulty difficulty;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
  });
}

class Option {
  final String text;
  final int index;
  bool isSelected = false;

  Option({
    required this.text,
    required this.index,
  });
}
