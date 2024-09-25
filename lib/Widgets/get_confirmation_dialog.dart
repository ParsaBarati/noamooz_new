import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:iconsax/iconsax.dart';

import '../Plugins/get/get.dart';

class GetConfirmationDialog extends StatelessWidget {
  final String title;
  final double maxFontSize;
  final String text;

  const GetConfirmationDialog({
    Key? key,
    this.title = 'آیا از این عملیات اطمینان دارید؟',
    required this.text,
    required this.maxFontSize,
  }) : super(key: key);

  static Future<bool?> show({
    String title = 'آیا از این عملیات اطمینان دارید؟',
    required String text,
    required double maxFontSize,
  }) async {
    return await Get.dialog(
      GetConfirmationDialog(
        text: text,
        title: title,
        maxFontSize: maxFontSize,
      ),
      barrierColor: ColorUtils.black.shade900.withOpacity(0.8),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Container(
          width: Get.width / 1.1,
          height: Get.height / 4,
          decoration: BoxDecoration(
            color: ColorUtils.black,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Iconsax.message_question,
                      color: ColorUtils.orange,
                      size: 30,
                    ),
                    const SizedBox(width: 8,),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'iranSans',
                          color: ColorUtils.white,
                        ),
                      ),
                    ),
                  ],
                ),
                ViewUtils.sizedBox(48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: (Get.width / 1.1) - 48,
                      child: AutoSizeText(
                        text,
                        maxLines: 4,
                        minFontSize: 2.0,
                        maxFontSize: maxFontSize,
                        style: TextStyle(
                          fontSize: maxFontSize,
                          fontFamily: 'iranSans',
                          height: 1.5,
                          color: ColorUtils.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Text(
                        "انصراف",
                        style: TextStyle(
                          color: ColorUtils.white.withOpacity(0.4),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Get.back(
                          result: true,
                        );
                      },
                      child: Center(
                        child: Text(
                          "تایید",
                          style: TextStyle(
                            color: ColorUtils.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
