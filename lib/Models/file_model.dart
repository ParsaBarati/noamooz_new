import 'dart:io';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:path_provider/path_provider.dart';

class FileModel {
  final String path;
  final String thumb;
  final String alt;
  final String courseName;
  final String size;
  final RxBool fileExists = false.obs;

  bool hasBought = false;
  FileModel({
    required this.path,
    required this.courseName,
    required this.thumb,
    required this.alt,
    required this.size,
    this.hasBought = false,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
    path: json["path"],
    courseName: json["courseName"] ?? "نامشخص",
    thumb: json["thumb"],
    alt: json["alt"],
    size: json["size"],
    hasBought: json["hasBought"] == true,
  );

  Future<void> checkFileExists() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String fullPath = "${dir.path}/${path.split('/').last}";
    File file = File(fullPath);
    fileExists.value = await file.exists();
  }
  Map<String, dynamic> toJson() => {
    "path": path,
    "courseName": courseName,
    "thumb": thumb,
    "alt": alt,
    "size": size,
    "hasBought": hasBought,
  };
}