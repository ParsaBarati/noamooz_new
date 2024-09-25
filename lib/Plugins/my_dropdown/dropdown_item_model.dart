abstract class DropDownItemModel {
  int dropdownId();

  String dropdownTitle();

  String iconPath() {
    return "";
  }

  bool get hasIcon => iconPath().isNotEmpty;
}
