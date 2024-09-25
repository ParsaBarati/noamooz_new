import 'package:noamooz/Models/Exam/question_model.dart';
import 'package:noamooz/Models/Exam/quiz_model.dart';

class ResultModel {
  final int id;
  final int correct;
  final int wrong;

  ResultModel({
    required this.id,
    required this.correct,
    required this.wrong,
  });


  factory ResultModel.fromJson(Map<String, dynamic> result) {
    return ResultModel(
      id: result['id'] ?? 0,
      correct: result['correctAnswersCount'] ?? 0,
      wrong: result['wrongAnswerCount'] ?? 0,
    );
  }
}

class DailyExamModel {
  final int id;
  final QuizModel? quiz;
  final DateTime date;
  final int status;
  final int step;
  final List<QuestionModel> questions;
  final ResultModel? result;

  DailyExamModel({
    required this.id,
    required this.quiz,
    required this.date,
    required this.status,
    required this.step,
    required this.questions,
    required this.result,
  });

  factory DailyExamModel.fromJson(Map<String, dynamic> res) => DailyExamModel(
        id: res['id'],
        quiz: res['quiz'] != null ? QuizModel.fromJson(res['quiz']) : null,
        result:
            res['result'] != null ? ResultModel.fromJson(res['result']) : null,
        questions: List.from(res["questions"])
            .map((e) => QuestionModel.fromJson(e))
            .toList(),
        date: DateTime.fromMillisecondsSinceEpoch(res['date']),
        status: res['status'],
        step: res['step'],
      );
}
