import 'package:noamooz/Utils/Api/WebControllers.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';

class BlogApi {

  Future<ApiResult> posts(int page) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.blog,
      webMethod: 'posts/$page',
      postRequest: true,
      auth: true,
    );
  }
}
