import 'package:noamooz/DataBase/Entity.dart';

import '../file_model.dart';

class MyCourseModel {
  final int id;

  final int price;
  final CourseModel course;
  final bool hasInstallments;
  final DateTime createdAt;

  MyCourseModel({
    required this.id,
    required this.price,
    required this.course,
    required this.hasInstallments,
    required this.createdAt,
  });

  factory MyCourseModel.fromJson(Map<String, dynamic> json) => MyCourseModel(
        id: int.tryParse(json["id"].toString()) ?? 0,
        course: CourseModel.fromJson(json['course']),
        price: int.tryParse(json["price"].toString()) ?? 0,
        hasInstallments: json["hasInstallments"] == true,
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "price": price,
        "course": course.toJson(),
        'createdAt': createdAt.millisecondsSinceEpoch,
        "hasInstallments": hasInstallments,
      };

  static List<MyCourseModel> listFromJson(List data) {
    return data.map((e) => MyCourseModel.fromJson(e)).toList();
  }
}

class CourseModel extends BaseEntity {
  final int id;
  final String name;
  final String size;
  final String duration;
  final String details;
  final String cover;
  final String icon;
  final String courseName;
  final int price;
  final int discountPrice;
  final bool hasInstallments;
  final bool hasBought;
  final int prePayment;
  final int maxInstallmentMonths;
  List<FileModel> files = [];
  List<String> get courses {
    return files.map((e) => e.courseName).toSet().toList();
  }
  final List<Comment> comments;
  final bool boughtInstallment;

  CourseModel({
    required this.id,
    required this.name,
    required this.details,
    required this.size,
    required this.duration,
    required this.cover,
    required this.icon,
    required this.courseName,
    required this.price,
    required this.discountPrice,
    required this.hasInstallments,
    required this.hasBought,
    required this.prePayment,
    required this.maxInstallmentMonths,
    required this.files,
    required this.comments,
    required this.boughtInstallment,
  });

  static CourseModel fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: int.tryParse(json["id"].toString()) ?? 0,
      name: json["name"],
      courseName: json["courseName"] ?? "",
      size: json["size"].toString(),
      duration: json["duration"].toString(),
      details: json["details"],
      cover: json["cover"],
      icon: json["icon"],
      price: int.tryParse(json["price"].toString()) ?? 0,
      discountPrice: int.tryParse(json["discountPrice"].toString()) ?? 0,
      hasInstallments: json["hasInstallments"] == true,
      boughtInstallment: json["boughtInstallment"] == true,
      hasBought: json["hasBought"] == true,
      prePayment: int.tryParse(json["prePayment"].toString()) ?? 0,
      maxInstallmentMonths: int.tryParse(json["maxInstallmentMonths"].toString()) ?? 0,
      files:
          List.from(json["files"]).map((e) => FileModel.fromJson(e)).toList(),
      comments:
      (json["comments"] is Iterable ? List<Comment>.from(json["comments"]?.map((x) => Comment.fromMap(x))) ?? [] : []),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "courseName": courseName,
        "size": size,
        "duration": duration,
        "details": details,
        "cover": cover,
        "icon": icon,
        "hasBought": hasBought,
        "price": price,
        "files": files
            .map(
              (e) => e.toJson(),
            )
            .toList(),
        "hasInstallments": hasInstallments,
        "prePayment": prePayment,
        "maxInstallmentMonths": maxInstallmentMonths,
      };

  static List<CourseModel> listFromJson(List data) {
    return data.map((e) => CourseModel.fromJson(e)).toList();
  }
}

class Comment {
  Comment({
    required this.id,
    required this.user,
    required this.date,
    required this.text,
    required this.replies,
    this.voice = '',
    this.file = '',
  });

  int id;
  final User? user;
  final int date;
  final String text;
  String file = '';
  String voice = '';
  final List<Comment> replies;

  factory Comment.fromMap(Map<String, dynamic> json) => Comment(
        id: int.tryParse(json["id"].toString()) ?? 0,
        user: (json["user"] != null ? User.fromMap(json["user"]) : null),
        date: int.tryParse(json["date"].toString()) ?? 0,
        text: json["text"],
        voice: json["voice"] ?? "",
        file: json["file"] ?? "",
        replies:
            List.from(json["replies"]).map((e) => Comment.fromMap(e)).toList(),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "user": user?.toMap(),
        "date": date,
        "text": text,
        "voice": voice,
        "file": file,
        "replies": replies,
      };
}

class User {
  User({
    required this.id,
    required this.image,
    required this.name,
  });

  final int id;
  final String image;
  final String name;

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: int.tryParse(json["id"].toString()) ?? 0,
        image: json["image"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "image": image,
        "name": name,
      };
}
