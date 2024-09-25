import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:noamooz/Utils/Api/WebControllers.dart';
import 'package:noamooz/Utils/Api/project_request_utils.dart';

class AuthApi {
  Future<ApiResult> init({
    required String mobileEmail,
    required int isEmail,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'init',
      postRequest: true,
      body: {
        'mobileEmail': mobileEmail,
        'isEmail': isEmail,
      },
    );
  }

  Future<ApiResult> forgotPassword({
    required String mobileEmail,
    required int isEmail,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'forgot',
      postRequest: true,
      body: {
        'mobileEmail': mobileEmail,
        'isEmail': isEmail,
      },
    );
  }

  Future<ApiResult> validate({
    required String mobileEmail,
    required String code,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'validate',
      postRequest: true,
      auth: true,
      body: {
        'mobileEmail': mobileEmail,
        'code': code,
      },
    );
  }

  Future<ApiResult> login({
    required String mobile,
    required String password,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'login',
      postRequest: true,
      auth: true,
      body: {
        'mobileEmail': mobile,
        'password': password,
      },
    );
  }

  Future<ApiResult> check(String token) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'check/$token',
      postRequest: false,
      auth: true,
    );
  }

  Future<ApiResult> completeRegister({
    required String name,
    required String lastName,
    required String password,
    required String passwordConfirm,
    required String code,
    required String mobile,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'register',
      postRequest: true,
      auth: true,
      body: {
        'name': name,
        'lastName': lastName,
        'password': password,
        'code': code,
        'mobileEmail': mobile,
      },
    );
  }

  Future<ApiResult> updateProfile({
    required String firstName,
    required String lastName,
    required String birthdate,
    required String email,
    required String mobile2,
    required int gender,
    required String studyField,
    required String studyDegree,
    required int stateId,
    required int cityId,
    required String national,
  }) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'update-profile',
      postRequest: true,
      auth: true,
      body: {
        'firstName': firstName.toString(),
        'lastName': lastName.toString(),
        'birthdate': birthdate.toString(),
        'email': email.toString(),
        'mobile2': mobile2.toString(),
        'national': national.toString(),
        'gender': gender.toString(),
        'stateId': stateId.toString(),
        'cityId': cityId.toString(),
        'studyField': studyField.toString(),
        'studyDegree': studyDegree.toString(),
      },
    );
  }

  Future<ApiResult> updateImage(XFile file) async {
    return RequestsUtil.instance.makeRequest(
      webController: WebControllers.auth,
      webMethod: 'update-image',
      postRequest: true,
      auth: true,
      body: {
        'image': base64Encode(await file.readAsBytes()),
      },
    );
  }
}
