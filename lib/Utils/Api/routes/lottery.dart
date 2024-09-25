import 'package:noamooz/Plugins/my_dropdown/dropdown_item_model.dart';
import 'package:noamooz/Utils/Api/WebControllers.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';

class LotteryApi {

  Future<ApiResult> list() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.lottery,
      webMethod: 'list',
      postRequest: false,
      auth: true,
    );
  }
  Future<ApiResult> lottery(int lotteryId) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.lottery,
      webMethod: 'lottery/$lotteryId',
      postRequest: false,
      auth: true,
    );
  }
  Future<ApiResult> attend(int lotteryId) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.lottery,
      webMethod: 'attend/$lotteryId',
      postRequest: false,
      auth: true,
    );
  }

}
