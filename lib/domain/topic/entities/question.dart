import 'package:e_quizzmath/shared/enums/question_difficulty_enum.dart';

class Question {
  final int id;
  final String question;
  final List<Option> options;
  final int correctAnswer;
  final QuestionDifficulty difficulty;
  int selectedAnswer = -1;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'options': options.map((option) => option.text).toList(),
      'correctAnswer': correctAnswer,
      'difficulty': difficulty.name,
    };
  }
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
