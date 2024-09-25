import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:noamooz/Controllers/Support/support_controller.dart';
import 'package:noamooz/Models/Support/ticket_model.dart';
import 'package:noamooz/Plugins/datepicker/persian_datetime_picker.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Views/Support/responses_dialog.dart';
import 'package:noamooz/Views/Support/ticket_info_dialog.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';

import '../../Plugins/get/get.dart';

class SupportScreen extends StatelessWidget {
  final SupportController controller = Get.put(SupportController());

  SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorUtils.bgColor,
        body: buildBody(),
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () => controller.createTicket(),
            label: const Row(
              children: [
                Icon(
                  Ionicons.add_circle,
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "ایجاد درخواست پشتیبانی",
                  style: TextStyle(
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget buildBody() {
    return Obx(
      () => Column(
        children: [
          buildAppBar(),
          ViewUtils.sizedBox(48),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: controller.isLoading.isTrue
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.zero,
                            child: Column(
                              children: controller.tickets
                                  .map(
                                    (e) => buildTicket(e),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAppBar() {
    return MyAppBar(
      inner: true,
      title: "پشتیبانی آنلاین",
    );
  }

  Widget buildTicket(TicketModel ticket) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      width: Get.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorUtils.gray.withOpacity(0.5),
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: Wrap(
        runSpacing: 8,
        children: [
          Text(
            "شماره تیکت: ",
            style: TextStyle(
              color: ColorUtils.textBlack,
              fontSize: 12,
            ),
          ),
          Text(
            "#${ticket.id}",
            style: TextStyle(
              color: ColorUtils.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 12,
            height: 15,
            child: VerticalDivider(
              color: ColorUtils.textBlack,
            ),
          ),
          Text(
            "دپارتمان: ",
            style: TextStyle(
              color: ColorUtils.textBlack,
              fontSize: 12,
            ),
          ),
          Text(
            ticket.subject.name,
            style: TextStyle(
              color: ColorUtils.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 12,
            height: 15,
            child: VerticalDivider(
              color: ColorUtils.textBlack,
            ),
          ),
          Text(
            "تاریخ ایجاد تیکت: ",
            style: TextStyle(
              color: ColorUtils.textBlack,
              fontSize: 12,
            ),
          ),
          Text(
            DateTime.fromMillisecondsSinceEpoch(ticket.createdAt)
                .toJalali()
                .formatCompactDate(),
            style: TextStyle(
              color: ColorUtils.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 12,
            height: 15,
            child: VerticalDivider(
              color: ColorUtils.textBlack,
            ),
          ),
          Text(
            "وضعیت تیکت: ",
            style: TextStyle(
              color: ColorUtils.textBlack,
              fontSize: 12,
            ),
          ),
          Text(
            ticket.getStatusText(),
            style: TextStyle(
              color: ColorUtils.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 12,
            height: 15,
            child: VerticalDivider(
              color: ColorUtils.textBlack,
            ),
          ),
          if (ticket.hasResponse) ...[
            GestureDetector(
              onTap: (){
                Get.dialog(
                  ResponsesDialog(responses: ticket.responses,),
                  barrierColor: Colors.black.withOpacity(0.5),
                );
              },
              child: Text(
                "مشاهده پاسخ",
                style: TextStyle(
                  color: Colors.blue.shade700,
                  decoration: TextDecoration.underline,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(
              width: 12,
              height: 15,
              child: VerticalDivider(
                color: ColorUtils.textBlack,
              ),
            ),
          ],
          GestureDetector(
            onTap: () {
              Get.dialog(
                TicketInfoDialog(ticket: ticket),
                barrierColor: Colors.black.withOpacity(0.5),
              );
            },
            child: Text(
              "مشاهده تیکت",
              style: TextStyle(
                color: Colors.blue.shade700,
                decoration: TextDecoration.underline,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
