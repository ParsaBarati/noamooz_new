// To parse this JSON data, do
//
//     final lotteryModel = lotteryModelFromJson(jsonString);

import 'dart:convert';

import 'package:noamooz/Models/Courses/course_model.dart';

LotteryModel lotteryModelFromJson(String str) => LotteryModel.fromJson(json.decode(str));

String lotteryModelToJson(LotteryModel data) => json.encode(data.toJson());

class LotteryModel {
  final int id;
  final String name;
  final CourseModel? course;
  final int from;
  final int to;
  final int maxWinners;
  final int topBuyerCount;
  final int status;
  final List<Prize> prizes;

  LotteryModel({
    required this.id,
    required this.name,
    required this.course,
    required this.from,
    required this.to,
    required this.maxWinners,
    required this.topBuyerCount,
    required this.status,
    required this.prizes,
  });

  factory LotteryModel.fromJson(Map<String, dynamic> json) => LotteryModel(
    id: int.tryParse(json["id"].toString()) ?? 0,
    name: json["name"],
    course: json["course"] != null ? CourseModel.fromJson(json["course"]) : null,
    from: json["from"],
    to: json["to"],
    maxWinners: json["maxWinners"],
    topBuyerCount: json["topBuyerCount"],
    status: json["status"],
    prizes: List<Prize>.from(json["prizes"].map((x) => Prize.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "course": course?.toJson(),
    "from": from,
    "to": to,
    "maxWinners": maxWinners,
    "topBuyerCount": topBuyerCount,
    "status": status,
    "prizes": List<dynamic>.from(prizes.map((x) => x.toJson())),
  };

  static List<LotteryModel> listFromJson(List list) {
    return list.map((e) => LotteryModel.fromJson(e)).toList();
  }
}





class Prize {
  final int id;
  final String name;
  final String image;
  final String details;
  final int count;

  Prize({
    required this.id,
    required this.name,
    required this.image,
    required this.details,
    required this.count,
  });

  factory Prize.fromJson(Map<String, dynamic> json) => Prize(
    id: int.tryParse(json["id"].toString()) ?? 0,
    name: json["name"],
    image: json["image"],
    details: json["details"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "details": details,
    "count": count,
  };
}
