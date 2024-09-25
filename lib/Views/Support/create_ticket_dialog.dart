import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:noamooz/Controllers/Support/support_controller.dart';
import 'package:noamooz/Plugins/my_dropdown/dropdown_controller.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:noamooz/Widgets/form_utils.dart';

import '../../Plugins/get/get.dart';

class CreateTicketDialog extends StatelessWidget {
  final SupportController controller = Get.find();
  final MyTextController title = MyTextController();
  final MyTextController text = MyTextController();
  final DropdownController subject = DropdownController();

  CreateTicketDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    subject.loading();
    subject.items = controller.subjects;
    subject.loaded();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: Get.width / 1.1,
            decoration: BoxDecoration(
              color: ColorUtils.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildHeader(),
                    const Divider(),
                    FormUtils.input(
                      title: "عنوان درخواست",
                      hint: "مثلا: مشکلی در باز کردن فایل ها دارم",
                      controller: title,
                    ),
                    FormUtils.select(
                      title: "موضوع درخواست",
                      hint: "موضوع درخواست را انتخاب کنید",
                      controller: subject,
                    ),
                    FormUtils.textArea(
                      title: "متن درخواست",
                      hint:
                          "در اینجا لطفا توضیحات بیشتری در مورد درخواست پشتیبانی خود ارائه دهید تا روند پاسخگویی به طرز چشمگیری افزایش پیدا کند.",
                      controller: text,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "فایل ضمیمه",
                            style: TextStyle(
                              color: ColorUtils.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: controller.isFilePicked.isTrue
                                      ? ColorUtils.green
                                      : ColorUtils.gray.withOpacity(0.2),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: Get.width,
                              child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () => controller.attachFile(),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 150),
                                          child: controller.isFilePicked.isTrue
                                              ? SizedBox(
                                                  height: Get.height / 12,
                                                  child: Center(
                                                    child: controller.file!.path
                                                            .split('/')
                                                            .last
                                                            .isImageFileName
                                                        ? Image.file(
                                                            controller.file!,
                                                          )
                                                        : Text(
                                                            controller.file!.path
                                                                .split('.')
                                                                .last
                                                                .capitalizeFirst!,
                                                            style: TextStyle(
                                                              color: ColorUtils
                                                                  .black,
                                                              letterSpacing: 1.3,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    Icon(
                                                      Ionicons.attach_outline,
                                                      color: ColorUtils.gray,
                                                    ),
                                                    const SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text(
                                                      "انتخاب فایل",
                                                      style: TextStyle(
                                                        color: ColorUtils.black,
                                                        fontSize: 12,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                        ),
                                      ),
                                      if (controller.isFilePicked.isTrue) ...[
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: ColorUtils.red,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Material(
                                              type: MaterialType.transparency,
                                              child: InkWell(
                                                borderRadius: BorderRadius.circular(5),
                                                onTap: () {
                                                  controller.file = null;
                                                  controller.isFilePicked.value =
                                                      false;
                                                },
                                                child: const Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Icon(
                                                    Ionicons.close_circle_outline,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ViewUtils.sizedBox(),
                    // Spacer(),
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
                                color: ColorUtils.textGray.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        WidgetUtils.softButton(
                          widthFactor: 3,
                          title: "ثبت درخواست",
                          loading: controller.submitLoading,
                          onTap: () => controller.createTicketSubmit(
                            title: title,
                            text: text,
                            subject: subject,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "ایجاد درخواست پشتیبانی",
          style: TextStyle(
            color: ColorUtils.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: (){
            Get.back();
          },
          child: Icon(
            Ionicons.close_circle_outline,
            color: ColorUtils.red,
          ),
        ),
      ],
    );
  }
}
