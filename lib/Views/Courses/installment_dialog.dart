import 'package:flutter/material.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/logic_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:noamooz/Widgets/form_utils.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../Plugins/get/get.dart';

class InstallmentDialog extends StatefulWidget {
  final int maxInstallmentMonths;
  final int totalPrice;

  const InstallmentDialog({
    super.key,
    required this.maxInstallmentMonths,
    required this.totalPrice,
  });

  @override
  _InstallmentDialogState createState() => _InstallmentDialogState();
}

class _InstallmentDialogState extends State<InstallmentDialog> {
  int installmentMonths = 1;

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
        'محاسبه اقساط',
        style: TextStyle(
          fontSize: 16,
          color: ColorUtils.black,
          fontWeight: FontWeight.bold,
          letterSpacing: 0,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "مبلغ هر قسط: ",
                style: TextStyle(
                  fontSize: 14,
                  color: ColorUtils.textColor,
                ),
              ),
              Text(
                LogicUtils.moneyFormat(
                    ((widget.totalPrice) / installmentMonths)),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.black,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Text(
                "تعداد اقساط: ",
                style: TextStyle(
                  fontSize: 14,
                  color: ColorUtils.textColor,
                ),
              ),
              Text(
                installmentMonths.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorUtils.black,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                "ماه",
                style: TextStyle(
                  fontSize: 14,
                  color: ColorUtils.textColor,
                ),
              ),
            ],
          ),
          Slider(
            value: installmentMonths.toDouble(),
            onChanged: (double value) {
              setState(() {
                installmentMonths = value.toInt();
              });
            },
            max: widget.maxInstallmentMonths.toDouble(),
            min: 1,
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            WidgetUtils.outlineButton(
              title: "انصراف",
              onTap: () {
                Get.back();
              },
              color: ColorUtil(ColorUtils.gray.withOpacity(0.5).value)
                  .toMaterial(),
              textColor: ColorUtil(ColorUtils.gray.withOpacity(0.5).value)
                  .toMaterial(),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: WidgetUtils.softButton(
                title: "تایید و پرداخت",
                onTap: () {
                  Get.back(result: {
                    'monthCount': installmentMonths,
                  });
                },
              ),
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
