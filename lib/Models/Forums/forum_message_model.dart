import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:noamooz/Models/Courses/course_model.dart';
import 'package:noamooz/Models/user_model.dart';

class ForumMessage {

  final GlobalKey globalKey = GlobalKey();

  ForumMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.isMe,
    required this.date,
    required this.user,
    this.reply = 0,
  });

  int id;
  final int reply;
  Map<String, dynamic> content;
  final String type;
  final bool isMe;
  final User user;
  final int date;

  factory ForumMessage.fromJson(Map<String, dynamic> json) {
    return ForumMessage(
      id: int.parse(json["id"].toString()),
      reply: int.tryParse(json['reply'].toString() ?? '0') ?? 0,
      content: json["content"] is String
          ? (jsonDecode(json["content"]) is Map
          ? jsonDecode(json["content"])
          : {})
          : json["content"],
      type: json["type"],
      user: User.fromMap(json['user']),
      isMe:
      json["isMe"] is bool ? json["isMe"] == true : json["isMe"] == "true",
      date: int.tryParse(json["date"].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "content": content,
    "type": type,
    "isMe": isMe,
    "date": date,
  };

  String previewText() {
    switch (type) {
      case 'image':
        return "تصویر";
      case 'audio':
        return "رسانه صوتی";
      case 'file':
        return "رسانه";
      case "text":
        return content['text'] ?? "";
    }
    return "پیام قبلی";
  }
}

class Content {
  Content({
    required this.text,
  });

  final String text;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
  };
}
