import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:noamooz/Utils/color_utils.dart';

class StorageUtils {
  static Future<String?> auth() async {
    final box = GetStorage();
    return box.read(
      'token',
    );
  }

  static setBgColor(String value) async {
    final box = GetStorage();
    return await box.write(
      'bg',
      value.toString(),
    );
  }

  static Future<Color?> bgColor() async {
    final box = GetStorage();
    var res = await box.read(
      'bg',
    );
    if (res is String) {
      return ColorUtil.fromHex(res);
    }
    return null;
  }

  static setToken(String data) async {
    final box = GetStorage();
    return await box.write(
      'token',
      data,
    );
  }

  static removeToken() async {
    final box = GetStorage();
    return await box.remove(
      'token',
    );
  }

  static Future<void> savePosition(String path, int inSeconds) async {
    final box = GetStorage();
    print(path.split('/').last);
    print(inSeconds);
    return await box.write(
      'box_${path.split('/').last}',
      inSeconds.toString(),
    );
  }
  static Future<int?> lastPosition(String path) async {
    final box = GetStorage();
    print(path.split('/').last);

    String? val = box.read(
      'box_${path.split('/').last}',
    );
    return int.tryParse(val.toString()) ?? 0;
  }
}
