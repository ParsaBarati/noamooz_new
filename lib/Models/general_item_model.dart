import 'package:noamooz/Plugins/get/get.dart';

class GeneralInformationModel  {
  GeneralInformationModel({
    required this.id,
    required this.name,
    required this.details,
    required this.icon,
    this.banner,
    this.color,
  });

  final int id;
  final String name;
  String? color;
  final String details;
  final FileModel icon;
  final FileModel? banner;
  final RxBool isSelected = false.obs;
  factory GeneralInformationModel.fromJson(Map<String, dynamic> json) =>
      GeneralInformationModel(
        id: int.tryParse(json["id"].toString()) ?? 0,
        name: json["name"],
        color: json["color"],
        details: json["details"] ?? "",
        icon: FileModel.fromMap(json["icon"]),
        banner: json['banner'] != null ? FileModel.fromMap(json["banner"]) : null,
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "color": color,
    "icon": icon.toMap(),
  };

  static List<GeneralInformationModel> listFromJson(List data) {
    return data.map((e) => GeneralInformationModel.fromJson(e)).toList();
  }

  int dropdownId() {
    return id;
  }

  @override
  String dropdownTitle() {
    return name;
  }

  @override
  String iconPath() {
    return icon.path;
  }
}
class FileModel {
  FileModel({
    required this.path,
    required this.thumb,
    required this.alt,
    required this.size,
  });

  final String path;
  final String thumb;
  final String alt;
  final String size;

  factory FileModel.fromMap(Map<String, dynamic> json) => FileModel(
    path: json["path"],
    thumb: json["thumb"],
    alt: json["alt"],
    size: json["size"],
  );

  Map<String, dynamic> toMap() => {
    "path": path,
    "thumb": thumb,
    "alt": alt,
    "size": size,
  };
}

