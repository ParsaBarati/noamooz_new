import 'dart:convert';
import 'dart:io';

import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Plugins/my_dropdown/dropdown_item_model.dart';
import 'package:noamooz/Utils/Api/WebControllers.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';
import 'package:http/http.dart' as http;

class ForumApi {

  Future<ApiResult> forums() async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.forum,
      webMethod: 'forums',
      postRequest: false,
      auth: true,
    );
  }
  Future<ApiResult> get(int forumId) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.forum,
      webMethod: '$forumId',
      postRequest: false,
      auth: true,
    );
  }


  Future<ApiResult> sendMessage({
    required Map<String, dynamic> content,
    required int forumId,
    required String type,
    required int reply,
  }) async {
    Map<String, File> files = {};
    if (content.containsKey('file')) {
      files['file'] = content['file'];
      content.remove('file');
    }
    Globals.uploadStream.add(0);

    const url = 'https://api.kafineteman.ir/v1/chat/send-message';

    final request = http.MultipartRequest('POST',Uri.parse(url));
    if (files.isNotEmpty){
      final  http.MultipartFile multipartFile =
      await http.MultipartFile.fromPath('file',files['file']?.path ?? '',);
      request.files.add(multipartFile);
    }

    Map<String,dynamic> body = {
      'forumId': forumId.toString(),
      'reply': reply.toString(),
      'type': type.toString(),
      'content': jsonEncode(content),
    };
    body.forEach((key, value) {
      request.fields[key] = value;
    });


    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.forum,
      webMethod: 'send-message',
      auth: true,
      postRequest: true,
      files: files,
      onData: (percent){
        Globals.uploadStream.add(percent);
      },
      body: {
        'forumId': forumId.toString(),
        'reply': reply.toString(),
        'type': type.toString(),
        'content': jsonEncode(content),
      },
    );
  }


}
