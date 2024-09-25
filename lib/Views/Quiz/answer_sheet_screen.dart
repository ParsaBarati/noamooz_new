import 'package:noamooz/Controllers/Quiz/answer_sheet_controller.dart';
import 'package:noamooz/Globals/Globals.dart';
import 'package:noamooz/Models/Exam/answer_sheet_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';

import '../../Plugins/get/get.dart';

class AnswerSheetScreen extends StatelessWidget {
  final AnswerSheetController controller = Get.put(AnswerSheetController());

  AnswerSheetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Obx(
        () => Scaffold(
          backgroundColor: ColorUtils.bgColor,
          appBar: buildAppBar(),
          body: controller.isLoading.isTrue
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    top: 24,
                    bottom: 24,
                  ),
                  child: Column(
                    children: controller.answerSheet
                        .map((e) => buildAnswer(e))
                        .toList(),
                  ),
                ),
        ),
      ),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 50,
      shadowColor: ColorUtils.orange,
      backgroundColor: ColorUtils.white,
      foregroundColor: ColorUtils.black,
      leadingWidth: 40,
      actions: [
        IconButton(
          splashRadius: 20,
          onPressed: () => Globals.toggleDarkMode(),
          icon: Icon(
            Globals.darkModeStream.darkMode
                ? Iconsax.lamp_on
                : Iconsax.lamp_slash,
            size: 26,
          ),
        ),
      ],
      title: Text(
        "پاسخنامه آزمون",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: ColorUtils.black,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget buildAnswer(AnswerSheetModel sheet) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: ColorUtils.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: ExpandablePanel(
          header: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 6,
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: sheet.answer.id == sheet.correctAnswer.id
                            ? ColorUtils.green
                            : ColorUtils.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  sheet.question,
                  style: TextStyle(
                    color: ColorUtils.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          theme: ExpandableThemeData(
            iconColor: ColorUtils.black.withOpacity(0.75),
            hasIcon: true,
            inkWellBorderRadius: BorderRadius.circular(10),
            expandIcon: Ionicons.chevron_down_outline,
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            collapseIcon: Ionicons.chevron_up_outline,
            iconSize: 20,
          ),
          collapsed: Container(),
          expanded: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "پاسخ شما: ",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: ColorUtils.black.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        sheet.answer.text,
                        softWrap: true,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: ColorUtils.black,
                        ),
                      ),
                    ),
                  ],
                ),
                if (sheet.correctAnswer.id != sheet.answer.id) ...[
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        "پاسخ صحیح: ",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: ColorUtils.black.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        sheet.correctAnswer.text,
                        softWrap: true,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: ColorUtils.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
