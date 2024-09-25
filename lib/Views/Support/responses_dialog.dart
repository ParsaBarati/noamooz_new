import 'package:flutter/material.dart';
import 'package:noamooz/Models/Support/ticket_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:noamooz/Views/Forum/Widgets/chat_bubble.dart';
import 'package:noamooz/Views/Support/response_bubble.dart';

import '../../Plugins/get/get.dart';

class ResponsesDialog extends StatelessWidget {
  final List<TicketModel> responses;
  const ResponsesDialog({Key? key, required this.responses, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorUtils.white,
      contentPadding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: responses.map((e) => buildResponse(e)).toList(),
        ),
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

  Widget buildResponse(TicketModel ticketModel) {
    return ResponseBubble(ticket: ticketModel,);
  }
}
