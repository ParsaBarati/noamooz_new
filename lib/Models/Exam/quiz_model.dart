import 'package:noamooz/Models/Courses/course_model.dart';
import 'package:noamooz/Models/general_item_model.dart';
import 'package:noamooz/Plugins/get/get.dart';

class QuizModel {
  QuizModel({
    required this.id,
    required this.title,
    required this.score,
    required this.details,
    required this.questions,
    required this.category,
    required this.course,
    required this.isSpecialized,
  });

  final int id;
  final String title;
  final int score;
  final int questions;
  final String details;
  final bool isSpecialized;
  final GeneralInformationModel category;
  final CourseModel course;
  final RxBool isSelected = false.obs;

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
        id: int.tryParse(json["id"].toString()) ?? 0,
        title: json["title"],
        score: json["score"],
        questions: json["questions"],
        details: json["details"],
        isSpecialized: json["isSpecialized"] == true,
        course: CourseModel.fromJson(json['course']),
        category: GeneralInformationModel.fromJson(
          json["category"],
        ),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "score": score,
        "details": details,
        "category": category.toJson(),
      };

  static List<QuizModel> listFromJson(List data) {
    return List.from(data).map((e) => QuizModel.fromJson(e)).toList();
  }
}
