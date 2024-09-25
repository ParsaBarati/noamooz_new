import 'package:noamooz/Utils/Api/WebControllers.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';

class CommonApi {
  Future<ApiResult> index() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.common,
      webMethod: 'index',
      postRequest: false,
      auth: true,
    );
  }
  Future<ApiResult> onBoarding() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.common,
      webMethod: 'on-boarding',
      postRequest: false,
      auth: false,
    );
  }
}
