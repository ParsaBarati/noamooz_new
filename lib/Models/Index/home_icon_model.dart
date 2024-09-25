import 'package:noamooz/Models/file_model.dart';


class HomeIcon {
  final int id;
  final String title;
  final String subTitle;
  final FileModel icon;

  HomeIcon({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  factory HomeIcon.fromJson(Map<String, dynamic> json) => HomeIcon(
    id: int.tryParse(json["id"].toString()) ?? 0,
    title: json["title"],
    subTitle: json["subTitle"],
    icon: FileModel.fromJson(json["icon"]),
  );
  static List<HomeIcon> listFromJson(List data) =>
      List.from(data).map((e) => HomeIcon.fromJson(e)).toList();
  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "subTitle": subTitle,
    "icon": icon.toJson(),
  };
}
