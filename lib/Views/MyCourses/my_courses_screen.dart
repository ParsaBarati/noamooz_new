import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:noamooz/Controllers/MyCourses/my_courses_controller.dart';
import 'package:noamooz/Models/Courses/course_model.dart';
import 'package:noamooz/Plugins/datepicker/persian_datetime_picker.dart';
import 'package:noamooz/Utils/color_utils.dart';
import 'package:noamooz/Utils/routing_utils.dart';
import 'package:noamooz/Utils/view_utils.dart';
import 'package:noamooz/Widgets/my_app_bar.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../Plugins/get/get.dart';

class MyCoursesScreen extends StatelessWidget {
  final MyCoursesController controller = Get.put(MyCoursesController());

  MyCoursesScreen({Key? key}) : super(key: key);

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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: controller.courses.length,
                              separatorBuilder: (_, int index) =>
                                  const SizedBox(
                                height: 12,
                              ),
                              itemBuilder: (_, int index) => buildCourse(
                                controller.courses[index],
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
      title: "دوره های من",
    );
  }

  Widget buildCourse(MyCourseModel userCourse) {
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
            Get.toNamed(
              RoutingUtils.singleCourseRoute(userCourse.course.id),
            );
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
                      imageUrl: userCourse.course.icon,
                      height: Get.height / 12,
                    ),
                  ),
                  if (userCourse.hasInstallments) ...[
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorUtils.orange,
                          border: Border.all(
                            color: ColorUtils.orange,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: const Text(
                          "اقساطی",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                              userCourse.course.name,
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
                          const SizedBox(
                            width: 8,
                            height: 12,
                            child: VerticalDivider(),
                          ),
                          Row(
                            children: [
                              Text(
                                userCourse.price.toString().seRagham(),
                                maxLines: 1,
                                style: TextStyle(
                                  color: ColorUtils.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                "تومان",
                                maxLines: 1,
                                style: TextStyle(
                                  color: ColorUtils.textColor,
                                  fontSize: 10,
                                ),
                              ),
                            ],
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
                              userCourse.createdAt.toJalali().formatFullDate(),
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
            ],
          ),
        ),
      ),
    );
  }
}
