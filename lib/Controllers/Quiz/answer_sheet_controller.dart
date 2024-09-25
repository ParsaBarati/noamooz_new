import 'package:noamooz/Models/Exam/answer_sheet_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AnswerSheetController extends GetxController {
  final RxBool isLoading = true.obs;
  late List<AnswerSheetModel> answerSheet;
  void getAnswerSheet(int id) async {
    isLoading.value = true;
    ApiResult result = await RequestsUtil.instance.exam.result(id);
    if (result.isDone) {
      answerSheet = List.from(result.data['answerSheet']).map((e) => AnswerSheetModel.fromJson(e)).toList();
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    int id = int.tryParse(Get.parameters['id'].toString()) ?? 0;
    if (id > 0) {
      getAnswerSheet(id);
    } else {
      Get.back();
    }
    super.onInit();
  }
}
