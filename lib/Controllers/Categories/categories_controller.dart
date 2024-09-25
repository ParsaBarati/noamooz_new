import 'package:noamooz/Models/general_item_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';

class CategoriesController extends GetxController {
  final RxBool isLoading = false.obs;
  bool freeOnly = false;
  List<GeneralInformationModel> categories = [];

  @override
  void onInit() {
    freeOnly = Get.arguments['free'] ?? false;
    fetchCategories();
    super.onInit();
  }

  void fetchCategories() async {
    isLoading.value = true;
    ApiResult result = await RequestsUtil.instance.pages.categories(freeOnly);
    if (result.isDone){
      categories = GeneralInformationModel.listFromJson(result.data['categories']);
    }
    isLoading.value = false;
  }
}