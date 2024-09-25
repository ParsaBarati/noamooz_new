import 'package:noamooz/Utils/Api/WebControllers.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';

class CourseApi {
  Future<ApiResult> buy(
    int id, {
    int monthCount = 0,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.course,
      webMethod: 'newBuy/$id',
      body: {
        'monthCount': monthCount,
      },
      postRequest: true,
      auth: true,
    );
  }

  Future<ApiResult> my() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.course,
      webMethod: 'my',
      postRequest: false,
      auth: true,
    );
  }

  Future<ApiResult> installments(String courseId) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.course,
      webMethod: 'installments/$courseId',
      postRequest: false,
      auth: true,
    );
  }

  Future<ApiResult> payInstallment(String id) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.course,
      webMethod: 'payInstallment/$id',
      postRequest: false,
      auth: true,
    );
  }
}
