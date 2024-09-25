
import 'package:noamooz/Plugins/my_dropdown/dropdown_item_model.dart';

import '../../Plugins/get/get.dart';

class StateModel extends DropDownItemModel {
  final int id;
  final String name;

  StateModel({
    required this.id,
    required this.name,
  });

  static List<StateModel> listFromJson(List data) {
    return data.map((e) => StateModel.fromMap(e)).toList();
  }

  factory StateModel.fromMap(e) => StateModel(
        id: int.tryParse(e['id'].toString()) ?? 0,
        name: e['name'],
      );

  @override
  int dropdownId() {
    return id;
  }

  @override
  String dropdownTitle() {
    return name;
  }
}

class CityModel extends DropDownItemModel {
  final int id;
  final String name;
  final String stateId;


  CityModel({
    required this.id,
    required this.name,
    required this.stateId,
  });

  bool isSelected(List<CityModel>? selectedCities) {
    return selectedCities?.any((element) => element.id == id) ?? false;
  }

  factory CityModel.fromMap(e) => CityModel(
        id: int.tryParse(e['id'].toString()) ?? 0,
        name: e['name'],
    stateId: e['stateId'],
      );

  static List<CityModel> listFromJson(List data) {
    return data.map((e) => CityModel.fromMap(e)).toList();
  }

  @override
  int dropdownId() {
    return id;
  }

  @override


  String dropdownTitle() {
    return name;
  }

  toMap() {}
}

