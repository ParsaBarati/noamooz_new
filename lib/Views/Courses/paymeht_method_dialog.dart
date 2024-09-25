import 'package:flutter/material.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';

import '../../Plugins/get/get.dart';

class PaymentMethodDialog extends StatefulWidget {
  const PaymentMethodDialog({super.key});

  @override
  _PaymentMethodDialogState createState() => _PaymentMethodDialogState();
}

class _PaymentMethodDialogState extends State<PaymentMethodDialog> {
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
        'انتخاب روش پرداخت',
        style: TextStyle(
          fontSize: 16,
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
                    title: "کارت به کارت",
                    textColor: ColorUtils.textColor,
                    onTap: () {
                      Get.back(
                        result: 'transfer',
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
                    title: "پرداخت آنلاین",
                    widthFactor: 1,

                    onTap: () {
                      Get.back(
                        result: 'online',
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
