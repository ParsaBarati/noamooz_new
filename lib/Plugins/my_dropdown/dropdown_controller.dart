import 'dart:async';

import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Plugins/my_dropdown/dropdown_item_model.dart';

class DropdownController {
  late DropDownItemModel value;
  final RxBool isSelected = false.obs;
  final RxBool hasError = false.obs;
  final RxBool isLoading = false.obs;
  List<DropDownItemModel> items = [];
  final RxBool isOverlayShown = false.obs;
  StreamSubscription? streamSubscription;
  final StreamController dataStreamController = StreamController<List<DropDownItemModel>>.broadcast();
  final StreamController valueStreamController = StreamController<DropDownItemModel>.broadcast();

  void addListener(void Function() listenItemChanges) {
    streamSubscription?.cancel();
    streamSubscription = valueStreamController.stream.listen((event) {
      listenItemChanges();
    });
  }

  void removeListener(void Function() listenItemChanges) {
    streamSubscription?.cancel();
  }

  void loading() {
    isLoading(true);
  }
  void loaded() {
    dataStreamController.sink.add(items);
    isSelected(false);
    isLoading(false);
  }

  void onChange(DropDownItemModel value) {
    this.value = value;
    valueStreamController.sink.add(value);
    hasError(false);
    isSelected(true);
  }

}