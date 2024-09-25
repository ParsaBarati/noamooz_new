import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';

import '../../Plugins/get/get.dart';


class ChangePasswordDialog extends StatelessWidget {
  final TextEditingController lastPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController newPasswordConfirm = TextEditingController();

  ChangePasswordDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Container(
          width: Get.width / 1.3,
          height: Get.height / 1.8,
          decoration: BoxDecoration(
            color: ColorUtils.black,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "لطفا رمز عبور قبلی و جدید خود را وارد کنید",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: ColorUtils.white,
                      ),
                    ),
                  ],
                ),
                ViewUtils.sizedBox(96),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: (Get.width / 1.3) - 48,
                      child: AutoSizeText(
                        "با وارد کردن رمز عبور جدید در دو مرحله از درستی رمز عبور خود اطمینان حاصل فرمایید",
                        maxLines: 4,
                        minFontSize: 2.0,
                        maxFontSize: 12.0,
                        style: TextStyle(
                          fontSize: 12.0,
                          height: 1.5,
                          color: ColorUtils.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
                ViewUtils.sizedBox(48),
                WidgetUtils.input(
                  title: "رمز عبور قبلی",
                  password: true,
                  controller: lastPassword,
                ),
                WidgetUtils.input(
                  title: "رمز عبور جدید",
                  password: true,
                  controller: newPassword,
                ),
                WidgetUtils.input(
                  title: "تایید رمز عبور جدید",
                  password: true,
                  controller: newPasswordConfirm,
                ),
                ViewUtils.sizedBox(48),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Get.back();
                      },
                      child: Center(
                        child: Text(
                          "انصراف",
                          style: TextStyle(
                            color: ColorUtils.red,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                    GestureDetector(
                      onTap: () {
                        // if (lastPassword.text.trim().isEmpty) {
                        //   ViewUtils.showErrorDialog(
                        //     "ابتدا رمز عبور قبلی را وارد کنید",
                        //   );
                        //   return;
                        // }
                        if (newPassword.text.trim().isEmpty) {
                          ViewUtils.showErrorDialog(
                            "رمز عبور جدید را وارد کنید",
                          );
                          return;
                        }
                        if (newPasswordConfirm.text.trim().isEmpty) {
                          ViewUtils.showErrorDialog(
                            "تایید رمز عبور جدید را وارد کنید",
                          );
                          return;
                        }
                        if (newPasswordConfirm.text.trim() !=
                            newPassword.text.trim()) {
                          ViewUtils.showErrorDialog(
                            "رمز عبور جدید با تاییدیه آن یکی نیست",
                          );
                          return;
                        }
                        Get.back(result: {
                          'old': lastPassword.text.trim(),
                          'new': newPassword.text.trim(),
                        });
                      },
                      child: Text(
                        "تایید",
                        style: TextStyle(
                          color: ColorUtils.white,
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
