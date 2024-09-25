// To parse this JSON data, do
//
//     final lotteryModel = lotteryModelFromJson(jsonString);

import 'dart:convert';

import 'package:noamooz/Models/Courses/course_model.dart';
import 'package:noamooz/Models/file_model.dart';

ForumModel lotteryModelFromJson(String str) =>
    ForumModel.fromJson(json.decode(str));

String lotteryModelToJson(ForumModel data) => json.encode(data.toJson());

class ForumModel {
  final int id;
  final String name;
  final String description;
  final CourseModel? course;
  final FileModel? file;
  final List<FileModel> files;

  ForumModel({
    required this.id,
    required this.name,
    required this.description,
    required this.course,
    required this.file,
    required this.files,
  });

  factory ForumModel.fromJson(Map<String, dynamic> json) => ForumModel(
        id: int.tryParse(json["id"].toString()) ?? 0,
        name: json["name"],
        description: json["description"],
        files: List.from(json["files"]).map((e) => FileModel.fromJson(e)).toList(),
        course: json["course"] != null
            ? CourseModel.fromJson(json["course"])
            : null,
        file: json["file"] != null ? FileModel.fromJson(json["file"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "course": course?.toJson(),
        "file": file?.toJson(),
      };

  static List<ForumModel> listFromJson(List list) {
    return list.map((e) => ForumModel.fromJson(e)).toList();
  }
}