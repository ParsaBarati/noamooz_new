// To parse this JSON data, do
//
//     final questionModel = questionModelFromJson(jsonString);

import 'dart:convert';
import 'dart:io';
import 'dart:io';

import 'package:noamooz/Models/general_item_model.dart';
import 'package:noamooz/Plugins/get/get.dart';

QuestionModel questionModelFromJson(String str) => QuestionModel.fromJson(json.decode(str));

String questionModelToJson(QuestionModel data) => json.encode(data.toJson());

class QuestionModel {

  QuestionModel({
    required this.id,
    required this.text,
    required this.image,
    required this.tags,
    required this.answers,
  });

  final int id;
  final String text;
  final FileModel image;
  final List<String> tags;
  final List<Answer> answers;
  final RxInt currentAnswer = 0.obs;

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
    id: int.tryParse(json["id"].toString()) ?? 0,
    text: json["text"],
    image: FileModel.fromMap(json["image"]),
    tags: List<String>.from(json["tags"].map((x) => x)),
    answers: List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "image": image.toMap(),
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
  };
}

class Answer {
  Answer({
    required this.id,
    required this.text,
    required this.questionId,
    required this.image,
  });

  final int id;
  final String text;
  final int questionId;
  final String? image;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
    id: int.tryParse(json["id"].toString()) ?? 0,
    text: json["text"],
    questionId: json["questionId"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "questionId": questionId,
    "image": image,
  };
}

