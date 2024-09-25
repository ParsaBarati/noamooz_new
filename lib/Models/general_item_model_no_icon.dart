
import 'package:noamooz/Plugins/my_dropdown/dropdown_item_model.dart';

class GeneralInformationModelNoIcon extends DropDownItemModel {
  GeneralInformationModelNoIcon({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;
  factory GeneralInformationModelNoIcon.fromJson(Map<String, dynamic> json) =>
      GeneralInformationModelNoIcon(
        id: int.tryParse(json["id"].toString()) ?? 0,
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

  static List<GeneralInformationModelNoIcon> listFromJson(List data) {
    return data.map((e) => GeneralInformationModelNoIcon.fromJson(e)).toList();
  }

  @override
  int dropdownId() {
    return id;
  }

  @override
  String dropdownTitle() {
    return name;
  }

}