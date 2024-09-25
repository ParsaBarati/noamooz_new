import 'dart:convert';
import 'dart:io';

import 'package:noamooz/Utils/Api/WebControllers.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';

class SupportApi {
  Future<ApiResult> subjects() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.support,
      webMethod: 'subjects',
      postRequest: false,
      auth: true,
    );
  }
  Future<ApiResult> list() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.support,
      webMethod: 'list',
      postRequest: false,
      auth: true,
    );
  }

  Future<ApiResult> create({
    required String title,
    required String text,
    required int subjectId, File? file,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.support,
      webMethod: 'create',
      postRequest: true,
      auth: true,
      body: {
        'subject': subjectId.toString(),
        'title': title,
        'text': text,
        'file': file != null ? base64Encode(file.readAsBytesSync()) : "",
        'fileExt': file != null ? file.path.split('.').last : "",


      },
    );
  }
}
