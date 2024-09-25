import 'package:noamooz/Models/file_model.dart';

class SettingModel {
  final FileModel? splashFile;
  final FileModel? logo;
  final String name;
  final String supportNumber;
  final String transferDescription;
  final String cardNumber;

  SettingModel({
    required this.splashFile,
    required this.logo,
    required this.name,
    required this.supportNumber,
    required this.transferDescription,
    required this.cardNumber,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        splashFile: json["splashFile"] != null
            ? FileModel.fromJson(json["splashFile"])
            : null,
        logo: json['logo'] != null ? FileModel.fromJson(json["logo"]) : null,
        name: json["name"],
        supportNumber: json["supportNumber"],
        transferDescription: json["transferDescription"],
        cardNumber: json["cardNumber"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "splashFile": splashFile?.toJson(),
        "logo": logo?.toJson(),
        "name": name,
        "supportNumber": supportNumber,
        "transferDescription": transferDescription,
      };
}
