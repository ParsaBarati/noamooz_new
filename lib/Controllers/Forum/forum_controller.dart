import 'package:noamooz/Models/Forums/forum_model.dart';
import 'package:noamooz/Models/Lotteries/lottery_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';

class ForumController extends GetxController {
  final RxBool isLoading = false.obs;
  List<ForumModel> forums = [];


  void fetchForums() async {
    isLoading.value = true;
    ApiResult result = await RequestsUtil.instance.forum.forums();
    if (result.isDone){
      forums = ForumModel.listFromJson(result.data as List);
    } else {
      Get.back();
      ViewUtils.showErrorDialog(result.data['message'].toString());
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    fetchForums();
    super.onInit();
  }
}