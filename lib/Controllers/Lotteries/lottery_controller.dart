import 'package:noamooz/Models/Lotteries/lottery_model.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';

class LotteryController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool attendLoading = false.obs;
  final RxBool hasWon = false.obs;
  late LotteryModel lottery;
  late Prize prize;
  int lotteryId = 0;

  void fetchLottery() async {
    isLoading.value = true;
    ApiResult result = await RequestsUtil.instance.lottery.lottery(lotteryId);
    if (result.isDone) {
      lottery = LotteryModel.fromJson(result.data['lottery']);
      if (result.data['prize'] != null){
        prize = Prize.fromJson(result.data['prize']);
        hasWon.value = true;
      }
      isLoading.value = false;

    } else {
      Get.back();
      ViewUtils.showErrorDialog(result.data['message'].toString());
    }
  }

  @override
  void onInit() {
    lotteryId = int.tryParse(Get.currentRoute.split('/').last) ?? 0;
    fetchLottery();
    super.onInit();
  }

  String getStatus(int status) {
    switch (status) {
      case 1:
        return "در حال قرعه کشی";
      case 2:
        return "تمام شده";
      default:
        return "شروع نشده";
    }
  }

  void attend() async {
    attendLoading.value = true;
    ApiResult result = await RequestsUtil.instance.lottery.attend(lottery.id);
    attendLoading.value = false;
    if (result.isDone) {
      ViewUtils.showSuccessDialog(
        result.data['message'].toString(),
      );
      fetchLottery();
    } else {
      ViewUtils.showErrorDialog(
        result.data['message'].toString(),
      );
    }
  }
}
