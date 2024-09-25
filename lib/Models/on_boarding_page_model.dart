import 'package:noamooz/Models/general_item_model.dart';
import 'package:noamooz/Plugins/get/get.dart';

class OnBoardingPageModel  {
  OnBoardingPageModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.details,
  });

  final int id;
  final String name;
  final String details;
  final FileModel icon;
  factory OnBoardingPageModel.fromJson(Map<String, dynamic> json) =>
      OnBoardingPageModel(
        id: int.tryParse(json["id"].toString()) ?? 0,
        name: json["name"],
        details: json["details"],
        icon: FileModel.fromMap(json["file"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "details": details,
    "icon": icon.toMap(),
  };

  static List<OnBoardingPageModel> listFromJson(List data) {
    return data.map((e) => OnBoardingPageModel.fromJson(e)).toList();
  }

}

