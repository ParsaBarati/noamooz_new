import 'package:noamooz/Plugins/my_dropdown/dropdown_item_model.dart';
import 'package:noamooz/Utils/Api/WebControllers.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';

class FaqApi {

  Future<ApiResult> list() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.faq,
      webMethod: 'list',
      postRequest: false,
      auth: true,
    );
  }
}
