import 'package:noamooz/Models/Lotteries/lottery_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';

class LotteriesController extends GetxController {
  final RxBool isLoading = false.obs;
  List<LotteryModel> lotteries = [];

  void fetchLotteries() async {
    isLoading.value = true;
    ApiResult result = await RequestsUtil.instance.lottery.list();
    if (result.isDone){
      lotteries = LotteryModel.listFromJson(result.data as List);
    } else {
      Get.back();
      ViewUtils.showErrorDialog(result.data['message'].toString());
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    fetchLotteries();
    super.onInit();
  }

  String getStatus(int status) {
    switch (status){

      case 1:
        return "در حال قرعه کشی";
      case 2:
        return "تمام شده";
      default:
        return "شروع نشده";
    }
  }
}