import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:noamooz/Plugins/get/get.dart';
import 'package:noamooz/Utils/color_utils.dart';

class ViewUtils {
  static void showSuccessDialog(text, {
    String? title = 'عملیات موفق آمیز بود',
    bool undo = false,
    Function? undoAction,
    int time = 2,
    MaterialColor? color,
  }) {
    color ??= ColorUtils.green;
    Get.snackbar(
      text ?? '',
      title ?? '',
      undo: undo,
      overlayBlur: 10,
      undoAction: undoAction ?? () {},
      overlayColor: ColorUtils.black.withOpacity(0.5),
      colorText: ColorUtils.black.withOpacity(0.7),
      borderColor: color,
      borderWidth: 2,
      backgroundColor: ColorUtils.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12.0,
      ),
      icon: Icon(
        Ionicons.checkmark_circle_outline,
        color: color.shade100,
        size: Get.height / 28,
      ),
      duration: Duration(seconds: time),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void showInfoDialog([
    String? text = "خطایی رخ داد",
    String? title = 'لطفا توجه کنید',
  ]) {
    Get.snackbar(
      text ?? '',
      title ?? '',

      undo: false,
      overlayColor: ColorUtils.black.withOpacity(0.5),
      colorText: ColorUtils.black.withOpacity(0.7),
      borderColor: ColorUtils.orange,
      borderWidth: 2,
      backgroundColor: ColorUtils.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12.0,
      ),
      icon: Icon(
        Ionicons.information_circle_outline,
        size: Get.height / 28,
        color: ColorUtils.orange,

      ),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void showErrorDialog([
    String? title = "خطایی رخ داد",
    int time = 3,
    SnackPosition position = SnackPosition.BOTTOM,
  ]) {
    Get.snackbar(
      title ?? '',
      '',
      undo: false,
      borderWidth: 2,
      overlayBlur: 10,
      borderColor: ColorUtils.red,
      overlayColor: Colors.black.withOpacity(0.5),
      colorText: ColorUtils.black.withOpacity(0.7),
      backgroundColor: ColorUtils.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12.0,
      ),
      icon: Icon(
        Ionicons.warning_outline,
        color: ColorUtils.red.shade100,
        size: Get.height / 28,
      ),
      duration: Duration(
        seconds: time,
      ),
      snackPosition: position,
    );
    return;
  }

  static SizedBox sizedBox([
    double heightFactor = 24,
  ]) {
    return SizedBox(
      height: Get.height / heightFactor,
    );
  }

  static softUiDivider([MaterialColor? color, double height = 1]) {
    color ??= ColorUtils.orange;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        // gradient: LinearGradient(
        //   begin: const Alignment(-1.0, -4.0),
        //   end: const Alignment(1.0, 4.0),
        //   colors: [
        //     color,
        //     color.shade300,
        //   ],
        // ),
        // boxShadow: [
        //   BoxShadow(
        //     color: color.shade700.withOpacity(0.7),
        //     offset: const Offset(1.0, 1.0),
        //     blurRadius: 12.0,
        //     spreadRadius: 0.2,
        //   ),
        //   BoxShadow(
        //     color: color.withOpacity(0.2),
        //     offset: const Offset(-2.0, -2.0),
        //     blurRadius: 12.0,
        //     spreadRadius: 0.2,
        //   ),
        // ],
        borderRadius: BorderRadius.circular(50.0),
      ),
    );
  }

  static Widget blurWidget({
    required Widget child,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: child,
      ),
    );
  }

  static String getFileType(String last) {
    switch (last) {
      case "png":
      case "jpg":
      case "jpeg":
      case "webp":
        return "تصویر";
      case "pdf":
      case "docs":
      case "docx":
      case "xlsx":
      case "json":
        return "سند";
      case "mp3":
      case "ogg":
      case "wav":
      case "wma":
      case "amr":
        return "صوت";
      case "mp4":
      case "avi":
      case "wmv":
      case "rmvb":
      case "mpg":
      case "mpeg":
      case "3gp":
        return "ویدئو";
      default:
        return last;

    }
  }
}
