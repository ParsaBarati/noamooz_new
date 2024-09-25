// To parse this JSON data, do
//
//     final menuItemModel = menuItemModelFromJson(jsonString);

import 'dart:convert';

import 'package:noamooz/Models/file_model.dart';


class MenuItemModel {
  final int id;
  final String text;
  final FileModel file;
  final String link;

  MenuItemModel({
    required this.id,
    required this.text,
    required this.file,
    required this.link,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) => MenuItemModel(
    id: int.tryParse(json["id"].toString()) ?? 0,
    text: json["text"],
    file: FileModel.fromJson(json["file"]),
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "text": text,
    "file": file.toJson(),
    "link": link,
  };
}
