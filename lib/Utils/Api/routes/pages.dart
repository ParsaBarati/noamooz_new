import 'dart:convert';
import 'dart:io';

import 'package:noamooz/Utils/Api/WebControllers.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';

class PagesApi {
  Future<ApiResult> index() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.pages,
      webMethod: 'index',
      postRequest: false,
      auth: true,
    );
  }

  Future<ApiResult> categories(bool freeOnly) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.pages,
      webMethod: 'categories/${freeOnly ? "free" : "all"}',
      postRequest: false,
      auth: true,
    );
  }

  Future<ApiResult> courses(
    courseId, {
    bool free = false,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.pages,
      webMethod: 'courses/$courseId/${free ? "free" : "all"}',
      postRequest: false,
      auth: true,
    );
  }

  Future<ApiResult> course(course) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.pages,
      webMethod: 'course/$course',
      postRequest: false,
      auth: true,
    );
  }

  Future<ApiResult> onBoarding() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.pages,
      webMethod: 'on-boarding',
      postRequest: false,
      auth: false,
    );
  }

  Future<ApiResult> menuItems() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.common,
      webMethod: 'menu-items',
      postRequest: false,
      auth: false,
    );
  }

  Future<ApiResult> comment({
    required int id,
    required String text,
    required int reply,
    required File? file,
    required File? voice,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.common,
      webMethod: 'comment',
      auth: true,
      postRequest: true,
      body: {
        'text': text,
        'reply_id': reply.toString(),
        'voice': voice != null ? base64Encode(voice.readAsBytesSync()) : "",
        'file': file != null ? base64Encode(file.readAsBytesSync()) : "",
        'fileExt': file != null ? file.path.split('.').last : "",
        'voiceExt': voice != null ? voice.path.split('.').last : "",
        'course_id': id.toString(),
      },
    );
  }

  Future<ApiResult> editComment({
    required int id,
    required String text,
  }) {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.common,
      webMethod: 'edit-comment/${id}',
      auth: true,
      postRequest: true,
      body: {
        'text': text,
      },
    );
  }

  Future<ApiResult> deleteComment(int id) {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.common,
      webMethod: 'delete-comment/$id',
      auth: true,
      postRequest: false,
    );
  }
  Future<ApiResult> states() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.pages,
      webMethod: 'states',
      postRequest: false,
      auth: true,
    );
  }

  Future<ApiResult> cities(int stateId) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.pages,
      webMethod: 'cities/$stateId',
      postRequest: false,
      auth: true,
    );
  }

}
