import 'package:e_quizzmath/domain/topic/entities/question.dart';
import 'package:e_quizzmath/shared/enums/question_difficulty_enum.dart';

class LocalQuestionModel {
  final int id;
  final String question;
  final List<Option> options;
  final int correctAnswer;
  final QuestionDifficulty difficulty;

  LocalQuestionModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
  });

  factory LocalQuestionModel.fromJson(Map<String, dynamic> json) {
    final List<String> listOptionString = json['options'].cast<String>();
    final List<Option> options = listOptionString.asMap().entries.map((e) {
      return Option(text: e.value, index: e.key);
    }).toList();

    return LocalQuestionModel(
      id: json['id'],
      question: json['question'],
      options: options,
      correctAnswer: json['correctAnswer'],
      difficulty: mapStringToDifficulty(json['difficulty']),
    );
  }

  Question toQuestionEntity() => Question(
        id: id,
        question: question,
        options: options,
        correctAnswer: correctAnswer,
        difficulty: difficulty,
      );

  static QuestionDifficulty mapStringToDifficulty(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return QuestionDifficulty.easy;
      case 'medium':
        return QuestionDifficulty.medium;
      case 'hard':
        return QuestionDifficulty.hard;
      default:
        return QuestionDifficulty.easy;
    }
  }
}
