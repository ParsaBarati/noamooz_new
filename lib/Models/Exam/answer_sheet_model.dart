import 'package:noamooz/Models/Exam/question_model.dart';

class AnswerSheetModel {
  final int id;
  final String question;
  final Answer answer;
  final Answer correctAnswer;

  AnswerSheetModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.correctAnswer,
  });

  factory AnswerSheetModel.fromJson(Map<String, dynamic> map) =>
      AnswerSheetModel(
        id: map['id'],
        question: map['question'],
        answer: Answer.fromJson(map['answer']),
        correctAnswer: Answer.fromJson(map['correctAnswer']),
      );
}
