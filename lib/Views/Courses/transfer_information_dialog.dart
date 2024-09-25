import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';

import '../../Plugins/get/get.dart';

class TransferInformationDialog extends StatefulWidget {
  const TransferInformationDialog({super.key});

  @override
  _TransferInformationDialogState createState() =>
      _TransferInformationDialogState();
}

class _TransferInformationDialogState extends State<TransferInformationDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: Colors.grey.withOpacity(0.2),
      backgroundColor: ColorUtils.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: const EdgeInsets.all(8),
      titlePadding: const EdgeInsets.all(12),
      title: Text(
        'کارت به کارت',
        style: TextStyle(
          fontSize: 16,
          color: ColorUtils.black,
          letterSpacing: 0,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            textDirection: TextDirection.ltr,
            children: [
              Text(
                Globals.settingStream.setting?.cardNumber ?? "",
                style: TextStyle(
                  color: ColorUtils.black,
                  fontSize: 16,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              WidgetUtils.smallSoftIcon(
                  icon: Icons.copy,
                  onTap: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text: Globals.settingStream.setting?.cardNumber ?? "",
                      ),
                    );
                    ViewUtils.showSuccessDialog(
                      "کپی شد!",
                      time: 1,
                    );
                  }),
            ],
          ),
          if (Globals.settingStream.setting?.transferDescription.isNotEmpty ==
              true) ...[
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    Globals.settingStream.setting?.transferDescription ?? "",
                    style: TextStyle(
                      color: ColorUtils.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      actions: [
        WidgetUtils.outlineButton(
          title: "فهمیدم!",
          onTap: () {
            Get.back();
          },
          textColor: ColorUtils.black,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
