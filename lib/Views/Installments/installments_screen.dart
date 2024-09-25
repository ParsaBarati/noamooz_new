import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:noamooz/Controllers/Installments/installments_controller.dart';
import 'package:noamooz/Models/Courses/course_model.dart';
import 'package:noamooz/Models/Courses/installment_model.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/logic_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Utils/widget_utils.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';

import '../../Plugins/get/get.dart';

class InstallmentsScreen extends StatelessWidget {
  final InstallmentsController controller = Get.put(InstallmentsController());

  InstallmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorUtils.bgColor,
        body: buildBody(),
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Widget buildCourse(CourseModel course) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ColorUtils.white,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: course.icon,
                      height: Get.height / 12,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              course.name,
                              maxLines: 1,
                              minFontSize: 12,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: ColorUtils.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              course.details,
                              maxLines: 2,
                              minFontSize: 12,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: ColorUtils.textBlack,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                Ionicons.chevron_back,
                color: ColorUtils.gray.withOpacity(0.5),
                size: 30,
              ),
            ],
          ),
        ),
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
                        if (controller.course != null) ...[
                          buildCourse(controller.course!),
                          ViewUtils.sizedBox(48),
                        ],
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: controller.installments.length,
                              separatorBuilder: (_, int index) =>
                                  const SizedBox(
                                height: 12,
                              ),
                              itemBuilder: (_, int index) => buildInstallment(
                                controller.installments[index],
                                index,
                              ),
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
      title: "لیست اقساط",
    );
  }

  Widget buildInstallment(InstallmentModel installment, int index) {
    return Container(
      decoration: BoxDecoration(
        color: ColorUtils.white,
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            // Get.toNamed(
            //   RoutingUtils.singleCourseRoute(installment.course.id),
            // );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "${index + 1}#",
                      style: TextStyle(
                        color: ColorUtils.black,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: VerticalDivider(
                        color: ColorUtils.black.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      LogicUtils.moneyFormat(
                          double.tryParse(installment.price) ?? 0),
                      style: TextStyle(
                        color: ColorUtils.black,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: VerticalDivider(
                        color: ColorUtils.black.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      "${installment.files.length} فایل",
                      style: TextStyle(
                        color: ColorUtils.black,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: VerticalDivider(
                        color: ColorUtils.black.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      installment.getStatus(),
                      style: TextStyle(
                        color: ColorUtils.black,
                      ),
                    ),
                  ],
                ),
                if (installment.status == "0") ...[
                  SizedBox(
                    height: 18,
                    width: Get.width / 2,
                    child: const Divider(thickness: 1,),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: WidgetUtils.softButton(
                          title: "پرداخت",
                          onTap: () => controller.pay(installment),
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
