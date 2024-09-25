import 'package:flutter/material.dart';
import 'package:noamooz/Models/Support/ticket_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';

import '../../Plugins/get/get.dart';

class TicketInfoDialog extends StatelessWidget {
  final TicketModel ticket;
  const TicketInfoDialog({Key? key, required this.ticket, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(12),
      backgroundColor: ColorUtils.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "عنوان: ",
                style: TextStyle(
                  color: ColorUtils.textBlack,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 6,),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ticket.title,
                      style: TextStyle(
                        color: ColorUtils.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "توضیحات: ",
                style: TextStyle(
                  color: ColorUtils.textBlack,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 6,),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ticket.text,
                      style: TextStyle(
                        letterSpacing: 1.4,
                        color: ColorUtils.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        WidgetUtils.softButton(
          title: "بستن",
          height: 24,
          fontSize: 10,
          radius: 25,
          widthFactor: 6,
          onTap: () {
            Get.close(1);
          },
        ),
      ],
    );
  }
}
