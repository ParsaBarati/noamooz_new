import 'package:flutter/material.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';

import '../../Plugins/get/get.dart';

class CheckInstallmentDialog extends StatefulWidget {
  const CheckInstallmentDialog({super.key});

  @override
  _CheckInstallmentDialogState createState() => _CheckInstallmentDialogState();
}

class _CheckInstallmentDialogState extends State<CheckInstallmentDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorUtils.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.all(8),
      titlePadding: const EdgeInsets.all(12),
      title: Text(
        'آیا مایل به پرداخت به صورت اقساطی هستید؟',
        style: TextStyle(
          fontSize: 14,
          color: ColorUtils.black,
          letterSpacing: 0,
        ),
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  child: WidgetUtils.outlineButton(
                    widthFactor: 1,
                    title: "خیر (پرداخت آنلاین)",
                    textColor: ColorUtils.textColor,
                    onTap: () {
                      Get.back(
                        result: false,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Expanded(
                  child: WidgetUtils.outlineButton(
                    title: "بله (مشخص کردن اقساط)",
                    widthFactor: 1,
                    onTap: () {
                      Get.back(
                        result: true,
                      );
                    },
                    textColor: ColorUtils.textColor,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
