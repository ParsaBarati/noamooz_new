import 'dart:convert';
import 'dart:io';

import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/Api/WebControllers.dart';
import 'package:noamooz/Utils/Api/routes/auth.dart';
import 'package:noamooz/Utils/Api/routes/blog.dart';
import 'package:noamooz/Utils/Api/routes/course.dart';
import 'package:noamooz/Utils/Api/routes/exam.dart';
import 'package:noamooz/Utils/Api/routes/faq.dart';
import 'package:noamooz/Utils/Api/routes/forum.dart';
import 'package:noamooz/Utils/Api/routes/lottery.dart';
import 'package:noamooz/Utils/Api/routes/pages.dart';
import 'package:noamooz/Utils/Api/routes/support.dart';
import 'package:noamooz/Utils/Api/routes/wallet.dart';
import 'package:noamooz/Utils/storage_utils.dart';

class RequestsUtil extends GetConnect {
  static RequestsUtil instance = RequestsUtil();
  AuthApi auth = AuthApi();
  PagesApi pages = PagesApi();
  WalletApi wallet = WalletApi();
  ExamApi exam = ExamApi();
  BlogApi blog = BlogApi();
  CourseApi course = CourseApi();
  SupportApi support = SupportApi();
  LotteryApi lottery = LotteryApi();
  FaqApi faq = FaqApi();
  ForumApi forum = ForumApi();

  static String baseRequestUrl = 'https://api.online-kiosk.ir/';
  static String version = 'v1';

  String _makePath(WebControllers webController, String webMethod) {
    String controller = webController.toString().split('.').last;
    return "${RequestsUtil.baseRequestUrl}$version/$controller/${webMethod.toString()}";
  }

  Future<ApiResult> makeRequest({
    required WebControllers webController,
    required String webMethod,
    Map<String, dynamic> body = const {},
    Map<String, String>? headers,
    bool auth = false,
    bool postRequest = false,
    Map<String, File> files = const {},
    void Function(double value)? onData,
  }) async {
    String url = _makePath(webController, webMethod);
    print("Request url: $url\nRequest body: ${jsonEncode(body)}\n");
    headers ??= {};
    String token = (await StorageUtils.auth()) ?? 'no_token';
    if (auth) {
      headers.addAll({
        'auth': (await StorageUtils.auth()) ?? 'no_token',
      });
      print(headers);
    } else if (token != 'no_token') {
      headers.addAll({
        'auth': token,
      });
    }
    late Response response;
    FormData formData = FormData(
      body,
    );
    if (files.isNotEmpty) {
      files.forEach(
        (key, value) {
          formData.files.add(
            MapEntry(
              key,
              MultipartFile(
                value,
                filename: value.path.split('/').last,
              ),
            ),
          );
        },
      );
    }
    if (postRequest) {
      response = await post(
        url,
        formData,
        uploadProgress: onData,
        headers: headers,
      );
    } else {
      response = await get(
        url,
        headers: headers,
      );
    }
    ApiResult apiResult = ApiResult();

    print(response.body);
    apiResult.status = response.statusCode ?? 0;
    apiResult.isDone = response.statusCode?.toString().split('').first == '2';
    // if (response.statusCode == 200) {
    if (response.statusCode == 403) {
      Globals.loginDialog();
      return apiResult;
    }
    try {
      apiResult.data = response.body;
      apiResult.requestedMethod = "$webController $webMethod";
    } catch (e) {
      print(e);
      apiResult.isDone = false;
      apiResult.requestedMethod = webMethod.toString().split('.').last;
      apiResult.data = response.body;
    }
    // } else {
    //   apiResult.isDone = false;
    // }
    print("\nRequest url: $url\nRequest body: ${jsonEncode(body)}\nResponse: {"
        "status: ${response.statusCode}\n"
        "isDone: ${apiResult.isDone}\n"
        "requestedMethod: ${apiResult.requestedMethod}\n"
        "data: ${apiResult.data}"
        "}");
    return apiResult;
  }
}

class ApiResult {
  late bool isDone;
  int status = 0;
  String? requestedMethod;
  dynamic data;

  ApiResult({
    this.isDone = false,
    this.requestedMethod,
    this.data,
    this.status = 0,
  });
}
