import 'dart:convert';

import 'package:noamooz/Models/file_model.dart';

class BannerModel {
  final int id;
  final String link;
  final FileModel image;

  BannerModel({
    required this.id,
    required this.link,
    required this.image,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: int.tryParse(json["id"].toString()) ?? 0,
        link: json["link"],
        image: FileModel.fromJson(json["image"]),
      );

  static List<BannerModel> listFromJson(List data) =>
      List.from(data).map((e) => BannerModel.fromJson(e)).toList();

  Map<String, dynamic> toJson() => {
        "id": id,
        "link": link,
        "image": image.toJson(),
      };
}
