import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:noamooz/Controllers/Courses/comment_controller.dart';
import 'package:noamooz/Models/Courses/course_model.dart';

import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noamooz/Utils/widget_utils.dart';

import '../../Plugins/get/get.dart';

class CommentActionsDialog extends StatelessWidget {
  final Comment comment;
  final CommentController controller;

  const CommentActionsDialog({
    Key? key,
    required this.comment,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            width: Get.width / 1.2,
            height: controller.isEdit.isTrue ? Get.height / 5 : Get.height / 7,
            decoration: BoxDecoration(
              color: ColorUtils.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.isEdit.isTrue
                            ? "ویرایش کامنت"
                            : "عملیات مورد نظر را انتخاب کنید",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'iranSans',
                          color: ColorUtils.black,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 150),
                    child: controller.isEdit.isTrue
                        ? buildEditBody()
                        : Row(
                            children: [
                              Expanded(
                                child: WidgetUtils.softButton(
                                  title: "ویرایش",
                                  icon: Icons.edit_outlined,
                                  reverse: true,
                                  fontWeight: FontWeight.bold,
                                  onTap: () => controller.editStart(comment),
                                  color: Colors.green,
                                  widthFactor: 1,
                                ),
                              ),
                              SizedBox(
                                width: 24,
                              ),
                              Expanded(
                                child: WidgetUtils.softButton(
                                  title: "حذف",
                                  icon: Icons.delete_outline,
                                  reverse: true,
                                  color: Colors.red,
                                  onTap: () => controller.delete(comment),

                                  fontWeight: FontWeight.bold,
                                  widthFactor: 1,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEditBody() {
    return Column(
      children: [
        WidgetUtils.input(
          title: "کامنت",
          controller: controller.cController,
        ),
        ViewUtils.sizedBox(96),
        Row(
          children: [
            Expanded(
              child: WidgetUtils.outlineButton(
                title: "انصراف",
                fontSize: 24,
                onTap: () {
                  controller.cController.clear();
                  controller.isEdit.value = false;
                },
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: WidgetUtils.softButton(
                title: "تایید",
                onTap: () => controller.editConfirm(comment),
                fontSize: 24,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
